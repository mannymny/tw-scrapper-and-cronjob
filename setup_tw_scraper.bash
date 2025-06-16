#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip unzip wget curl

# === Config ===
echo "🧭 Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo "🔧 Installing ChromeDriver..."
CHROME_VERSION=$(google-chrome --version | grep -oP '[0-9.]+' | head -1 | cut -d '.' -f1)
CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
wget "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/local/bin/
sudo chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip

echo "📦 Installing Python packages..."
pip3 install snscrape selenium

mkdir -p ~/tw_scraper
cp tw_ss.py ~/tw_scraper/

# === Done ===
echo "✅ Setup complete!"
echo "👉 Run your script with:"
echo "   cd ~/tw_scraper"
echo "   python3 tw_ss.py --user elonmusk --keyword mars"
