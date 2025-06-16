#!/bin/bash

# === Configuration ===
TWEET_USER="elonmusk"
TWEET_KEYWORD="mars"

echo "🕒 Setting timezone to America/Chicago..."
sudo timedatectl set-timezone America/Chicago

sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip unzip wget curl

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

cat > ~/tw_scraper/run_scraper.sh << EOF
#!/bin/bash
cd ~/tw_scraper
python3 tw_ss.py --user $TWEET_USER --keyword $TWEET_KEYWORD
EOF

chmod +x ~/tw_scraper/run_scraper.sh

# === Setup cron job ===
echo "🗓️ Scheduling cron job at 8:00 AM (America/Chicago)..."
(crontab -l 2>/dev/null; echo "0 8 * * * ~/tw_scraper/run_scraper.sh >> ~/tw_scraper/log.txt 2>&1") | crontab -

# === Done ===
echo "✅ Setup complete!"
echo "📁 Log: ~/tw_scraper/log.txt"
echo "▶️ To test manually: bash ~/tw_scraper/run_scraper.sh"
