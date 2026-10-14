How to turn them off:
Stop OpenWebUI (Docker):
docker stop open-webui
Stop Ollama:
sudo systemctl stop ollama
To restart later:
sudo systemctl start ollama
docker start open-webui
Alternative - keep Ollama running, just stop OpenWebUI:
Ollama is lightweight when idle, so you could just stop the Docker container and keep Ollama running for quick CLI use.
Check resource usage:
nvidia-smi  # See GPU memory usage
docker stats open-webui --no-stream  # See container resources
================================================================================
                    HOW TO USE OLLAMA + OPENWEBUI
                    Complete Guide for Daily Use
================================================================================

PREREQUISITES CHECK
-------------------
Before starting, verify everything is installed:

  ollama --version          # Should show version (e.g., 0.15.2)
  docker --version          # Should show Docker version
  docker ps                 # Should work without errors

If any command fails, you need to install that component first.


STEP 1: START OLLAMA (The AI Model Server)
------------------------------------------
EXPLANATION:
Ollama is the backend that runs AI models on your RTX 3060. It must be running 
before OpenWebUI can work. Ollama runs as a background service that listens on 
port 11434 for requests.

COMMANDS:

  # Check if Ollama is already running
  ollama list

  # If Ollama is NOT running, start it:
  ollama serve

  # Or start it in background (so terminal stays free):
  ollama serve &

  # Verify Ollama is running and see your models:
  ollama list

EXPECTED OUTPUT:
You should see a list like:
  NAME                     ID              SIZE      MODIFIED
  dolphin-llama3:latest    613f068e29f8    4.7 GB    22 minutes ago


STEP 2: START OPENWEBUI (The Web Interface)
-------------------------------------------
EXPLANATION:
OpenWebUI is a web-based chat interface that connects to Ollama. It runs inside
a Docker container and provides a user-friendly way to chat with your models.
The container includes GPU support for your RTX 3060.

COMMANDS:

  # Check if OpenWebUI container exists:
  docker ps -a | grep open-webui

  # If container exists but is stopped, start it:
  docker start open-webui

  # If container doesn't exist (first time), create and run it:
  docker run -d \
    -p 3000:8080 \
    --gpus all \
    --add-host=host.docker.internal:host-gateway \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always \
    ghcr.io/open-webui/open-webui:cuda

  # Verify OpenWebUI is running:
  docker ps | grep open-webui

EXPECTED OUTPUT:
You should see open-webui in the list with STATUS "Up"


STEP 3: ACCESS THE WEB INTERFACE
--------------------------------
EXPLANATION:
Once both services are running, open your web browser to access OpenWebUI.
The interface runs locally on your machine at port 3000.

URL:
  http://localhost:3000

FIRST-TIME SETUP:
1. Open browser and go to http://localhost:3000
2. Click "Get Started" or "Sign Up"
3. Create an account (this is local, not online)
4. Enter your name, email, and password
5. Click "Create Account"
6. You'll be logged in automatically

NOTE: This account is stored locally on your machine only. No internet required.


STEP 4: USING THE SYSTEM
------------------------
EXPLANATION:
OpenWebUI provides a chat interface similar to ChatGPT. You can select models,
have conversations, save chat history, and manage settings.

HOW TO CHAT:

  1. Select a Model:
     - Look at the top center of the page
     - Click the dropdown (shows "Select a model")
     - Choose from your installed Ollama models
     - Example: "dolphin-llama3:latest"

  2. Start Chatting:
     - Type your message in the box at the bottom
     - Press Enter or click the send button
     - The AI will respond using your RTX 3060 GPU

  3. View History:
     - Look at the left sidebar
     - Previous chats are listed there
     - Click any chat to continue that conversation

  4. Start New Chat:
     - Click "+ New Chat" button (top left)
     - Or click the OpenWebUI logo


STEP 5: ADDING NEW MODELS
-------------------------
EXPLANATION:
You can add new AI models either through the command line (Ollama) or through
the OpenWebUI interface. Models downloaded via Ollama automatically appear in
OpenWebUI - no restart needed!

METHOD 1: Via Ollama CLI (Recommended for power users)

  # Download a new model (example: llama3.2)
  ollama pull llama3.2

  # Or download and run immediately
  ollama run llama3.2

  # List all available models to download
  ollama list

  # Remove a model
  ollama rm dolphin-llama3

METHOD 2: Via OpenWebUI Interface

  1. Open http://localhost:3000
  2. Click your profile (top right)
  3. Select "Admin Panel" (if available) or "Settings"
  4. Look for "Models" section
  5. Click "Pull Model" or similar button
  6. Enter model name (e.g., "llama3.2", "mistral", "codellama")
  7. Click Download
  8. Wait for download to complete

