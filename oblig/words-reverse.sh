#!/bin/bash

#line -> better readability in console
line="--------------------------"

echo $line
echo "Starting automated words-reverse"
echo $line


#creating a standard lorem.txt file to ensure this program always work.
loremTxt="Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna
exercitation nostrud quis, veniam minim ad enim Ut. aliqua
magna dolore et labore ut incididunt tempor eiusmod do sed,
elit adipiscing consectetur, amet sit dolor ipsum Lorem"

echo "$loremTxt" > lorem.txt


./depunctuate.sh . <<< "lorem.txt" #passes lorem.txt as the input for the depunctuate.sh file
	#depunctuate.sh complete...

cd temp #changing dir to place the reversed .txt file

newFile="loremReversed.txt"

echo $(tac ENC-lorem.txt) > $newFile #tac does the opposite of cat and since everything is on seperate lines, this will result in reversed text
sed -zi 's/[[:space:]]/\n/g' $newFile #any un-wanted spaces are swapped with newlines, all newlines are removed in de decoding process.

cd .. #going back to parent folder to execute the repunctuate 
./repunctuate.sh temp <<< "loremReversed.txt" #passes "loremReversed.txt" as the file to be decoded


#Getting the reversed txt file, and deleting the temp file.
cd temp
mv $newFile .. #move the reversed file to parent folder

cd .. #change directory back to parent folder

rm -r temp  #remove temporary folder with all hash lookups

echo "Temporary directory removed"
echo "New file with name '$newFile' can be found here"
pwd
echo $line

#Program finished

