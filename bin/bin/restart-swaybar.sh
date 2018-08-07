#!/bin/bash

FILE=`mktemp`
COUNT=0

echo "Running swaybar"

while [ $COUNT -le 2 ]; do
	pkill swaybar
	swaybar -b bar-0 -d > $FILE 2>&1 &
	sleep 2
	echo `cat $FILE`
	COUNT=`cat $FILE | wc -l`
	echo $COUNT
done

echo "Done!"