POPULAR MODELS TO TRY:
  - llama3.2 (Meta's latest, good all-rounder)
  - mistral (Fast, efficient)
  - codellama (Great for coding)
  - dolphin-mistral (Uncensored, helpful)
  - neural-chat (Good for conversations)

AUTO-SYNC:
Models downloaded via either method appear immediately in the model selector.
Just refresh the page or click the model dropdown again.


DAILY WORKFLOW (Quick Reference)
--------------------------------
EXPLANATION:
Your typical daily usage follows this pattern. Save these commands for quick
access.

START EVERYTHING (Morning):

  # 1. Start Ollama (if not already running)
  ollama serve &

  # 2. Start OpenWebUI (if not already running)
  docker start open-webui

  # 3. Open browser
  # Go to: http://localhost:3000

STOP EVERYTHING (When done):

  # Stop OpenWebUI (keeps data, stops container)
  docker stop open-webui

  # Stop Ollama (optional - can leave running)
  pkill ollama

CHECK STATUS:

  # See if Ollama is running
  ollama list

  # See if OpenWebUI is running
  docker ps | grep open-webui

  # View OpenWebUI logs (if having issues)
  docker logs open-webui


USEFUL COMMANDS REFERENCE
-------------------------

OLLAMA COMMANDS:
  ollama serve              # Start Ollama server
  ollama list               # List installed models
  ollama pull <model>       # Download a model
  ollama run <model>        # Run a model (CLI chat)
  ollama rm <model>         # Delete a model
  ollama ps                 # Show running models

DOCKER COMMANDS:
  docker start open-webui   # Start OpenWebUI container
  docker stop open-webui    # Stop OpenWebUI container
  docker ps                 # List running containers
  docker ps -a              # List all containers (including stopped)
  docker logs open-webui    # View container logs
  docker logs -f open-webui # View logs in real-time
  docker restart open-webui # Restart container
  docker rm open-webui      # Remove container (keeps data volume)
  docker system prune       # Clean up unused Docker resources

ACCESS COMMANDS:
  # Quick open in browser (if xdg-open is available)
  xdg-open http://localhost:3000


TROUBLESHOOTING
---------------

PROBLEM: "Cannot connect to Ollama" error in OpenWebUI
SOLUTION:
  1. Check Ollama is running: ollama list
  2. If not running: ollama serve &
  3. Restart OpenWebUI: docker restart open-webui

PROBLEM: OpenWebUI won't start (port 3000 in use)
SOLUTION:
  # Find what's using port 3000
  sudo lsof -i :3000
  
  # Kill the process or use different port:
  docker run -d -p 3001:8080 ...  # Use port 3001 instead

PROBLEM: Model not showing in OpenWebUI
SOLUTION:
  1. Verify model is downloaded: ollama list
  2. Refresh browser page (F5)
  3. Click model selector dropdown again
  4. Restart OpenWebUI if still missing: docker restart open-webui

PROBLEM: GPU not being used (slow responses)
SOLUTION:
  1. Check GPU is detected: nvidia-smi
  2. Verify Docker GPU support: docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu20.04 nvidia-smi
  3. Recreate container with --gpus all flag

PROBLEM: Forgot OpenWebUI password
SOLUTION:
  # Reset by removing user data (you'll need to recreate account)
  docker volume rm open-webui
  docker rm open-webui
  # Then recreate container with docker run command above

PROBLEM: "Connection refused" when accessing localhost:3000
SOLUTION:
  1. Check container is running: docker ps
  2. Check logs for errors: docker logs open-webui
  3. Verify firewall isn't blocking port 3000
  4. Try accessing via: http://127.0.0.1:3000


ADVANCED TIPS
-------------

BACKUP YOUR DATA:
OpenWebUI stores chats and settings in a Docker volume. To backup:

  # Create backup
  docker run --rm -v open-webui:/data -v $(pwd):/backup alpine tar czf /backup/openwebui-backup.tar.gz -C /data .

  # Restore backup
  docker run --rm -v open-webui:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/openwebui-backup.tar.gz"

UPDATE OPENWEBUI:
To get the latest version:

  docker pull ghcr.io/open-webui/open-webui:cuda
  docker stop open-webui
  docker rm open-webui
  # Then run the docker run command from Step 2 again

CUSTOMIZE SETTINGS:
- Click your profile (top right)
- Go to "Settings"
- Adjust theme, language, default model, etc.

ENABLE WEB SEARCH (Optional):
In OpenWebUI settings, you can enable web search integration for models to
access current information.


QUICK START SCRIPT (Save this!)
-------------------------------
Create a file ~/start-ai.sh with this content:

  #!/bin/bash
  echo "Starting Ollama..."
  ollama serve &
  sleep 2
  echo "Starting OpenWebUI..."
  docker start open-webui || docker run -d \
    -p 3000:8080 \
    --gpus all \
    --add-host=host.docker.internal:host-gateway \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always \
    ghcr.io/open-webui/open-webui:cuda
  sleep 2
  echo "Opening browser..."
  xdg-open http://localhost:3000 &
  echo "Done! OpenWebUI is running at http://localhost:3000"

Make it executable:
  chmod +x ~/start-ai.sh

Run it:
  ~/start-ai.sh


================================================================================
                           END OF GUIDE
================================================================================

For more help:
- Ollama docs: https://github.com/ollama/ollama
- OpenWebUI docs: https://docs.openwebui.com/
- Your models are stored in: ~/.ollama/models
- OpenWebUI data is stored in: Docker volume "open-webui"

Happy chatting with your AI! 🤖
