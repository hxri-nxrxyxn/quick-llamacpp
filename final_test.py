import requests
import base64

# Config
IMAGE_PATH = "input.jpg"
API_URL = "http://localhost:8080"

print("⏳ Loading image...")
with open(IMAGE_PATH, "rb") as f:
    b64_image = base64.b64encode(f.read()).decode('utf-8')

# Simple payload
payload = {
    "image_data": [{"data": b64_image}]
}

print("🚀 Sending request to Python Wrapper...")
try:
    response = requests.post(API_URL, json=payload)
    if response.status_code == 200:
        print("\n🤖 MOONDREAM SAYS:\n" + response.json()['content'])
    else:
        print("❌ Error:", response.text)
except Exception as e:
    print(f"❌ Connection Failed: {e}")
