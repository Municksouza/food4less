#!/bin/bash

echo "🧨 RESETTING EVERYTHING FOR TEST..."

RAILS_ENV=test bin/rails db:drop db:create db:schema:load

echo "✅ Database recreated via schema.rb!"