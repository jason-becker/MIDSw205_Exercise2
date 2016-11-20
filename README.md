#MIDSw205_Exercise2

<<<<<<< HEAD
##__To setup:__##  
=======
##__To setup:__  
>>>>>>> 2d675267c37a06b08bd83cd0a049e9675a68e74b
- Create an EC2 instance using the "UCB MIDS W205 EX2-FULL" AMI (AMI Id: ami-d4dd4ec3)  
- Attach an EBS volume  
- Connect to the instance  
- Discover the path to your EBS volume (e.g. /dev/xvdf)  
	`fdisk -l`  
- Download the starting script  
	`wget https://raw.github.com/jason-becker/MIDSw205_Exercise2/master/scripts/setup-tweet-word-count.sh`  
- To grant permission to execute the script  
	`chmod +x setup-tweet-word-count.sh`  
- Replace the volume location with your EBS volume location  
	`./setup-tweet-word-count.sh [/dev/xvdf]`  

The setup script may take a couple minutes to complete.  

__To stream some tweets:__
- `cd/ /root/data`  
- `./start-tweet-word-count.sh`

__To serve some information about the data:__  
- `cd/ root/data`  
- `python finalresults.py` __OR__ `python histogram.py`  
Final results - supply a single word to find out its frequency (optional)  
Histogram - supply a min and max number of occurrences to find out how which words fall into that count range  

__To find out more:__  
The sql server and Storm components are store on the EBS volume (/data)  
Copies of all startup scripts are stored there as well  
Scripts for starting and stopping the stream, starting and stopping the sql server, and serving results are all located in /root/data  
