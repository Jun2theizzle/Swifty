import io
import os

# Imports the Google Cloud client library
from google.cloud import vision
from google.cloud.vision import types

from fuzzywuzzy import fuzz
from fuzzywuzzy import process

def doImage():
    # Instantiates a client
    client = vision.ImageAnnotatorClient()

    # The name of the image file to annotate
    file_name = os.path.join(
        os.path.dirname(__file__),
        'holy_ship_cropped.png')

    # Loads the image into memory
    with io.open(file_name, 'rb') as image_file:
        content = image_file.read()

    image = types.Image(content=content)

    # Performs label detection on the image file
    response = client.text_detection(image=image)
    texts = response.text_annotations


    print('Texts:')

    for text in texts:
        print('\n"{}"'.format(text.description.encode('utf-8')))

def doFuzz():
    wuzzy = fuzz.partial_ratio("ACME Factory", "ACME Factory Inc.")
    print(wuzzy)

if __name__ == "__main__":
    # doImage()
    doFuzz()