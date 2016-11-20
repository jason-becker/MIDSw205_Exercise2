from __future__ import absolute_import, print_function, unicode_literals

from collections import Counter
from streamparse.bolt import Bolt
import psycopg2

class WordCounter(Bolt):

    def initialize(self, conf, ctx):
        self.counts = Counter()
        conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
        cur = conn.cursor()
        cur.execute("SELECT word, count FROM tweetwordcount")
        records = cur.fetchall()
        for rec in records:
            self.counts[rec[0]] = rec[1]
        conn.commit()
        conn.close()
    def process(self, tup):
        word = tup.values[0]
        word = word.lower()
        # Write codes to increment the word count in Postgres
        # Use psycopg to interact with Postgres
        # Database name: Tcount 
        # Table name: Tweetwordcount 
        # you need to create both the database and the table in advance.
        conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
        cur = conn.cursor()
        if word in self.counts.keys():
            #Update
            self.counts[word] += 1
            query = cur.mogrify("UPDATE tweetwordcount SET count=%s WHERE word=%s", (self.counts[word], word))
            cur.execute(query)
            conn.commit()
        else:
            #Insert
            self.counts[word] = 1
            query = cur.mogrify("INSERT INTO tweetwordcount (word, count) VALUES (%s, %s)", (word, 1))
            cur.execute(query)
            conn.commit()
        # Increment the local count
        self.emit([word, self.counts[word]])

        # Log the count - just to see the topology running
        self.log('%s: %d' % (word, self.counts[word]))