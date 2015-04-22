import twitter
import json

consumer_key = 'DTIDdIBxXapQG4Rdysv7QjbYd'
consumer_secret = 'Ioi3xMqEu2m0URzsWuucYlpdKescrDS3hLGYARdhWtI0cxhCco'
access_token_key = '838595286-xsBUkqlfEf2OwpZAVBu93vZYMMOXViquIcwO2DnS'
access_token_secret = 'q08QLnq4c0z09ytXPey1yPsDLjV0WbBnzBYVu5J76LQ2p'

auth = twitter.oauth.OAuth(access_token_key, access_token_secret, consumer_key, consumer_secret)
twitter_api = twitter.Twitter(auth=auth)
print twitter_api

q = 'man of steel'
count = 1500
language = 'en'
until = '2015-12-31'
search_results = twitter_api.search.tweets(q=q, lang = language, count=count, until=until)

statuses = search_results['statuses']

status_texts = [status['text'] for status in statuses]
# status_texts = [unicode(stat).encode('utf-8') for stat in status_texts]
# screen_names = [user_mention['screen_name'] for status in statuses for user_mention in status['entities']['user_mentions']]
# hashtags = [hashtag['text'] for status in statuses for hashtag in status['entities']['hashtags']]

words = [w for t in status_texts for w in t.split()]

print json.dumps(status_texts[0:100], indent=1)
