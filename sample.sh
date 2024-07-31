#!/bin/bash

# Function to handle case 1
case_1() {
    read -p "Enter the server name: " server_name
    echo "ANM1 - Server: $server_name"
}

# Function to handle case 2
case_2() {
    echo "ANM2"
}

# Function to handle case 3 (Group creation)
case_3() {
    read -p "Enter the name of the new group: " group_name
    
}

# Main script
echo "Select a case:"
echo "1. Print ANM1 and enter server name"
echo "2. Print ANM2"
echo "3. Group creation"

read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        case_1
        ;;
    2)
        case_2
        ;;
    3)
        case_3
        ;;
    *)
        echo "Invalid choice. Please enter 1, 2, or 3."
        ;;
esac
