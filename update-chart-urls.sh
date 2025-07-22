#!/bin/bash

# Script to update Helm chart repository URLs
# Usage: ./update-chart-urls.sh YOUR_GITHUB_USERNAME

if [ $# -eq 0 ]; then
    echo "Usage: $0 YOUR_GITHUB_USERNAME"
    echo "Example: $0 john-doe"
    exit 1
fi

USERNAME=$1
OLD_URL="https://kedacore.github.io/charts"
NEW_URL="https://${USERNAME}.github.io/charts"

echo "Updating chart URLs from ${OLD_URL} to ${NEW_URL}"

# Update the index.yaml file
sed -i.bak "s|${OLD_URL}|${NEW_URL}|g" docs/index.yaml

# Re-generate the index with correct URL
helm repo index docs --url "${NEW_URL}"

echo "URLs updated successfully!"
echo "Next steps:"
echo "1. git add ."
echo "2. git commit -m 'Add KEDA chart with AWS external ID support'"
echo "3. git push origin gh-pages"
echo "4. Enable GitHub Pages in your repository settings" 