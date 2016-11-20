#This script gets two integers k1, k2 and returns all the wrods that their total number of occurrences in the stream is more or 
#equal to k1 
#and less or equal than k2.
#For example:
    #python histogram.py 3,8
    #   <word2>: 8
    #   <word3>: 6
    #   <word1>: 3
    
import psycopg2
import argparse
parser = argparse.ArgumentParser(description='Return word counts from the database within a range.')
parser.add_argument('low', metavar = 'L', type=int, nargs=1, help='lower bound')
parser.add_argument('high', metavar = 'H', type=int, nargs='?', help='upper bound')
args = parser.parse_args()
if not args.high:
    args.high = args.low[0]
elif args.low[0] > args.high:
    nlow = args.high
    nhigh = args.low[0]
else:
    nhigh = args.high
    nlow = args.low[0]

conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()
query = cur.mogrify("SELECT word, count FROM tweetwordcount WHERE count >= %s AND count <= %s ORDER BY count ASC", (nlow, nhigh))
cur.execute(query)
records = cur.fetchall()
for rec in records:
    print "(<%s>, %s )" % (rec[0], rec[1])
conn.commit()
conn.close()