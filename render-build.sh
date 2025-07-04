#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Checking environment..."

# Garantir que RAILS_ENV esteja definido
export RAILS_ENV=${RAILS_ENV:-production}

# Checar se RAILS_MASTER_KEY está presente
if [[ -z "${RAILS_MASTER_KEY:-}" ]]; then
  echo "❌ RAILS_MASTER_KEY is not set. Please add it to Render's Environment Variables."
  exit 1
fi

echo "📦 Installing Ruby dependencies..."
bundle install --jobs 4 --retry 3

echo "📦 Installing JavaScript dependencies..."
yarn install --frozen-lockfile || yarn install

echo "🛠️ Building frontend assets..."
yarn build || {
  echo "❌ Asset build failed"
  exit 1
}

echo "🎨 Precompiling Rails assets..."
bundle exec rails assets:precompile || {
  echo "❌ Rails asset precompilation failed"
  exit 1
}

echo "🗄️ Running database migrations..."
bundle exec rails db:migrate

echo "📦 Loading SolidQueue schema into queue database..."
bundle exec rails runner "ActiveRecord::Base.establish_connection(:queue); load Rails.root.join('db/queue_schema.rb')"

echo "🌱 Seeding production database..."
bundle exec rails db:seed

echo "✅ Build and setup completed successfully!"