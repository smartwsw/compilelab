#!/bin/bash
name=`uname`
rm -rf /tmp/lab
cp -r ../lab /tmp/lab
echo "cp done"
cd /tmp
if [ ${name} == "Linux" ] ; then
	tar -cvzf /media/psf/Home/Desktop/131220069.tar.gz lab 
else
	if [ ${name} == "Darwin" ] ; then
		tar -cvzf ~/Desktop/131220069.tar.gz lab 
	else
		echo "Undefined system $name, exiting..."
	fi  
fi
rm -rf /tmp/lab
echo "temp dir removed"
