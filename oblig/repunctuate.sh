#!/bin/bash

#Line gives better readability on the console
line="--------------------------"

echo $line
echo "You are here:"
pwd
#Changes directory to where the hashed files and the encrypted .txt file are.
cd $1 #the command-line argument sets the working directory
echo $line


#This section lets the user to choose the file
echo "select a txt file from current directory to decrypt (include .txt)"
#Listing all txt files
ls *.txt
echo $line
read file #user input is saved as variable $file

echo $line
echo "decrypting $file"
echo $line

echo "Changing all hash values back to their original form"
echo $line

#Going line by line, if a line is also the name of a .txt file it is considered a hash. The line is then replaced with the inside of the hashed .txt file
number="1" #starting on line 1
while read currentLine
do
if [[ -f $currentLine.txt ]] #if the current line is also a "currentline.txt" then...
then
	decode=$(cat $currentLine.txt) #decode is now the value stored inside the hashed txt file.
	sed -i "$(($number))s/$currentLine/$decode/g" $file #swapping the hashed line with the "decode" value.
fi
	number=$((number+1)) #increment the number
done < $file

#re-assembling back to original form
echo $line
echo "Re-assembling"
sleep 1
#Removes all newlines, 
	sed -zi 's/\n//g' $file
#All | -> newline
	sed -zi 's/|/\n/g' $file
#All ~ -> space
	sed -i 's/~/ /g' $file

echo $line
echo "Process Complete"
echo $line
#program finished
