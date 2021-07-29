# Versions with defaults. Override with env var to build a different version.
ARG RUBY_VERSION=3.0.2
ARG POSTGRES_MAJOR_VERSION=13
ARG NODEJS_MAJOR_VERSION=16
ARG BUNDLER_VERSION=2.2.24
ARG YARN_VERSION=1.22.5

#
# Development system and dependencies
#
# This will have everything needed for local development, and is targeted
# in the docker-compose via tagert: development
FROM ruby:$RUBY_VERSION-slim-buster AS development

# Args needed for this container
ARG POSTGRES_MAJOR_VERSION
ARG NODEJS_MAJOR_VERSION
ARG BUNDLER_VERSION
ARG YARN_VERSION

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    wget \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Download MIME types database for mimemagic (only if you use it)
# RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
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
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
RUN wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install dependencies
COPY ./.dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$POSTGRES_MAJOR_VERSION \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(grep -Ev '^\s*#' /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

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

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app


#
# Install Ruby gems, copied into the prod_image
#
FROM development AS prod_gems

ENV BUNDLE_PATH=/usr/local/bundle
ENV GEM_HOME=/usr/local/bundle

# Copy Gemfile and Gemfile.lock for bundler to use
COPY Gemfile* ./

# Tell bundler we're building for production
RUN bundle config set deployment true \
    && bundle config set without development test

RUN bundle install


#
# Build Javascript packs
#
FROM development AS prod_packs

ENV BUNDLE_PATH=/usr/local/bundle
ENV GEM_HOME=/usr/local/bundle
ENV YARN_CACHE_FOLDER=/app/node_modules/.yarn-cache
ENV RAILS_ENV=production
ENV NODE_ENV=production

# Copy the node_modules folder from prod_packages
COPY --from=prod_gems /usr/local/bundle /usr/local/bundle

# Copy the app code needed to build packs
COPY . ./

RUN yarn install --production --cache-folder $YARN_CACHE_FOLDER
RUN bundle exec rake assets:precompile


#
# Final production image
#
FROM ruby:$RUBY_VERSION-slim-buster AS production

ENV RAILS_ENV=production
ENV BUNDLE_PATH=/usr/local/bundle
ENV GEM_HOME=/usr/local/bundle

WORKDIR /app

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

# Copy in files built during earlier stages
COPY --from=prod_gems /usr/local/bundle /usr/local/bundle
COPY --from=prod_packs app/public/packs public/packs/
COPY --from=prod_packs app/public/assets public/assets/

# Add the app code
COPY . ./
