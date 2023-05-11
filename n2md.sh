#!/bin/bash

# Destination folder for text files
destination="$INBOX"

# Input JSON array
input_json="$@"

# Loop through each entry in the JSON array
echo "$input_json" | jq -c '.[]' | while IFS='' read -r entry; do
  # Extract fields from the JSON entry
  id=$(echo "$entry" | jq -r '.id')
  heading=$(echo "$entry" | jq -r '.heading')
  text=$(echo "$entry" | jq -r '.text' | sed 's/\\n/\'$'\n/g')
  timestamp=$(echo "$entry" | jq -r '.timestamp')

  # Split the timestamp into components
  year=${timestamp:0:2}
  month=${timestamp:2:2}
  day=${timestamp:4:2}
  hour=${timestamp:6:2}
  minute=${timestamp:8:2}

  # Format the created timestamp
  created="${year}-${month}-${day}, ${hour}:${minute}"

  # Create filename based on timestamp and heading
  filename="${timestamp}-${heading// /-}.md"



  # Create the text file
  echo -e "# ${timestamp}-${heading}\n\n${text}\n\nID: ${id}\nCreated: ${created}" > "${destination}/${filename}"
done
