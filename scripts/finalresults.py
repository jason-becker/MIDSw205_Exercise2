#This script gets a word as an argument and returns the total number of word occurrences in the stream
#For example:
    #python finalresults.py hello
    #Total number of occurrences of "hello": 10

#Running finalresults.py wihtout an argument returns all of the words in the stream and their total count of occurrences, sorted alphabetically in an ascending order, one word per line
#For example:
    #python finalresults.py
    #(<word1>, 2), (<word2>, 8), (<word3>, 6), (<word4>, 1), ...
    
import argparse
import psycopg2
parser = argparse.ArgumentParser(description='Return word counts from the database.')
parser.add_argument('searchword', metavar = 'W', type=str, nargs='?', help='word to search for')
args = parser.parse_args()


conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()

if args.searchword:
    word = args.searchword.lower()
    query = cur.mogrify("SELECT word, count FROM tweetwordcount WHERE word = %s", [word])
    cur.execute(query)
    records = cur.fetchall()
    print "Total number of occurrences of '%s': %s" % (records[0][0], records[0][1])
else:
    query = cur.mogrify("SELECT word, count FROM tweetwordcount ORDER BY word ASC")
    cur.execute(query)
    records = cur.fetchall()
    for rec in records:
        print "(<%s>, %s )" % (rec[0], rec[1])
conn.commit()
conn.close()