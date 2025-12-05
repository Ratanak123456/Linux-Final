#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display header
display_header() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║         User Management              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to create user
create_user() {
    display_header
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo -e "${RED}User $username already exists!${NC}"
    else
        read -sp "Enter password: " password
        echo ""
        useradd -m -s /bin/bash -p $(openssl passwd -1 "$password") "$username"
        echo -e "${GREEN}User $username created successfully!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to update user
update_user() {
    display_header
    read -p "Enter username to update: " username
    if id "$username" &>/dev/null; then
        read -p "Enter new full name: " full_name
        usermod -c "$full_name" "$username"
        echo -e "${GREEN}User $username updated successfully!${NC}"
    else
        echo -e "${RED}User $username does not exist!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to delete user
delete_user() {
    display_header
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        read -p "Do you want to remove the home directory? (y/n): " remove_home
        if [[ $remove_home == "y" || $remove_home == "Y" ]]; then
            userdel -r "$username"
        else
            userdel "$username"
        fi
        echo -e "${GREEN}User $username deleted successfully!${NC}"
    else
        echo -e "${RED}User $username does not exist!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to list users
list_users() {
    display_header
    echo -e "${GREEN}System Users:${NC}"
    echo "══════════════════════════════════════"
    awk -F: '$3 >= 1000 {print "- " $1 " (UID: " $3 ")"}' /etc/passwd
    echo ""
    read -p "Press Enter to continue..."
}

# Function to show user details
show_user_details() {
    display_header
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo -e "${GREEN}User Details for $username:${NC}"
        echo "══════════════════════════════════════"
        id "$username"
        echo ""
        echo -e "${YELLOW}Home Directory:${NC}"
        eval echo ~"$username"
    else
        echo -e "${RED}User $username does not exist!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# User Management Menu
user_management_menu() {
    while true; do
        display_header
        echo -e "${GREEN}User Management${NC}"
        echo "══════════════════════════════════════"
        echo "1. Create User"
        echo "2. Update User"
        echo "3. Delete User"
        echo "4. List Users"
        echo "5. Show User Details"
        echo "6. Back to Main Menu"
        echo ""
        read -p "[+] Insert option: " user_choice

        case $user_choice in
            1)
                create_user
                ;;
            2)
                update_user
                ;;
            3)
                delete_user
                ;;
            4)
                list_users
                ;;
            5)
                show_user_details
                ;;
            6)
                break
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Execute user management menu
user_management_menu