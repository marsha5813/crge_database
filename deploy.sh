#!/bin/bash

# CRGE Database Safe Deployment Script
# Usage: ./deploy.sh "Your commit message"

set -e

COMMIT_MSG="${1:-Update site content}"

echo "🔄 Deploying CRGE Historical Database..."

# Save current branch
CURRENT_BRANCH=$(git branch --show-current)

# Ensure we're on main branch for safety
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Switching to main branch first..."
    git checkout main
fi

# Add and commit changes to main
echo "📝 Committing changes to main branch..."
git add .
git commit -m "$COMMIT_MSG" || echo "No changes to commit"
git push origin main

# Ensure _site directory exists
if [ ! -d "_site" ]; then
    echo "❌ Error: _site directory not found. Please render the site first using Quarto."
    exit 1
fi

# Create a temporary directory for safe deployment
TEMP_DIR=$(mktemp -d)
echo "📦 Using temporary directory: $TEMP_DIR"

# Copy _site contents to temp directory
cp -r _site/* "$TEMP_DIR/"

# Switch to gh-pages branch
echo "🔄 Switching to gh-pages branch..."
git checkout gh-pages

# Only remove files that should be replaced (preserve .git and other important files)
# Remove HTML files, CSS, JS, and other web assets, but keep git files
find . -maxdepth 1 -name "*.html" -delete 2>/dev/null || true
find . -maxdepth 1 -name "*.css" -delete 2>/dev/null || true
find . -maxdepth 1 -name "*.js" -delete 2>/dev/null || true
find . -maxdepth 1 -name "*.json" -delete 2>/dev/null || true
chmod -R +w site_libs en zh 2>/dev/null || true
rm -rf site_libs en zh styles.css 2>/dev/null || true

# Copy new site content from temp directory
echo "📁 Copying new site content..."
cp -r "$TEMP_DIR"/* .

# Clean up temp directory
rm -rf "$TEMP_DIR"

# Add and commit changes
echo "💾 Committing deployment..."
git add .
git commit -m "Deploy: $COMMIT_MSG" || echo "No changes to deploy"
git push origin gh-pages

# Return to original branch
echo "🔙 Returning to $CURRENT_BRANCH branch..."
git checkout "$CURRENT_BRANCH"

echo "✅ Deployment complete!"
echo "🌐 Your site will be updated at your GitHub Pages URL"
echo "⏰ Allow 2-3 minutes for changes to appear"