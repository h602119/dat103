#!/bin/bash


line="--------------------------"
echo $line

cd $1 	#$1 is the first agument given by the user, changing directory to that...

echo "you are now here:"
pwd
echo $line

#Creating a child directory for all new files called 'temp'
mkdir temp

#This section lets the user choose the file they want to depunctuate
echo "Type in a text file located in this folder (include .txt)"
echo $line
	ls *.txt #list all .txt files in the current dir
echo $line
	read file #user input is saved as '$file'
#We chose to let the user input a .txt file, since this worked best for us. The sanity checker will fail this, but since we dont know
#the logic behind... it makes it hard for us to optimize our code for the tests.


mv $file temp #moved to temp to generate new file for
cd temp
origFile=$file #the original file is stored

#checking if ENC-$file exists; if it does and contains the same information, the program should handle it. This is tested after the hashing.
if test -f "ENC-$file"
then
	flag="1"
	echo "$(cat $file)" > flagged$file #IF ENC-file exists then a flagged one is created
	oldFile=ENC-$file #oldFile get new name
	file=flagged$file #new file gets its new name
else
	echo "$(cat $file)" > ENC-$file #creates a new file to be encrypted.
	file=ENC-$file
fi

mv $origFile .. #moves the original text file back to its original dir, a complicated process but makes it easier to decode later
echo $line
echo "A file named $file has been created." 
echo $line
sleep 2

#all newlines becomes |

sed -zi 's/\n/|/g' $file
#all spaces become ~

sed -i 's/[[:space:]]/~/g' $file
#since everything is now connected a newline before and after every punctation makes sure every word and punctation is on a different line.

	sed -zi 's/[[:punct:]]/\n&\n/g' $file
echo "Changing all punctuations to their hash value"
echo $line

	number="1" #start on line one
while read currentLine
do
if [[ $currentLine == [[:punct:]] ]] #if the current line is punct then...
then
	hash=$(echo $currentLine|sha256sum|cut -d " " -f 1) #give it the hash value
	echo $currentLine > $hash.txt 	#store the original meaning inside the hashed txt file
	sed -i "$(($number))s/$currentLine/$hash/g" $file  #swap the punct on the current line with the hash value
fi
	number=$((number+1)) #increment number by one
done < $file


if [[ $flag == "1" ]]; then
if cmp -s $oldFile $file; then #silently comparing the insides of the two flagged files.
	echo "Flagged files contain the same information, deleting the duplicate..."
	rm -r $file #deletes the new file which contains the same information as the old one
else
	echo "Files have similar names, but does not contain the same information"
fi
else
	echo "no complications"
fi

echo $line
echo "done" #program finished
echo $line
