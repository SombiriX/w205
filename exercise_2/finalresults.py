#!/usr/bin/python
import psycopg2
import argparse


def main():
    parser = argparse.ArgumentParser(description='Analyze Twitter comments')
    parser.add_argument('input_word', nargs='?', default=None)
    args = parser.parse_args()

    connection = psycopg2.connect(
        database="tcount",
        user="postgres",
        password="pass",
        host="localhost",
        port="5432")

    cursor = connection.cursor()

    if args.input_word is None:
        #list all words in alphabetic order
        query = 'SELECT * FROM tweetwordcount order by word asc'
        cursor.execute(query)
        entries = cursor.fetchall()

        for entry in entries:
                print '(<%s> , %d)' % (entry[0], entry[1])
    else:
        word = args.input_word
        query = 'SELECT count FROM tweetwordcount where word=%s'
        data = [word]
        cursor.execute(query, data)
        entries = cursor.fetchone()

        if entries is not None:
            print 'Total number of occurences of "%s": %d' % (word, entries[0])
        else:
            print 'No instance of %s in collected data' % (word)

if __name__ == "__main__":
    main()
