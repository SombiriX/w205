#!/usr/bin/python
import argparse
from argparse import RawTextHelpFormatter

# Get DB Credentials and cursor
import os
import sys
sys.path.append(os.getcwd() + '/extweetwordcount/src')
from appCredentials.credentials import *


def main():
    parser = argparse.ArgumentParser(
        description=(
            'finalresults.py returns the total number of word '
            'occurrences in the stream. For example:\n\n'
            '\t$ python finalresults.py hello\n'
            '\tTotal number of occurrences of of "hello": 10\n\n'
            'Running finalresults.py without an argument returns all the '
            'words in the stream, and their total count of occurrences, sorted'
            ' alphabetically, one word per line. For example:\n\n'
            '\t$ python finalresults.py\n'
            '\t$ (<word1>, 2)\n\t (<word2>, 8)\n\t (<word3>, 6)\n\t '
            '(<word4>, 1)\n\t ...)'
            '\n\n'),
        formatter_class=RawTextHelpFormatter)

    parser.add_argument('input_word', nargs='?', default=None)
    args = parser.parse_args()

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
