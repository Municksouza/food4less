#!/usr/bin/env bash
set -e

echo "→ Installing dependencies"
yarn install
bundle install

echo "→ Building JS and CSS"
yarn build

echo "→ Preparing database"
bundle exec rails db:prepare

echo "→ Done"