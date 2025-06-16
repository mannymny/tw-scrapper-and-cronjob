import snscrape.modules.twitter as sntwitter
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import argparse
import time
import os
import random

# Config
DAILY_LIMIT = 200
PAUSE_MIN = 5
PAUSE_MAX = 10

parser = argparse.ArgumentParser(description="Search tweets.")
parser.add_argument("--user", required=True, help="Username (without @)")
parser.add_argument("--keyword", required=True, help="Keyword")
args = parser.parse_args()

USERNAME = args.user
KEYWORD = args.keyword

# Output
folder_name = f"ss/{USERNAME}_{KEYWORD}"
os.makedirs(folder_name, exist_ok=True)

# Search
print(f"🔍 Searching up to {DAILY_LIMIT} tweets from @{USERNAME} containing '{KEYWORD}'...")
tweets = []
for tweet in sntwitter.TwitterUserScraper(USERNAME).get_items():
    if KEYWORD.lower() in tweet.content.lower():
        tweets.append(tweet)
    if len(tweets) >= DAILY_LIMIT:
        break

print(f"✅ Found {len(tweets)} matching tweets.")

options = Options()
options.add_argument("--headless")
options.add_argument("--disable-gpu")
options.add_argument("--window-size=1200,1000")
driver = webdriver.Chrome(options=options)

# SS
for i, tweet in enumerate(tweets):
    url = f"https://twitter.com/{USERNAME}/status/{tweet.id}"
    driver.get(url)
    print(f"[{i+1}/{len(tweets)}] 📸 Capturing: {url}")
    time.sleep(5)

    path = os.path.join(folder_name, f"tweet_{i+1}.png")
    driver.save_screenshot(path)
    print(f"📂 Saved to: {path}")

    pause = random.randint(PAUSE_MIN, PAUSE_MAX)
    print(f"⏳ Waiting {pause} seconds...")
    time.sleep(pause)

driver.quit()
print("🏁 All done.")
