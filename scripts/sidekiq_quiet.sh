#!/bin/bash

# Via gem sidekiq_alive
# https://github.com/arturictus/sidekiq_alive
# Ref: https://github.com/mperham/sidekiq/wiki/Signals

# Find pid
SIDEKIQ_PID=$(ps aux | grep sidekiq | grep busy | awk '{ print $2 }')

# Send TSTP signal
kill -SIGTSTP $SIDEKIQ_PID
