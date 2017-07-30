from __future__ import absolute_import, print_function, unicode_literals

from collections import Counter
from streamparse.bolt import Bolt
import psycopg2
import time


class WordCounter(Bolt):

    def initialize(self, conf, ctx):
        self.counter = Counter()
        self.startTime = time.time()
        self.log('Activity formatted like "word : count"')

    def process(self, tup):
        word = tup.values[0]

        # Increment the local count
        self.counter[word] += 1
        self.emit([word, self.counter[word]])

        # Show activity
        self.log('%s: %d' % (word, self.counter[word]))

        # Update DB values every 5 seconds
        elapsed = time.time() - self.startTime
        if elapsed > 5:
            self.update_db()
            self.startTime = time.time()

    def update_db(self):
        # Update the DB using rate lmiter once every 5 seconds

        self.log('Updating database')
        for word, count in sorted(self.counter.iteritems()):
            connection = psycopg2.connect(
                database="tcount",
                user="postgres", password="pass",
                host="localhost", port="5432")
            cur = connection.cursor()
            query = (
                'SELECT * from tweetwordcount '
                'where word = %s')
            data = [word]
            cur.execute(query, data)
            if cur.fetchone() is None:
                query = (
                    'INSERT into tweetwordcount (word, count) '
                    'values(%s, %s)')
                data = [word, 1]
                cur.execute(query, data)
            else:
                query = (
                    'UPDATE tweetwordcount '
                    'set count = count + %s '
                    'where word=%s')
                data = [count, word]
                cur.execute(query, data)
            connection.commit()
        self.counter.clear()
        self.log('Counter cleared')
