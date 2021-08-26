# Versions with defaults. Override with env var to build a different version.
ARG RUBY_VERSION=3.0.2
ARG POSTGRES_MAJOR_VERSION=13
ARG NODEJS_MAJOR_VERSION=16
ARG BUNDLER_VERSION=2.2.26
ARG YARN_VERSION=1.22.5

# More args
ARG USER=nonroot
ARG USER_ID=1001
ARG REVISION=not_set

###
# Development system and dependencies
###
# This will have everything needed for local development, and is targeted
# in the docker-compose via `target: development`
FROM ruby:$RUBY_VERSION-slim-buster AS development

# Args needed for this container
ARG POSTGRES_MAJOR_VERSION
ARG NODEJS_MAJOR_VERSION
ARG BUNDLER_VERSION
ARG YARN_VERSION
ARG USER
ARG USER_ID

# Recommended by hadolint
# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    # For Mac M1: uncomment wget for yarn to install below. Otherwise no need for wget and curl.
    wget \
    curl \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# IF using mimemagic, download MIME types database
# RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade && \
#   DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#     shared-mime-info \
#   && cp /usr/share/mime/packages/freedesktop.org.xml ./ \
#   && apt-get remove -y --purge shared-mime-info \
#   && apt-get clean \
#   && rm -rf /var/cache/apt/archives/* \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#   && truncate -s 0 /var/log/*log \
#   && mkdir -p /usr/share/mime/packages \
#   && cp ./freedesktop.org.xml /usr/share/mime/packages/

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $POSTGRES_MAJOR_VERSION > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODEJS_MAJOR_VERSION.x | bash -

# Add Yarn to the sources list
# For Mac M1: uncomment yarn to install below
RUN wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Install dependencies
COPY --chown=$USER:$USER ./.dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$POSTGRES_MAJOR_VERSION \
    nodejs \
    yarn=$YARN_VERSION-1 \
    "$(grep -Ev '^\s*#' /tmp/Aptfile | xargs)" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Uncomment this line if you store Bundler settings in the project's root
# ENV BUNDLE_APP_CONFIG=.bundle

# Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
# ENV PATH /app/bin:$PATH

# Upgrade RubyGems and install required Bundler version
RUN gem update --system --no-document \
 && gem install bundler:$BUNDLER_VERSION --no-document

# Add non-root user
RUN groupadd --gid 1001 $USER \
  && useradd --uid 1001 --gid $USER --shell /bin/bash --create-home $USER

# Create a directory for the app code
RUN mkdir /app \
  && chown -R $USER:$USER /app

WORKDIR /app


###
# Install Ruby gems, copied into the prod_image
###
FROM development AS prod_gems

ENV BUNDLE_PATH=/usr/local/bundle
ENV GEM_HOME=/usr/local/bundle

# Copy Gemfile and Gemfile.lock for bundler to use
COPY --chown=$USER:$USER Gemfile* ./

# Tell bundler we're building for production
RUN bundle config set deployment true \
  && bundle config set without development test \
  && bundle install


###
# Build Javascript packs
###
FROM development AS prod_packs

ENV BUNDLE_PATH=/usr/local/bundle
ENV GEM_HOME=$BUNDLE_PATH
ENV YARN_CACHE_FOLDER=/app/node_modules/.yarn-cache
ENV RAILS_ENV=production
ENV NODE_ENV=production

# COPY package.json and yarn.lock for yarn to use
COPY --chown=$USER:$USER package.json ./
COPY --chown=$USER:$USER yarn.lock ./

RUN yarn install --production --cache-folder $YARN_CACHE_FOLDER

# COPY the bundled gems from prod_gems
COPY --chown=$USER:$USER --from=prod_gems $BUNDLE_PATH $BUNDLE_PATH

# COPY the app code needed to build packs
COPY --chown=$USER:$USER . ./

# Run precompile with RAILS_MASTER_KEY passed in
RUN --mount=type=secret,id=rails_master_key,dst=/app/config/master.key \
  bin/rails assets:precompile


###
# Final production image
###
FROM ruby:$RUBY_VERSION-slim-buster AS production

# Add label for source repo. On Github, this connects the GHCR package to the repo.
LABEL org.opencontainers.image.source https://github.com/BrianSigafoos/docker-rails-webpacker-app

# Args needed for this container
ARG POSTGRES_MAJOR_VERSION
ARG USER
ARG USER_ID
ARG REVISION

ENV BUNDLE_PATH=/usr/local/bundle
ENV GEM_HOME=$BUNDLE_PATH

# Add non-root user
RUN groupadd --gid $USER_ID $USER \
  && useradd --uid $USER_ID --gid $USER --shell /bin/bash --create-home $USER

# Recommended by hadolint
# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies required for PostgreSQL and 'pg' gem.
# Do this in 1 RUN command to install curl, get what's needed for PostgreSQL,
# and then remove curl.
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade \
  # First, get gnupg2 and curl, needed to install postgresql-client
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    gnupg2 \
    curl \
  && curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $POSTGRES_MAJOR_VERSION > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update -qq \
  # Then, install postgresql-client
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  libpq-dev \
  postgresql-client-$POSTGRES_MAJOR_VERSION \
  "$(grep -Ev '^\s*#' /tmp/Aptfile | xargs)" \
  # Also, use curl to AWS RDS certs for PostgreSQL
  && mkdir -p /home/$USER/.postgresql \
  && curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
    --output /home/$USER/.postgresql/root.crt \
  # Finally, remove gnupg2 and curl
  && DEBIAN_FRONTEND=noninteractive apt-get remove -yq --purge \
    gnupg2 \
    curl \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Create a directory for the app code
RUN mkdir /app \
  && chown -R $USER:$USER /app

WORKDIR /app

# Copy in files built during earlier stages
COPY --chown=$USER:$USER --from=prod_gems $BUNDLE_PATH $BUNDLE_PATH
COPY --chown=$USER:$USER --from=prod_packs app/public/packs public/packs/
COPY --chown=$USER:$USER --from=prod_packs app/public/assets public/assets/

# Add the app code
COPY --chown=$USER:$USER . ./

# Set user to non-root $USER
# This needs to be the numeric uid, not the username, for the k8s
# securityContext: runAsNonRoot check to work.
USER $USER_ID

# Env vars for production
ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV REVISION=$REVISION

# Start web server
# bundle exec puma -C config/puma.rb
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
