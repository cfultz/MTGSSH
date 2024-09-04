#!/bin/bash

# Function to wrap text at a specific width
wrap_text() {
    local text="$1"
    local width="$2"
    echo "$text" | fold -s -w "$width"
}

# Fetch a random Magic: The Gathering card and display some details
CARD_DATA=$(curl -s https://api.scryfall.com/cards/random)

# Check if the card has multiple faces
FACES_COUNT=$(echo "$CARD_DATA" | jq -r '.card_faces | length')

if [ "$FACES_COUNT" -gt 0 ]; then
  # If it's a multi-faced card, randomly select front or back face
  SELECTED_FACE=$((RANDOM % FACES_COUNT))
  CARD_NAME=$(echo "$CARD_DATA" | jq -r ".card_faces[$SELECTED_FACE].name")
  CARD_TYPE=$(echo "$CARD_DATA" | jq -r ".card_faces[$SELECTED_FACE].type_line")
  CARD_TEXT=$(echo "$CARD_DATA" | jq -r ".card_faces[$SELECTED_FACE].oracle_text")
  CARD_IMAGE=$(echo "$CARD_DATA" | jq -r ".card_faces[$SELECTED_FACE].image_uris.art_crop")
else
  # Single-faced card
  CARD_NAME=$(echo "$CARD_DATA" | jq -r '.name')
  CARD_TYPE=$(echo "$CARD_DATA" | jq -r '.type_line')
  CARD_TEXT=$(echo "$CARD_DATA" | jq -r '.oracle_text')
  CARD_IMAGE=$(echo "$CARD_DATA" | jq -r '.image_uris.art_crop')
fi

# Set desired text width
TEXT_WIDTH=60

# Display the card information with wrapped text
echo "Random Magic: The Gathering Card:"
echo "-----------------------------------"
echo "Name: $(wrap_text "$CARD_NAME" $TEXT_WIDTH)"
echo "Type: $(wrap_text "$CARD_TYPE" $TEXT_WIDTH)"
echo "Text:"
wrap_text "$CARD_TEXT" $TEXT_WIDTH
echo

# Download the card image (art only)
curl -s -o card_art.jpg "$CARD_IMAGE"

# Display the card image as smaller ASCII art
jp2a --colors --width=50 --height=25 --color-depth=24 --background=dark card_art.jpg

# Clean up the image file
rm card_art.jpg
