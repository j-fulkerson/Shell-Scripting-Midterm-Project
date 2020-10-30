#!/bin/bash
#This script will create a new user unde the super user permission only. Users who do not enter correct parameters will not be able to create a new user.
#Joseph Fulkerson
#Midterm


function superuser(){
	
	sudo -v

	if [ $? == 0 ]
	then
		echo "Root Permission Accessed"
	else
		echo "Root Permission Denied"
		exit 0
	fi
	
	}




#------------------------------------------------------------------------------
#Ask user for full name and check to ensure a name was input
function readName(){

	read -p "Full Name: " fname
	if [ -z "$fname" ]
	then
		echo "You must enter a full name"
		echo
		readName
	fi

	}





#------------------------------------------------------------------------------
#Ask user for user id and check to see if it already exists
function readUID(){
	read -p "User Name: " uname
	if [ -z "$uname" ]
	then
		echo "You must enter a username"
		echo
		readUID
	fi


	read -p "UID (enter for default): " UiD

	if [ -z "$UiD" ]
	then
		UiD=$((1000 + RANDOM % 9999))
	else

	UiDcheck=1
	while [ $UiDcheck = 1 ]
	do
		grep $UiD /etc/passwd > /dev/null 2>&1
		if [ $? = 0 ]; then
			echo "UID already exists"
			echo "Enter new UID"
			read UiD
		else
			charC=$"${#UiD}"
			while [ $charC -le 2 ]
			do 
				echo "UID must be at leat 3 characters"
				readUID
			
			done
			UiDcheck=2

		
		fi
	done
	fi

	}	




#------------------------------------------------------------------------------
#Ask user for group id. If user does not enter new id it will create a deafult Group Id
function readGID(){

	read -p "Group Name: " Gname
	
	grep $Gname /etc/group > /dev/null 2>&1
	if [ $? == 0 ]
	then
		echo "Group $Gname found"
		grep $Gname /etc/group > newgroup.txt
		sed -i 's/:/ /g' newgroup.txt
		GiD=`awk '{ print $3 }' newgroup.txt`
		echo "Group Id: " $GiD
		rm newgroup.txt
	else	

		read -p "GID (enter for default): " GiD
		if [ -z "$GiD" ]
		then
			GiD=$((1000 + RANDOM % 9999))	
		fi
	fi 
	
	}




#------------------------------------------------------------------------------
#Ask user for PhoneNumber
function readPhoneNum(){

	read -p "Phone Number: " phoneNum

	}




#------------------------------------------------------------------------------
#Input user values and create new user. If new user did not create a new group or used a group id that already exists user will be created.
function createNewusr(){
	
	echo
	echo "--------------"
	echo "---Add User---"
	echo "--------------"

	readName
	
	readUID

	readGID

	readPhoneNum


	}




#----------------------------------------------------------------------------
#Prompt the user to make changes if needed continue to create new user when changes have been made.
function changes(){
	echo
	echo " Edit Values "
	echo "(1)-----Current Full Name: $fname -----"
	echo "(2)-----Current username and UID: $uname, $UiD -----"
	echo "(3)-----Current Group Name and GIT: $Gname, $GiD -----"
	echo "(4)-----Current Phone Number: $phoneNym -----"
	echo "(5)-----Back------"

	read -p "Select an option to change values: " options
		case $options in
			1)
				readName
				sContinue
				;;
			2)
				readUID
				sContinue
				;;
			3)
				
				readGID
				sContinue
				;;
			4)
				readPhoneNum
				sContinue
				;;
			5)
				sContinue
				;;
		esac 
	
	}




#-------------------------------------------------------
#
function sContinue(){

echo "---------------------------------------------------------------------------------------------"
echo "sudo useradd $uname -m -c 'FName: $fname, Phone: $phoneNum' -u $UiD -g $GiD -s /bin/bash"
echo "---------------------------------------------------------------------------------------------"
echo 
echo "---Finalize User---"
echo "(1)-----Continue "
echo "(2)-----Make Changes "
read -p ": " option
case $option in
	1)	
		newuserCreated
		;;
	2)
		changes
		;;
esac



	}


function newuserCreated(){



sudo /usr/sbin/groupadd -g $GiD $Gname > /dev/null 2>&1
sudo /usr/sbin/useradd $uname -m -c "$fname, $phoneNum" -u $UiD -g $GiD -s /bin/bash
echo "$uname:password" | sudo chpasswd

if [ $? == 0 ]
then
	echo "--New User Created--"
	grep $UiD /etc/passwd
else
	"Error $uname not created"
fi
	}



	#Main
	superuser
	createNewusr
	sContinue



 



