#!/bin/bash

# Find all images in YAML files and remove duplicates
IMAGES=$(find . -type f \( -name "*.yml" -o -name "*.yaml" \) -exec sh -c 'docker compose -f "$1" config 2>/dev/null' _ {} \; | grep 'image:' | awk '{print $2}' | sort | uniq)

# Check if any images were found
if [ -z "$IMAGES" ]; then
    echo "No images found in the YAML files."
    exit 1
fi

# Scan each image found for high and critical vulnerabilities
for image in $IMAGES; do
    echo "Scanning image: $image"
    trivy image --format json -q --output trivy_output.$(date +%y-%m-%d).json --ignore-unfixed --severity CRITICAL,HIGH "$image" | jq -r '.Results[].Vulnerabilities? // [] | .[] | "\nlibrary: \(.PkgName)\nVulnerability: \(.VulnerabilityID)\nSeverity: \(.Severity)\nInstalled Version: \(.InstalledVersion)\nFixed Version: \(.FixedVersion // "N/A")\nTitle: \(.Title)"'
done

# Next Step -> we will automate this scanner to scan this repo every week and send notification on discord. 
 
