import tweepy

consumer_key = "xxxxx"
consumer_secret = "xxxxx"
access_token = "xxxxx-xxxxx"
access_token_secret = "xxxxx"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)
