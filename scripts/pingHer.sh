#!/bin/bash

# Endpoint that provides the list of URLs to test
source_url="https://dub.sh/mygithubapp"

# Timeout in seconds for both source and test requests
timeout=2

# First fetch the list of URLs from the source endpoint
echo "Fetching URL list from: $source_url"
url_list=$(curl -s --max-time "$timeout" "$source_url")

# Check if we successfully retrieved the URL list
if [ $? -ne 0 ]; then
    echo "Failed to fetch URL list from source endpoint"
    exit 1
fi

# Parse JSON array (requires jq) - adjust parsing based on actual response format
urls=($(echo "$url_list" | jq -r '.[]'))

# Check if we got any URLs
if [ ${#urls[@]} -eq 0 ]; then
    echo "No URLs found in the response from source endpoint"
    exit 1
fi

echo "Found ${#urls[@]} URLs to test"
echo "------------------------------"

# Test each URL from the remote list
for url in "${urls[@]}"; do
    echo "Testing: $url"
    
    response_code=$(curl -s -o /dev/null --max-time "$timeout" -w "%{http_code}" "$url")
    curl_exit_code=$?
    
    if [ $curl_exit_code -ne 0 ]; then
        case $curl_exit_code in
            6)  error="Couldn't resolve host";;
            7)  error="Failed to connect";;
            28) error="Timeout reached";;
            *)  error="Curl error code: $curl_exit_code";;
        esac
        echo "  Connection failed: $error"
    else
        if [[ $response_code =~ ^2[0-9]{2}$ ]]; then
            echo "  Success - HTTP $response_code"
        elif [[ $response_code =~ ^3[0-9]{2}$ ]]; then
            echo "  Redirection - HTTP $response_code"
        elif [[ $response_code =~ ^4[0-9]{2}$ ]]; then
            echo "  Client Error - HTTP $response_code"
        elif [[ $response_code =~ ^5[0-9]{2}$ ]]; then
            echo "  Server Error - HTTP $response_code"
        else
            echo "  Unexpected Response - HTTP $response_code"
        fi
    fi
    
    echo
done
