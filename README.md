# Rails with Webpacker on Docker - demo app

## Principles

- One `Dockerfile` with multi-stage builds to support both development and production builds.
  - Thanks to [Docker multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/), we can target both development and production builds in 1 easy to maintain Dockerfile
- One `docker-compose.yml` to target only the "development" stage of the Dockerfile, optimized for development speed, aka engineer happiness.
  - Make Docker fast enough for development with persisted volumes for all dependencies and generated content (bundle node_modules, packs, etc)
  - Get as close as possible to local / non-Docker development speed with separate webpack-dev-server and HMR - hot module reloading
  - All credit goes to [Ruby on Whales](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development) for this and much of the Dockerfile development target
- Automate setting up Docker/local development with VS Code tasks.
  - Run "build" tasks in VS Code that open/reload multiple shells for either:
    - Docker development
    - Local development
- IN PROGRESS - Github Actions CI/CD pipeline to Kubernetes

## Setup

### Install

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
- (recommended) Install [OhMyZsh](https://ohmyz.sh/) for Zsh shell shortcuts in comments below for each shell command
- (recommended) Install [VS Code](https://code.visualstudio.com/) to use multi-shell tasks like "Docker development", see `.vscode/tasks.json`

### Run

- If you clone this repo, you'll need to recreate the `config/credentials.yml.enc`
- And for Github Actions to work, you'll need to set `RAILS_MASTER_KEY` in the Repo Settings :: Secrets.

```shell
# Step 1
# Delete example credentials.yml.enc
rm config/credentials.yml.enc
EDITOR=vim rails credentials:edit
# Then type: `:wq` to exit and save

# Step 2
# NEXT: Copy and paste the value now in config/master.key
# into the Github repository secrets as `RAILS_MASTER_KEY`

# Step 3
# Push up a commit and then trigger a build
.dockerdev/build.sh
```

- More initial setup for local development

```shell

# Build the development (target) image
# dcb     <- Oh My Zsh shortcut (if installed)
docker-compose build

# Set up database by running rake db:setup  (rake db:create; rake db:schema_load)
# dcr --rm bash rake db:setup   <- Oh My Zsh shortcut (if installed)
docker-compose run --rm bash rake db:setup
```

## Development

- Use VS Code and CTRL/CMD-SHIFT-B to show "build" tasks from `.vscode/tasks.json`
  - Docker development
  - Local development
- Or manually run whatever you like, typically for development
  - `docker-compose up webpacker` - install gems, packages, and run webpack-dev-server
  - `docker-compose up rails` - run rails server
  - `docker-compose run --rm bash` - a "runner" to keep up for quick debugging
- Note: Oh My Zsh aliases are comments below (`dcb` for `docker-compose build`)...

```bash
# Script to start Docker on Mac
.dockerdev/docker-start.sh

# dcb
docker-compose build

# dcup webpacker
docker-compose up webpacker

# dcup rails
docker-compose up rails

# Keep this bash "runner" up for db:migrate, rails c, etc
# dcr --rm bash
docker-compose run --rm bash

# Rake tasks
# dcr --rm bash rake db:migrate
docker-compose run --rm bash rake db:migrate

# dcr --rm bash rake db:setup
docker-compose run --rm bash rake db:setup

# dcr --rm bash rake db:reset
docker-compose run --rm bash rake db:reset
```

## Production builds

- Calling `docker build` on the Dockerfile _without_ target=development will build an image for production
  - The production image only includes the app's code, Ruby, gems, and precompiled packs and assets.
    - No NodeJS, node_modules in the final production image

```bash
BUILD_DATE=$(date +%Y%m%d-%H%M%S)
docker build -t demo_app:$BUILD_DATE .

# Use docker run  with `bash` to check on that build image
docker run --name demo_app_latest --rm -i -t demo_app:$BUILD_DATE bash
```

## Debugging

```bash
# dcr --rm bash
docker-compose run --rm bash
```

## Oh My Zsh aliases for Docker

```bash
dcb='docker-compose build'
dcdn='docker-compose down'
dce='docker-compose exec'
dck='docker-compose kill'
dcl='docker-compose logs'
dclf='docker-compose logs -f'
dco=docker-compose
dcps='docker-compose ps'
dcpull='docker-compose pull'
dcr='docker-compose run'
dcrestart='docker-compose restart'
dcrm='docker-compose rm'
dcstart='docker-compose start'
dcstop='docker-compose stop'
dcup='docker-compose up'
dcupb='docker-compose up --build'
dcupd='docker-compose up -d'
```

## Clean up

```bash
# Remove dangling containers, images, volumes, etc
docker system prune

# Remove ALL stopped, not just dangling
docker system prune -a

# Remove ALL stopped, including volumes (local data loss!)
 docker system prune -a --volumes
```

## Credits and Resources

- [How to use docker multi-stage build to create optimal images for dev and production](https://geshan.com.np/blog/2019/11/how-to-use-docker-multi-stage-build/)
- [Ruby on Whales: Dockerizing Ruby and Rails development](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
- [Running a Rails app with Webpacker and Docker](https://medium.com/@dirkdk/running-a-rails-app-with-webpacker-and-docker-8d29153d3446)
- [Github Actions to deploy to K8s - Valikube Actions](https://github.com/ValiMail/valikube-actions)

## More Reading

- [Build images on GitHub Actions with Docker layer caching](https://evilmartians.com/chronicles/build-images-on-github-actions-with-docker-layer-caching)
- [Deploying Rails 6 Assets with Docker and Kubernetes](https://blog.cloud66.com/deploying-rails-6-assets-with-docker/)

## Linting

Use [hadolint](https://github.com/hadolint/hadolint) to lint: `hadolint Dockerfile`

## Misc

### Git hooks

- Copy and paste code below to protect `main` branch from git push by admins

```bash
cat << 'DOC' > .git/hooks/pre-push
#!/bin/bash

protected_branch='main'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [ $protected_branch = $current_branch ]
then
    read -p "You're about to push to main, is that what you intended? [y|n] " -n 1 -r < /dev/tty
    echo
    if echo $REPLY | grep -E '^[Yy]$' > /dev/null
    then
        exit 0 # push will execute
    fi
    exit 1 # push will not execute
else
    exit 0 # push will execute
fi
DOC

chmod +x .git/hooks/pre-push
```
