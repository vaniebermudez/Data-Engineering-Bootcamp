import json
import requests

# required fields for validation
required_fields = ["transaction_id","amount","currency"]

#extraction of data from JSON
def extract_from_file(filename):
    """
    extracts from a json file
    required parameter:
        filename: string
    """
    with open(filename,'r') as file:
        data = json.load(file)
    return data

def extract_from_api(url):
    response = requests.get(url)
    if response.status_code != 200:
        raise Exception("API request failed")
    return response.json()

data_from_file = extract_from_file("transaction.json")
data_from_api = extract_from_api("https://jsonplaceholder.typicode.com/todos")
print(data_from_api)

#schema validation
def validate_schema(record):
    for field in required_fields:
        if field not in record:
            return False
    return True

def filter_valid_schema(records):
    valid_records=[]
    for record in records:
        if validate_schema(record):
            valid_records.append(record)
    return valid_records

valid_records = filter_valid_schema(data_from_file)
print(valid_records)

#cleaning of records
def clean_record(record):
    try:
        tx_id = record["transaction_id"]
        amount = float(record["amount"])
        currency = record["currency"]
        
        if tx_id is None:
            return None
        
        if amount is None:
            return None
        
        if currency is None:
            return None
        return {
            "transaction_id":tx_id,
            "amount":amount,
            "currency":currency,
            "tax":amount*0.12
        }
    except (ValueError, TypeError):
        return None

cleaned_records = [clean_record(record) for record in valid_records]
print(cleaned_records)

#deduplication
def deduplicate_records(records):
    seen_ids = set()
    unique = []

    for record in records:
        if record["transaction_id"] not in seen_ids:
            seen_ids.add(record["transaction_id"])
            unique.append(record)
    return unique

unique_records = deduplicate_records(cleaned_records)
print(unique_records)

#aggregrate
def aggregate_by_currency(records):
    totals={}

    for record in records:
        currency = record["currency"]
        totals[currency] = totals.get(currency,0) + record["amount"]
        
    return totals

aggregated_records = aggregate_by_currency(unique_records)
print(aggregated_records)

def dump_json(data,filename):
    with open(filename,'w') as file:
        json.dump(data,file,indent=4)
dump_json(unique_records,'transaction_with_tax.json')
dump_json(aggregated_records,'aggregated_by_currency.json')


#JSON -> extract -> validate -> transform -> aggregate -> dump data