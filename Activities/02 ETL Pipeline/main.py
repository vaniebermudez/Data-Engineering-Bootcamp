import json
import logging

logging.basicConfig(
    filename='logs/pipeline.log',
    level=logging.INFO,
    format= '%(asctime)s - %(levelname)s - %(message)s'
)

# required fields for validation
required_fields = ["transaction_id","amount","currency"]
MAX_TRANSACTION_AMOUNT = 1_000_000

def load_config():
    with open("config/config.json") as f:
        return json.load(f)

config = load_config()

input_file = config["input_file"]
tax_rate = config["tax_rate"]
taxed_output = config["taxed_output"]
aggregated_output = config["aggregated_output"]


logging.info("Pipeline started")

#extraction of data from JSON Bronze Layer
def extract_from_file(filename):
    """
    extracts from a json file
    required parameter:
        filename: string
    """
    try:
        with open(filename,'r') as file:
            data = json.load(file)
        if not data:
            logging.warning('Input File is empty.')
        return data
    except FileNotFoundError:
        logging.error(f'File not found: {filename}')
        return []
    except json.JSONDecodeError:
        logging.error(f"Invalid JSON format in file: {filename}")
        return []
    


data_from_file = extract_from_file(input_file)

logging.info(f"Extracted {len(data_from_file)} records.")

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
# print(valid_records)

#cleaning of records Silver Layer
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
        
        if amount > MAX_TRANSACTION_AMOUNT:
            logging.warning(f"Abnormally Large Amount: {amount}")
            return None

        return {
            "transaction_id":tx_id,
            "amount":amount,
            "currency":currency.upper(),
            "tax":amount*tax_rate # derived field - computed columns
        }
    
    except (ValueError, TypeError):
        return None

cleaned_records = [clean_record(record) for record in valid_records]
# print(cleaned_records)
logging.info(f"Cleaned {len(cleaned_records)} records.")

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
# print(unique_records)
logging.info(f"Deduplicated {len(unique_records)} records.")

#aggregrate Gold Layer
def aggregate_by_currency(records):
    totals={}

    for record in records:
        currency = record["currency"]
        totals[currency] = totals.get(currency,0) + record["amount"]
        
    return totals

aggregated_records = aggregate_by_currency(unique_records)
# print(aggregated_records)

def dump_json(data,filename):
    with open(filename,'w') as file:
        json.dump(data,file,indent=4)
dump_json(unique_records, taxed_output)
dump_json(aggregated_records, aggregated_output)

logging.info(f"Pipeline done. Files Exported successfully!")
#JSON -> extract -> validate -> transform -> aggregate -> dump data