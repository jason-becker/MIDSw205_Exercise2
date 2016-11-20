# MIDSw205_Exercise2

##__To run:__
-Create an EC2 instance using the "UCB MIDS W205 EX2-FULL" AMI (AMI Id: ami-d4dd4ec3)  
-Attach an EBS volume  
-Connect to the instance  
-`fdisk -l` to discover the path to your EBS volume  
-`wget https://raw.github.com/jason-becker/MIDSw205_Exercise2/master/scripts/setup-tweet-word-count.sh`  
-`chmod +x setup-tweet-word-count.sh`  
-`./setup-tweet-word-count.sh [path to EBS volume, e.g. /dev/xvdf]`  

The setup script may take a couple minutes to complete.

To run the project, navigate into the project folder and execute:
cd tweetWordCount
sparse run