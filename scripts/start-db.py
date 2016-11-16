###START POSTGRES DATABASE###

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
#Create new database
conn = psycopg2.connect(dbname="postgres", user="postgres", password="pass", host="localhost", port="5432")
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
dbname = 'Tcount'
cur = conn.cursor()
cur.execute('CREATE DATABASE ' + dbname)
conn.close()

#Create table within new DB
conn = psycopg2.connect(dbname="Tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()
cur.execute('''CREATE TABLE Tweetwordcount
       (word TEXT PRIMARY KEY     NOT NULL,
       count INT     NOT NULL);''')
conn.commit()
conn.close()