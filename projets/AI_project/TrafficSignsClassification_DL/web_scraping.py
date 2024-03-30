import urllib.request
import time
from selenium import webdriver
from bs4 import BeautifulSoup
import os

# Define queries
queries = ['blue pedestrian crossing sign', 'cedez le passage panneau', 'real life traffic light', 'real life stop sign']

# Create a directory to save images
output_dir = "image_dataset"
os.makedirs(output_dir, exist_ok=True)

# Loop through each query
for query in queries:
    query_dir = os.path.join(output_dir, query.replace(' ', '_'))
    os.makedirs(query_dir, exist_ok=True)

    # Prepare query for URL
    query = '+'.join(query.split())
    url = f"https://www.google.com/search?q={query}&source=lnms&tbm=isch"

    # Initialize Selenium WebDriver
    driver = webdriver.Chrome()  # You'll need to download chromedriver and specify its path here

    # Load the Google Images page
    driver.get(url)

    # Scroll down to load more images
    scroll_pause_time = 2
    scroll_count = 5  # Adjust the number of scrolls as needed
    for _ in range(scroll_count):
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(scroll_pause_time)

    # Get the updated page HTML after scrolling
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    # Extract image URLs
    image_urls = []
    for img in soup.find_all('img'):
        if 'data-src' in img.attrs:
            image_urls.append(img.attrs['data-src'])
        elif 'src' in img.attrs:
            image_urls.append(img.attrs['src'])

    # Limit the number of images to download to 300
    image_urls = image_urls[:300]

    # Downloading images
    for idx, img_url in enumerate(image_urls):
        try:
            img_name = f"{query.replace('+', '_')}_{idx}.jpg"
            img_path = os.path.join(query_dir, img_name)
            urllib.request.urlretrieve(img_url, img_path)
            print(f"Image {idx+1}/{len(image_urls)} for '{query}' downloaded successfully")
        except Exception as e:
            print(f"Error downloading image {idx+1} for '{query}': {e}")

    # Close the Selenium WebDriver
    driver.quit()
