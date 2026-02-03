#!/bin/bash

# Auto-Sync Script
# Checks for changes every 60 seconds.
# If changes are found, it adds, commits, and pushes them.

INTERVAL=60

echo "Starting Auto-Sync..."
echo "Press [CTRL+C] to stop."

while true; do
    # Check if there are changes (modified, added, or deleted files)
    if [[ -n $(git status -s) ]]; then
        echo "Changes detected. Syncing..."
        
        # Pull latest changes to avoid conflicts
        git pull --rebase origin main
        
        git add .
        
        # Commit with a timestamp
        git commit -m "Auto-save: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # Push to the current branch
        git push origin HEAD
        
        echo "Sync complete at $(date '+%H:%M:%S')."
    else
        echo "No changes detected at $(date '+%H:%M:%S')."
    fi
    
    sleep $INTERVAL
done
