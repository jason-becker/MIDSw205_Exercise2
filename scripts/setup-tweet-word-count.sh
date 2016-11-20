cd /data

echo "###INSTALLING PYTHON LIBRARIES###"
pip install psycopg2
pip install tweepy

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

#COPY START SCRIPT TO THIS FOLDER
mkdir /root/data
chmod a+rwx /root/data
cd /root/data
cat > start-tweet-word-count.sh <<EOF
#! /bin/bash
cd /data/tweetWordCount
sparse run
EOF
chmod +x /root/data/start-tweet-word-count.sh

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
cd /root/data
cat > /root/data/start_postgres.sh <<EOF
#! /bin/bash
sudo -u postgres pg_ctl -D /data/pgsql/data -l /data/pgsql/logs/pgsql.log start
EOF
chmod +x /root/data/start_postgres.sh

#make a stop postgres file
cat > /root/data/stop_postgres.sh <<EOF
#! /bin/bash
sudo -u postgres pg_ctl -D /data/pgsql/data -l /data/pgsql/logs/pgsql.log stop
EOF
chmod +x /root/data/stop_postgres.sh

#start postgres
/root/data/start_postgres.sh

echo "###SETUP SPARSE PROJECT###"
cd /data
git clone https://github.com/jason-becker/MIDSw205_Exercise2.git
sparse quickstart tweetWordCount

#COPY PYTHON PARSE/BOLT FILES INTO PROJECT
#COPY TOPOLOGY FILE INTO PROJECT
rm tweetWordCount/src/bolts/__init__.py
rm tweetWordCount/src/bolts/wordcount.py
rm tweetWordCount/src/spouts/__init__.py
rm tweetWordCount/src/spouts/words.py
rm tweetWordCount/topologies/wordcount.clj
cp MIDSw205_Exercise2/scripts/tweets.py tweetWordCount/src/spouts/tweets.py
cp MIDSw205_Exercise2/scripts/parse.py tweetWordCount/src/bolts/parse.py
cp MIDSw205_Exercise2/scripts/wordcount.py tweetWordCount/src/bolts/wordcount.py
cp MIDSw205_Exercise2/scripts/tweetwordcount.clj tweetWordCount/topologies/tweetwordcount.clj
cp MIDSw205_Exercise2/scripts/finalresults.py /root/data/finalresults.py
cp MIDSw205_Exercise2/scripts/finalresults.py /root/data/finalresults.py

#SETUP POSTGRES DATABASE
python MIDSw205_Exercise2/scripts/start-db.py
echo "PostGRESQL Database initialized"

