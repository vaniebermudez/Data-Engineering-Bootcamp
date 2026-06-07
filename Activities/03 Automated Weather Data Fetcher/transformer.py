import logging
import json

def transform_data(raw_data):
    try:
        hourly = raw_data['hourly']
        time = hourly['time']
        temperature = hourly['temperature_2m']
        humidity = hourly['relativehumidity_2m']
        windspeed = hourly['windspeed_10m']

        cleaned_data = []


        for i in range(len(time)):
            record = {
                "timestamp":time[i],
                "temperature": temperature[i],
                "humidity": humidity[i],
                "windspeed": windspeed[i]
            }

            cleaned_data.append(record)

        logging.info(f"Transformed {len(cleaned_data)} records.")
        return cleaned_data
    
    except KeyError as e:
        logging.error(f"Unexpected API Format: {e}")
        return None


def save_clean_data(data, filename):
    """
    SILVER LAYER: 
    """
    with open(filename, 'w') as file:
        json.dump(data, file, indent=4)
        
    logging.info("Clean data saved successfully.")


def generate_summary(records):
    if not records:
        return None
    
    temperatures = [record['temperature'] for record in records]
    summary = {
        "record_count": len(records),
        "average_temperature": sum(temperatures)/ len(temperatures),
        "min_temperature": min(temperatures),
        "max_temperature": max(temperatures)
    }
    return summary
    logging.info("Summary generated successfully.")


def save_summary(summary, filename):
    """
    GOLD LAYER: Save weather summary to a JSON file.
    """

    with open(filename, 'w') as file:
        json.dump(summary, file, indent=4)
        logging.info("Summary saved successfully.")