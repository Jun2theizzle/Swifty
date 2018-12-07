import json
from fuzzywuzzy import fuzz

def hello(event, context):
    ratio = fuzz.partial_ratio('this is a thing', 'this is also a thing')
    body = {
        "fuzz": ratio,
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
