#!/bin/bash

# Slot Fight RPG Restart Script
# Target IP: 192.168.18.9

echo "🚀 Restarting Slot Fight services..."

# 1. Kill existing processes
echo "Stopping services..."
pkill -f slotfight-backend || true
pkill -f "python3 -m http.server 23001" || true
sleep 2

# 2. Build Backend
echo "Building Backend..."
cd /home/dev/slotfight/backend
go build -o slotfight-backend .

# 3. Start Backend
echo "Starting Backend on 192.168.18.9:8080..."
nohup ./slotfight-backend > /home/dev/slotfight/backend.log 2>&1 &
echo "Backend PID: $!"
sleep 2

# 4. Build Flutter Frontend
echo "Building Flutter Frontend..."
export PATH="$HOME/flutter/bin:$PATH"
cd /home/dev/slotfight/frontend
flutter build web --release

# 5. Start Frontend
echo "Starting Flutter Frontend on 192.168.18.9:23001..."
cd /home/dev/slotfight/frontend/build/web
nohup python3 -m http.server 23001 > /home/dev/slotfight/frontend.log 2>&1 &
echo "Frontend PID: $!"

echo "--------------------------------------------------"
echo "✅ All services started!"
echo "Frontend: http://192.168.18.9:23001"
echo "Backend:  http://192.168.18.9:8080"
echo "--------------------------------------------------"
