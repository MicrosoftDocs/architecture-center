#!/bin/bash

# Script to fetch Azure updates from Microsoft Release Communications API
# and process the JSON response

set -e  # Exit on any error

# Create timestamped directory for this run
CURRENT_DATE=$(date +%Y-%m-%d-%H%M%S)
REPORT_DIR="$(pwd)/azure-update-report-$CURRENT_DATE"

# Ask user for number of days ago
echo -n "Enter the number of days ago (1-40) to fetch updates from: "
read -r DAYS_AGO

# Validate input is a number and within range
if ! [[ "$DAYS_AGO" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid number"
    exit 1
fi

if [ "$DAYS_AGO" -lt 1 ] || [ "$DAYS_AGO" -gt 40 ]; then
    echo "Error: Number of days must be between 1 and 40"
    exit 1
fi

# Calculate the date DAYS_AGO days ago (YYYY-MM-DD format)
if command -v date >/dev/null 2>&1; then
    DATE_AGO=$(date -d "$DAYS_AGO days ago" +%Y-%m-%d)
else
    echo "Error: date command not available"
    exit 1
fi

echo "Creating directory: $REPORT_DIR"
mkdir -p "$REPORT_DIR"

echo "Fetching Azure updates since $DATE_AGO..."

# Construct the API URL
API_URL="https://www.microsoft.com/releasecommunications/api/v2/azure?\$count=false&includeFacets=false&top=200&skip=0&filter=modified%20gt%20$DATE_AGO"

# Define output filename
OUTPUT_FILE="$REPORT_DIR/updates-since-$DATE_AGO.json"
TEMP_FILE="$REPORT_DIR/temp-$DATE_AGO.json"

# Fetch the data
echo "Fetching data from API..."
if command -v curl >/dev/null 2>&1; then
    curl -s -H "Accept: application/json" "$API_URL" > "$TEMP_FILE"
elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$TEMP_FILE" --header="Accept: application/json" "$API_URL"
else
    echo "Error: Neither curl nor wget is available"
    exit 1
fi

# Check if the API call was successful
if [ ! -s "$TEMP_FILE" ]; then
    echo "Error: Failed to fetch data or received empty response"
    rm -f "$TEMP_FILE"
    exit 1
fi

echo "Processing and formatting JSON..."

# Format JSON for readability - try different tools in order of preference
if command -v jq >/dev/null 2>&1; then
    jq '.' "$TEMP_FILE" > "$OUTPUT_FILE"
elif command -v json_pp >/dev/null 2>&1; then
    json_pp < "$TEMP_FILE" > "$OUTPUT_FILE"
elif command -v python3 >/dev/null 2>&1; then
    python3 -m json.tool "$TEMP_FILE" > "$OUTPUT_FILE"
else
    echo "Warning: No JSON formatting tool available (jq, json_pp, or python3)"
    echo "Saving raw JSON without formatting..."
    cp "$TEMP_FILE" "$OUTPUT_FILE"
fi

# Clean up temp file
rm -f "$TEMP_FILE"
echo "Azure updates summary saved to: $OUTPUT_FILE"
