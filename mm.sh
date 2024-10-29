#!/bin/bash
#make a new wallet
create_wallet(){
     local wallet_id=$(zenity --entry --title="Create Wallet" --text="Enter wallet ID:")
     #local wallet_id : declares a local variable wallet_id to hold a value entered by user
     #zenity --entry : open a Xenity dialog to prompt the user to enter text (wallet ID)
     #--title: sets the window title
     #--text: displys a message

     if [ -z "$wallet_id" ]; then
	zenity --error --text="Wallet ID cannot be empty!"
	exit 1
     fi
     #if [-z wallet_id]: checks is the variable is empty (user entered nothing)
     #zenity --error: displays an arror dialog
     #exit 1: exits the script with a status code of 1 (indicating an error)

     mkdir -p "$wallet_id"
     echo "0" > "$wallet_id/balance.txt"
     zenity --info --text="A wallet named $wallet_id has been created. Initial balance: 0"
     #creates a new directory with the name of wallet_id
     #echo 0 > wallet_id/balance.txt: Initialzes the wallet by creating a balance.txt file with an initial balance of 0
     #zenity --info: displays an informational dialog to the user confirming the creation of the wallet and its initial balance
}

#deposit function
deposit(){
    local wallet_id=$(zenity --entry --title="Deposit" --text="Enter wallet ID")
    local amount=$(zenity --entry --title="Deposit" --text="Enter amount of deposit:")
    #local wallet_id: captures the wallet ID from user via a Zenity entry dialog

    if [[ ! -d "$wallet_id" ]];then
        zenity --error --text="Wallet $wallet_id does not exist!"
	exit 1
    #checks if the wallet directory does not exist
    fi

    local balance=$(cat "$wallet_id/balance.txt")
    #reads the current balance from balance.txt 

    balance=$((balance+amount))
    echo "$balance">"$wallet_id/balance.txt"
    #updates the balance

    zenity --info --text="Deposited $amount to wallet_id.New balance: $balance"
    #diplays an informational dialog
}

#withdraw function
withdraw(){
    local wallet_id=$(zenity --entry --title="Withdraw" --text"Enter wallet ID:")
    local amount=$(zenity --entry --title="Withdraw" --text="Enter amount to withdraw:")

    if [[ ! -d "$wallet_id" ]]; then
	zenity --error --text="Wallet $wallet_id does not exist!"
	exit 1
    fi

    local balance=$(cat "$wallet_id/balance.txt")
    if ((balance >= amount )); then
	balance=$((balance - amount))
	echo "$balance" > "$wallet_id/balance.txt"
	zenity --info --text="Withdrew $amount from wallet $wallet_id. New balance: $balance"
    else
	zenity --error --text="Insufficient balance! Go make more more money you loser"
    fi
}

#Main menu using Zenity list dialog
show_menu(){
    local action=$(zenity --list --title="Wallet Mangement" --column="Actions" \
	"Create Wallet" \
	"Deposit" \
	"Withdraw" \
	--height=300 --width=300)
    #zenity --list: opens a dialog showing a list of actions
    #column: specifies the column name Actions 
    #--height / --width: sets the size of dialog window

    case $action in
	"Create Wallet") create_wallet ;;
	"Deposit") deposit ;;
	"Withdraw") withdraw ;;
	*) zenity --error --text="Invalid selection!" ;;
    esac
    #case $action in: Switches based on the action seleced by the user in Zenity list dialog
}

#run the menu
show_menu
