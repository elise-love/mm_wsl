#!/bin/bash

WALLET_DIR="./wallets"  #defines the directory where the wallet files are store
mkdir -p "$WALLET_DIR"  #creates the wallet directory if it does not already exits

create_wallet(){
    read -p "Enter new wallet name:" name
    wallet_file="$WALLET_DIR/$name.wallet"  #defines the wallet path based on entered names
    if [ -f "$wallet_file" ]; then  #check if a wallet with the same name exists
	echo "Wallet '$name' already exists!"
    else
	echo "0" > "$wallet_file"  #initializes the wallet with a balance of 0"
	echo "Wallet '$name' created with a balance of 0."
    fi
}

display_wallets(){
    echo "My Wallets:"
    for wallet in "$WALLET_DIR"/*.wallet; do  #loops through each wallet file in the wallet directory
	name=$(basename "$wallet" .wallet)    #extractsthe wallet name by removing the ".wallet" extension
	balance=$(cat "$wallet")
	
        # Define the width of the box
        box_width=18
        border=$(printf '%*s' "$box_width" '' | tr ' ' '-')  # Border line of dashes

        # Calculate padding for the wallet name and balance
	name_line=$(printf " %-18s " "$name")
        balance_line=$(printf " %-16s " "$ $balance")

        #wallet box layout
        echo "$border"
        echo "|                 |"
        echo "$name_line"
        echo "|                 |"
        echo "$balance_line"
        echo "|                 |"
        echo "|_________________|"
    done
    echo ""
}




deposit(){
    read -p "Enter wallet name: " name
    wallet_file="$WALLET_DIR/$name.wallet"
    if [ ! -f "$wallet_file" ]; then
	echo "Wallet '$name' does not exists!"
    else
	read -p "Enter deposit amount: " amount
	balance=$(cat "$wallet_file")
	new_balance=$((balance + amount))
	echo "$new_balance" > "$wallet_file"  #updates the wallet file with the new balance
	echo "Deposited $amount to '$name'. New balance: $new_balance." 
    fi
}

withdraw() {
    read -p "Enter wallet name: " name
    wallet_file="$WALLET_DIR/$name.wallet"
    if [ ! -f "$wallet_file" ]; then
	echo "Wallet '$name' does not exists!"
    else
	read -p "Enter withdrawal amount: " amount
        balance=$(cat "$wallet_file")
	if ((balance >= amount)); then
	    new_balance=$((balance - amount))
	    echo "$new_balance" > "$wallet_file"
	    echo "Withdraw $amount from '$name' New balance: $new_balance.".
	else
	    echo "Insufficient funds in $name'!"
	    echo "you poor dog 去吃土吧!"
	fi
    fi
}

delete_wallet(){
    read -p "Enter wallet name: "name
    wallet_file="$WALLET_DIR/$name.wallet"
    if [ -f "wallet_file" ]; then
	rm "$wallet_file"  #deletes wallet file
	echo "Wallet '$name' deleted."
    else
	echo "Wallet '$name' does not exists!"
    fi
}

#main menu
while true; do
    display_wallets
    echo "Options: "                                # Presents options to the user
    echo "1. Create Wallet"
    echo "2. Deposit Money"
    echo "3. Withdraw Money"
    echo "4. Delete Wallet"
    echo "5. Exit"
    read -p "Choose an option: " option             # Reads user input for operation
    
    case $option in
	1) create_wallet ;;
	2) deposit ;;
	3) withdraw ;;
	4) delete_wallet ;;
	5) break ;;
	*) echo "Wrong input little idiot!" ;;
    esac
done
