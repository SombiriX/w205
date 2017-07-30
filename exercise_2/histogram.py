#!/usr/bin/python
import psycopg2
import argparse


def main():
    parser = argparse.ArgumentParser(description='Analyze Twitter comments')
    parser.add_argument('k1k2', nargs='?', default=None)
    args = parser.parse_args()

    try:
        k1k2 = args.k1k2.strip().split(",")
        k1 = int(k1k2[0])
        k2 = int(k1k2[1])
    except ValueError as e:
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

    connection = psycopg2.connect(
        database="tcount",
        user="postgres",
        password="pass",
        host="localhost",
        port="5432")

    cursor = connection.cursor()

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
