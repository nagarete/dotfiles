#!/bin/bash
# Comprehensive HDD keep-awake script for /dev/sda
# Uses multiple methods to prevent spindown

DRIVE="/dev/sda"
LOG_FILE="/var/log/keep_drive_awake.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Starting keep-awake service for $DRIVE"

# Method 1: Set APM to disable aggressive power management (if hdparm available)
if command -v hdparm &> /dev/null; then
    log "Setting APM to 254 (disable aggressive power management)"
    hdparm -B 254 "$DRIVE" 2>&1 | tee -a "$LOG_FILE"
    
    log "Setting spindown timeout to 0 (disable)"
    hdparm -S 0 "$DRIVE" 2>&1 | tee -a "$LOG_FILE"
fi

# Method 2: Keep reading from the drive every 15 seconds (less than 63s spin-down)
log "Starting read loop (every 15 seconds)"
while true; do
    # Read a small amount to keep the drive awake
    dd if="$DRIVE" of=/dev/null count=1 bs=512 status=none 2>/dev/null
    sleep 15
done
