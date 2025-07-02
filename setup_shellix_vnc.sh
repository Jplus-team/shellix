#!/bin/bash
echo "🛠 Cleaning up previous processes..."
pkill -f x11vnc
pkill -f fluxbox
pkill -f Xvfb
pkill -f novnc
pkill -f websockify

sleep 1

echo "🖥 Starting virtual display :1..."
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &

sleep 1
echo "🎛 Launching window manager..."
fluxbox &

sleep 1
echo "📡 Launching VNC server on :1 (port 5901)..."
x11vnc -display :1 -nopw -forever -shared -bg -rfbport 5901

sleep 2
echo "🌐 Launching noVNC on port 8888..."
cd ~/noVNC || { echo '❌ noVNC not found in ~/noVNC'; exit 1; }

./utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:8888 &

echo ""
echo "✅ Shellix is running!"
echo "👉 In GitHub Codespaces, forward port 8888 and open:"
echo "   https://<your-codespace-name>-8888.githubpreview.dev/vnc.html"