# Rails with Webpacker on Docker - demo app

## Principles

- Use one Dockerfile with a multi-stage build to support both development and production builds
  - Thanks to multi-stage can target both development and production builds in 1 easier to maintain Dockerfile
- Use one docker-compose.yml to target only the "development" stage of the Dockerfile
  - Optimize for development speed (engineer happiness)
  - Make Docker fast enough for development with persisted volumes for all dependencies and generated content (bundle node_modules, packs, etc)
  - Get as close to possible as local / non-Docker development speed with separate webpack-dev-server and HMR - hot module reloading
  - All credit goes to [Ruby on Whales](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development) for this and much of the Dockerfile development target

## Setup

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
- (optional) Install [OhMyZsh](https://ohmyz.sh/) for Zsh shell shortcuts in comments below for each shell command
- (optional) Install [VSCode](https://code.visualstudio.com/) to use multi-shell tasks like "Docker development", see `.vscode/tasks.json`

## Running

- First-time only first run `docker-compose build` and `docker-compose up webpacker` to set the network and install all dependencies
- Afterwards you can use VSCode and CTRL/CMD-SHIFT-B to show "build" tasks from `.vscode/tasks.json`
- More commands with the Oh My Zsh aliases as comments (`dcb` for `docker-compose build`)...

```bash
# Script
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
# dcr --rm bash rake db:reset
docker-compose run --rm bash rake db:setup
```

## Production builds

- With target=development set in docker-compose.yml this will build an image to be used in production
- Only things needed to actually run the app like Ruby, gems, and packs will be in it.
  - No NodeJS, node_modules in the final production image

```bash
BUILD_DATE=$(date +%Y%m%d-%H%M%S)
docker build -t app:$BUILD_DATE .

# Use docker run  with ... bash to check on a build image
docker run --name app_latest --rm -i -t app:$BUILD_DATE bash
```

## Debugging

```bash
# dcr --rm bash
docker-compose run --rm bash
```


## Oh My Zsh aliases

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

## Resources

- [Ruby on Whales](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
- [Deploying Rails 6 Assets with Docker and Kubernetes](https://blog.cloud66.com/deploying-rails-6-assets-with-docker/)
