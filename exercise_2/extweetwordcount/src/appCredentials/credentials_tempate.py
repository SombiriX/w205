import tweepy
import psycopg2

consumer_key = "XXXXXXXX"
consumer_secret = "XXXXXXXX"
access_token = "XXXXXXXX-XXXXXXXX"
access_token_secret = "XXXXXXXX"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

db_name = "XXXXXXXX"
db_user = "postgres"
db_password = "pass"
db_host = "localhost"
db_port = "5432"

connection = psycopg2.connect(
    database=db_name,
    user=db_user,
    password=db_password,
    host=db_host,
    port=db_port)

cursor = connection.cursor()
