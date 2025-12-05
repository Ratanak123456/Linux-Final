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

}

# Function to update user
update_user() {

}

# Function to delete user
delete_user() {

}

# Function to list users
list_users() {
    display_header
    echo -e "${GREEN}System Users${NC}"
    echo "══════════════════════════════════════"
    echo -e "${YELLOW}Username\tUID\tGID\tHome Directory\tShell${NC}"
    echo "────────────────────────────────────────────────────────────"
    
    # Get all users with UID >= 1000 (regular users) and UID 0 (root)
    awk -F: '$3 >= 1000 || $3 == 0 {printf "%-12s\t%-6s\t%-6s\t%-15s\t%s\n", $1, $3, $4, $6, $7}' /etc/passwd
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to show user details
show_user_details() {
    display_header
    echo -e "${GREEN}User Details${NC}"
    echo "══════════════════════════════════════"
    read -p "Enter username: " username
    
    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${YELLOW}User Information:${NC}"
    finger "$username" 2>/dev/null || grep "^$username:" /etc/passwd
    
    echo -e "\n${YELLOW}Group Memberships:${NC}"
    groups "$username"
    
    echo -e "\n${YELLOW}Last Login:${NC}"
    last "$username" | head -5
    
    echo ""
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