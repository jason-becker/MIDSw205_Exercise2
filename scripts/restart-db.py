###START POSTGRES DATABASE###

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
#drop old table
conn = psycopg2.connect(dbname="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()
cur.execute("DROP TABLE Tweetwordcount;")
conn.commit()
conn.close()

#Create table within new DB
conn = psycopg2.connect(dbname="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()
cur.execute('''CREATE TABLE Tweetwordcount
       (word TEXT PRIMARY KEY     NOT NULL,
       count INT     NOT NULL);''')
conn.commit()
conn.close()