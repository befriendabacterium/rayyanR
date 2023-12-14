# Basic usage

##pip install rayyan-sdk

from pprint import pprint
from rayyan import Rayyan

rayyan = Rayyan("rayyan_tokens.json")

# Accessing signed-in user data

from rayyan.user import User

user = User(rayyan).get_info()

# Remove request_token before printing
user.pop('request_token', None)
# Remove some other fields
user.pop('subscription', None)
# user.pop('feature_flags', None)
pprint(user)

# Retrieving the list of all reviews

from rayyan.review import Review
rayyan_review = Review(rayyan)
reviews = rayyan_review.get_all()
pprint(reviews)
print(f'Found {len(reviews["owned_reviews"])} owned reviews and {len(reviews["collab_reviews"])} shared reviews.')

# Working on the first owned review

## Printing some key review information

my_review = reviews['owned_reviews'][0]
# pprint(my_review)
print(f"Here is the first review in the list of owned reviews: '{my_review['title']}' created on '{my_review['created_at']}' 

## Listing the first 15 articles sorted by title

review_id = my_review['rayyan_id']
result_params = {
    "start": 0,
    "length": 15,
    "order[0][column]": 5,
    "order[0][dir]": "asc"
    # ... other query parameters ...
}
review_results = rayyan_review.results(review_id, result_params)
print(f'Returned {len(review_results["data"])} record(s) matching {review_results["recordsFiltered"]} record(s) out of {review_results["recordsTotal"]} 

## for index, result in enumerate(review_results['data']):
    print(f'{index+1}: {result["title"]}')
    print(f'    Authors: {", ".join(result["authors"])}')
    
    
    
from urllib import request
# access request directly.
mine = request()


import urllib.request
# used as urllib.request
mine = urllib.request()
