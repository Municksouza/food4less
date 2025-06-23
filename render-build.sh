#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Checking prerequisites..."

if [[ -z "${RAILS_ENV:-}" ]]; then
  echo "❌ RAILS_ENV not set. Using 'production' as default."
  export RAILS_ENV=production
fi

if [[ -z "${RAILS_MASTER_KEY:-}" ]]; then
  echo "❌ RAILS_MASTER_KEY is not set. Please add it to Render's Environment Variables."
  exit 1
fi

echo "📦 Installing Ruby dependencies..."
bundle install --jobs 4 --retry 3

echo "📦 Installing JS dependencies..."
yarn install --frozen-lockfile || yarn install

echo "🛠️ Building assets"
yarn build || {
  echo "❌ Asset build failed"
  exit 1
}

echo "🛠️ Installing Solid Queue migrations"
bundle exec rails solid_queue:install

echo "🗄️ Preparing database"
bundle exec rails db:migrate

echo "🌱 Seeding database"
bundle exec rails db:seed

echo "✅ Build completed successfullyo9k
,
h           
ÇÀà