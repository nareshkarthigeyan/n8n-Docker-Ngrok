#!/bin/bash

# Check if ngrok is already running
if pgrep ngrok > /dev/null; then
    echo "An existing ngrok session is running."
    read -p "Do you want to kill all ngrok processes and start fresh? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        killall ngrok
        echo "Killed all ngrok processes. Continuing with making an n8n instance."
    else
        echo "Aborting. Please stop existing ngrok manually if needed."
        exit 1
    fi
fi

# Start ngrok in the background
echo "Starting ngrok on port 5678..."
ngrok http 5678 > ngrok.log &
NGROK_PID=$!

# Wait for ngrok API to become available
echo "Waiting for ngrok to be ready..."
for i in {1..10}; do
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels \
      | jq -r '.tunnels[] | select(.proto == "https") | .public_url')
    if [[ $NGROK_URL == https* ]]; then
        break
    fi
    sleep 1
done

if [[ $NGROK_URL != https* ]]; then
    echo "Failed to fetch ngrok URL. Is ngrok running?"
    kill $NGROK_PID
    exit 1
fi

echo "ngrok URL: $NGROK_URL"

# Update .env
echo "Updating .env file..."
if [ -f .env ]; then
    if grep -q "^WEBHOOK_URL=" .env; then
        sed -i.bak "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" .env
    else
        echo "WEBHOOK_URL=$NGROK_URL" >> .env
    fi
else
    echo "WEBHOOK_URL=$NGROK_URL" > .env
fi

# Restart docker-compose
echo "Restarting docker-compose..."
docker compose down
docker compose up -d

echo "All set! n8n is live at: $NGROK_URL"
