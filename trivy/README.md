# Trivy Vulnerability Scanning Script

This script performs vulnerability scans on container images specified in YAML configuration files within your project directory. It detects **High** and **Critical** vulnerabilities, outputs the findings in JSON format, and filters results using `jq` for better readability.

---

## Prerequisites

1. **Docker**: Ensure Docker is installed and the `docker compose` command is available.
2. **Trivy**: Install Trivy, a vulnerability scanning tool by Aqua Security.
   - To install Trivy, visit: [Trivy Installation](https://aquasecurity.github.io/trivy/v0.19.2/installation/).
3. **jq**: Install `jq` to parse JSON output for readable vulnerability summaries.
   - On Ubuntu: `sudo apt-get install jq`
   - On macOS: `brew install jq`

---

## Script Overview

The script automates these steps:
1. **Find Images in YAML Files**: It locates all container images in `.yml` or `.yaml` files using `docker compose` to parse each file, then extracts image names to scan.
2. **Remove Duplicate Images**: It sorts and deduplicates image names to ensure each unique image is scanned once.
3. **Scan Images for Vulnerabilities**: Each image is scanned with Trivy to detect **High** and **Critical** vulnerabilities, filtering out unfixed ones.

---

## Explanation of Script Options

- **`trivy image`**: Scans container images.
- **`--format json`**: Outputs results in JSON format, ideal for automated parsing and reporting.
- **`-q`**: Suppresses progress details, reducing output noise.
- **`--output trivy_output.<date>.json`**: Saves scan results to a file named with the current date.
- **`--ignore-unfixed`**: Ignores vulnerabilities without a known fix to avoid unnecessary noise.
- **`--severity CRITICAL,HIGH`**: Limits scan to only High and Critical severity vulnerabilities.

The final output is parsed with `jq` to show important details about each vulnerability: the library affected, vulnerability ID, severity, installed and fixed versions, and a short description.

---

## Usage

1. Place the script in your project’s root directory.
2. Ensure Trivy and jq are installed as per prerequisites.
3. Run the script:
   ```bash
   ./your_script_name.sh