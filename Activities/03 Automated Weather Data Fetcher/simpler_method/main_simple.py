import requests
import json
from datetime import datetime

API_URL = "https://api.open-meteo.com/v1/forecast"

params = {
    "latitude": 14.6,
    "longitude": 120.9,
    "current_weather": True
}

try:
    response = requests.get(API_URL, params=params)

    if response.status_code == 200:
        data = response.json()

        weather_record = {
            "timestamp": datetime.now().isoformat(),
            "temperature": data["current_weather"]["temperature"],
            "windspeed": data["current_weather"]["windspeed"],
            "winddirection": data["current_weather"]["winddirection"]
        }

        try:
            with open("weather_data.json", "r") as file:
                weather_history = json.load(file)
        except:
            weather_history = []

        weather_history.append(weather_record)

        with open("weather_data.json", "w") as file:
            json.dump(weather_history, file, indent=4)

        print("Weather data saved successfully!")

    else:
        print("API request failed")

except Exception as e:
    print("Error:", e)