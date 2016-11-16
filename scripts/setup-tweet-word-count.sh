mkdir /root/data
cd /root/data
git clone https://github.com/jason-becker/MIDSw205_Exercise2.git
pip install psycopg2
pip install tweepy

###SETUP SPARSE###
sparse quickstart tweetWordCount

#COPY PYTHON PARSE/BOLT FILES INTO PROJECT
#COPY TOPOLOGY FILE INTO PROJECT
rm tweetwordcount/src/bolts/__init__.py
rm tweetwordcount/src/bolts/wordcount.py
rm tweetwordcount/src/spouts/__init__.py
rm tweetwordcount/src/spouts/words.py
rm tweetwordcount/topologies/wordcount.clj
cp MIDSw205_Exercise2/scripts/tweets.py tweetwordcount/src/spouts/tweets.py
cp MIDSw205_Exercise2/scripts/parse.py tweetwordcount/src/bolts/parse.py
cp MIDSw205_Exercise2/scripts/wordcount.py tweetwordcount/src/bolts/wordcount.py
cp MIDSw205_Exercise2/scripts/tweetwordcount.clj tweetwordcount/topologies/tweetwordcount.clj

#COPY START SCRIPT TO THIS FOLDER
cat > start-tweet-word-count.sh <<EOF
#! /bin/bash
cd /root/data/tweetwordcount
sparse run
EOF

###INSTALL POSTGRES###
#! /bin/bash

cd $HOME
umount /data

echo "using drive " $1
echo "WARNING!! This will format the drive at" $1
read -rsp $'Press any key to continue or control-C to quit...\n' -n1 key

#make a new ext4 filesystem
mkfs.ext4 $1

#mount the new filesystem under /data
mount -t ext4 $1 /data
chmod a+rwx /data

#set up directories for postgres
mkdir /data/pgsql
mkdir /data/pgsql/data
mkdir /data/pgsql/logs
chown -R postgres /data/pgsql
sudo -u postgres initdb -D /data/pgsql/data

#setup pg_hba.conf
sudo -u postgres echo "host    all         all         0.0.0.0         0.0.0.0               md5" >> /data/pgsql/data/pg_hba.conf

#setup postgresql.conf
sudo -u postgres echo "listen_addresses = '*'" >> /data/pgsql/data/postgresql.conf
sudo -u postgres echo "standard_conforming_strings = off" >> /data/pgsql/data/postgresql.conf

#make start postgres file
cd /data
cat > /data/start_postgres.sh <<EOF
#! /bin/bash
sudo -u postgres pg_ctl -D /data/pgsql/data -l /data/pgsql/logs/pgsql.log start
EOF
chmod +x /data/start_postgres.sh

#make a stop postgres file
cat > /data/stop_postgres.sh <<EOF
#! /bin/bash
sudo -u postgres pg_ctl -D /data/pgsql/data -l /data/pgsql/logs/pgsql.log stop
EOF
chmod +x /data/stop_postgres.sh

#start postgres
/data/start_postgres.sh

#SETUP POSTGRES DATABASE
python MIDSw205_Exercise2/scripts/start-db.py
Contact GitHub 