#!/bin/bash

echo "Shutting down n8n and ngrok..."

# 1. Kill ngrok (if running)
if pgrep ngrok > /dev/null; then
    echo "Killing ngrok..."
    killall ngrok
else
    echo "No ngrok process found."
fi

# 2. Stop Docker Compose
echo "Stopping Docker containers..."
docker compose down

echo "Shutdown complete."
