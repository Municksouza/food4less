#!/usr/bin/env bash
set -e

echo "→ Installing dependencies"
yarn install --frozen-lockfile
bundle install --without development test

echo "→ Building JS and CSS"
yarn build

echo "→ Preparing database"
bundle exec rails db:prepare

echo "✓ Build completed successfully"