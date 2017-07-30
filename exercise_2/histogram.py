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
            'Analyze Twitter comments\n\n'
            'This script takes two integers k1,k2 and returns all the words '
            'with a total number of occurrences greater than or equal to k1'
            ', and less than or equal to k2.\nFor example:\n\n'
            '\t$ python histogram.py 3,8\n'
            '\t<word2>: 8\n'
            '\t<word3>: 6\n'
            '\t<word1>: 3\n'),
        formatter_class=RawTextHelpFormatter
        )

    parser.add_argument(
        'k1k2',
        nargs='?',
        default=None,
        help=(
            'Comma seperated positive integer values. K2 should be larger than'
            ' k1 otherwise the program will not produce output')
        )
    args = parser.parse_args()

    try:
        k1k2 = args.k1k2.strip().split(",")
        k1 = int(k1k2[0])
        k2 = int(k1k2[1])
    except (ValueError, IndexError) as e:
        print (
            'Input error: %s\n\n'
            'USAGE: "python histogram.py [-h] k1, k2" '
            'where k1 and k2 are positive integer values.\n') % (e.message)
        exit()
    except AttributeError as e:
        print (
            'Input error: No input\n\n'
            'USAGE: "python histogram.py [-h] k1, k2" '
            'where k1 and k2 are positive integer values.\n')
        exit()

    query = (
        'SELECT * FROM tweetwordcount '
        'where count between %s and %s '
        'order by count asc')
    data = [k1, k2]
    cursor.execute(query, data)
    entries = cursor.fetchall()
    for entry in entries:
            print '(<%s> , %s)' % (entry[0], entry[1])

if __name__ == "__main__":
    main()
