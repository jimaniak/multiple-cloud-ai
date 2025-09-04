#!/bin/bash

# GitHub Safety Check Script
# Run this before committing to ensure no sensitive data is included

echo "🔍 Checking GitHub safety..."
echo ""

# Check for sensitive files that shouldn't be committed
SENSITIVE_FILES=()

# Check for config.env files (should be ignored)
if find . -name "config.env" -not -path "./.git/*" | grep -q .; then
    echo "⚠️  Found config.env files:"
    find . -name "config.env" -not -path "./.git/*"
    SENSITIVE_FILES+=("config.env")
fi

# Check for .env files
if find . -name ".env" -not -path "./.git/*" | grep -q .; then
    echo "⚠️  Found .env files:"
    find . -name ".env" -not -path "./.git/*"
    SENSITIVE_FILES+=(".env")
fi

# Check for Google Cloud credentials
if find . -name "*.json" -not -path "./.git/*" | grep -q .; then
    echo "⚠️  Found JSON files (possible credentials):"
    find . -name "*.json" -not -path "./.git/*"
    SENSITIVE_FILES+=("*.json")
fi

# Check if git is tracking any sensitive files
if git ls-files | grep -E "(config\.env|\.env|.*\.json)$" | grep -v "\.example" | grep -q .; then
    echo "❌ Git is tracking sensitive files:"
    git ls-files | grep -E "(config\.env|\.env|.*\.json)$" | grep -v "\.example"
    SENSITIVE_FILES+=("tracked-sensitive")
fi

# Check for actual project IDs in committed files
if git ls-files | xargs grep -l "personal-assistant-471118" 2>/dev/null | grep -q .; then
    echo "❌ Found your actual project ID in tracked files:"
    git ls-files | xargs grep -l "personal-assistant-471118" 2>/dev/null
    SENSITIVE_FILES+=("project-id")
fi

echo ""

# Summary
if [ ${#SENSITIVE_FILES[@]} -eq 0 ]; then
    echo "✅ GitHub safety check PASSED!"
    echo "✅ No sensitive data found"
    echo "✅ Safe to commit and push to public repository"
    echo ""
    echo "Files that will be committed:"
    git status --porcelain | grep -E "^A|^M" | cut -c4-
    echo ""
    echo "🚀 Ready for GitHub!"
else
    echo "❌ GitHub safety check FAILED!"
    echo "❌ Found ${#SENSITIVE_FILES[@]} potential security issues"
    echo ""
    echo "🔧 To fix:"
    echo "1. Make sure .gitignore includes sensitive files"
    echo "2. Remove sensitive files from git tracking:"
    echo "   git rm --cached config.env"
    echo "3. Use only .example files for templates"
    echo "4. Never commit actual project IDs or credentials"
    echo ""
    echo "🛡️  Run this script again after fixing issues"
fi

echo ""
echo "📋 What should be in your repository:"
echo "✅ Template/ folder with .example files"
echo "✅ Documentation and guides"
echo "✅ Scripts and code"
echo "✅ .gitignore files"
echo ""
echo "❌ What should NOT be in your repository:"
echo "❌ config.env files with real project IDs"
echo "❌ .env files"
echo "❌ Google Cloud credentials (*.json)"
echo "❌ Any actual sensitive configuration"
