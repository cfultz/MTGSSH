#!/bin/bash

# Fetch a random Magic: The Gathering card and display some details

# Fetch random card data from Scryfall
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

# Display the card information
echo "Random Magic: The Gathering Card:"
echo "-----------------------------------"
echo "Name: $CARD_NAME"
echo "Type: $CARD_TYPE"
echo "Text: $CARD_TEXT"
echo

# Download the card image (art only)
curl -s -o card_art.jpg "$CARD_IMAGE"

# Display the card image as smaller ASCII art
jp2a --colors --width=50 --height=25 --color-depth=24 --background=dark card_art.jpg

# Clean up the image file
rm card_art.jpg
