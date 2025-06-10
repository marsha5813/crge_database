#!/bin/bash

# CRGE Database Deployment Script
# Usage: ./deploy.sh "Your commit message"

set -e

COMMIT_MSG="${1:-Update site content}"

echo "🔄 Deploying CRGE Historical Database..."

# Save current branch
CURRENT_BRANCH=$(git branch --show-current)

# Add and commit changes to main
echo "📝 Committing changes to main branch..."
git add .
git commit -m "$COMMIT_MSG" || echo "No changes to commit"
git push origin main

# Ensure _site directory exists
if [ ! -d "_site" ]; then
    echo "❌ Error: _site directory not found. Please render the site first in RStudio."
    exit 1
fi

# Deploy to gh-pages
echo "🚀 Deploying to GitHub Pages..."
git checkout gh-pages
git rm -rf . || true
cp -r _site/* .
git add .
git commit -m "Deploy: $COMMIT_MSG" || echo "No changes to deploy"
git push origin gh-pages

# Return to original branch
git checkout "$CURRENT_BRANCH"

echo "✅ Deployment complete!"
echo "🌐 Your site will be updated at: https://marsha5813.github.io/crge_database/"
echo "⏰ Allow 2-3 minutes for changes to appear"