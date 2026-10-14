#!/bin/bash
# Keep sda awake by touching files on mounted filesystems
# More aggressive than raw device reads - touches disk every 10 seconds
while true; do
  # Touch a file on each mounted partition to ensure physical disk access
  touch /mnt/chrollo/.keepalive 2>/dev/null
  touch /mnt/hisoka/.keepalive 2>/dev/null
  touch /mnt/kurapika/.keepalive 2>/dev/null
  
  # Also sync to force writes
  sync
  
  sleep 10
done
