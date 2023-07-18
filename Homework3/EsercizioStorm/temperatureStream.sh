#!/bin/bash

#
#       This script starts a server at port 7777 - client
#	can connect to receive the data stream.
#
#	Starting the script:	./temperatureStream.sh 
#
#	The stream consists of random text lines (1 line per second)
#	Output is saved at /tmp/logdata
#
#       Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#
#

rm -f /tmp/logdata
touch /tmp/logdata

# remove nc PID from previous run, if any 

echo ""
echo "Starting log stream sever at port 7777."


PID=`ps aux | grep " 7777"| awk '{print $2}'`
kill -9 $PID &> /dev/null

#starts the the server

tail -f /tmp/logdata | nc -lk 7777 &
DATE=`date +"%D %H:%M:%S"`
echo "Server started on $DATE."
echo ""

TAIL_NC_PID=$!

RANGE=5
# some random locations
declare -a loc=("ID = 1 Room_A" 
		"ID = 2 Room_B" 
		"ID = 3 Room_C" 
		"ID = 4 Floor_1"
		"ID = 5 Floor_2" 
		)

declare -i temperature=0

while [ 1 ]
do
	index=$RANDOM
	let "index %= $RANGE"

	temperature=$RANDOM
	let "temperature %= 20"
	temperature=$temperature+20

	DATE=`date +"%D %H:%M:%S"`

	echo "$DATE sensor: ${loc[$index]} temperature: $temperature"
	echo "$DATE sensor: ${loc[$index]} temperature: $temperature" >> /tmp/logdata

	sleep 1
done


kill $TAIL_NC_PID
