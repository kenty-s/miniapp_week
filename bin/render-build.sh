#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails assets:precompile
bin/rails assets:clean
bundle exec rails db:migrate
