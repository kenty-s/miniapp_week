#!/usr/bin/env bash
set -o errexit

# Install dependencies
bundle install
yarn install

# Build assets
yarn build:css
yarn build
bundle exec rails assets:precompile
bin/rails assets:clean

# Database setup
bundle exec rails db:migrate
bundle exec rails db:seed
