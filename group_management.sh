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
    echo "║         Group Management             ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to create group
create_group() {
    display_header
    read -p "Enter group name: " groupname
    if getent group "$groupname" >/dev/null 2>&1; then
        echo -e "${RED}Group $groupname already exists!${NC}"
    else
        groupadd "$groupname"
        echo -e "${GREEN}Group $groupname created successfully!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to update group
update_group() {
    display_header
    read -p "Enter current group name: " oldname
    if getent group "$oldname" >/dev/null 2>&1; then
        read -p "Enter new group name: " newname
        groupmod -n "$newname" "$oldname"
        echo -e "${GREEN}Group renamed from $oldname to $newname successfully!${NC}"
    else
        echo -e "${RED}Group $oldname does not exist!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to delete group
delete_group() {
    display_header
    read -p "Enter group name to delete: " groupname
    if getent group "$groupname" >/dev/null 2>&1; then
        groupdel "$groupname"
        echo -e "${GREEN}Group $groupname deleted successfully!${NC}"
    else
        echo -e "${RED}Group $groupname does not exist!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to add user to group
add_user_to_group() {
    display_header
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    if id "$username" &>/dev/null && getent group "$groupname" >/dev/null 2>&1; then
        usermod -aG "$groupname" "$username"
        echo -e "${GREEN}User $username added to group $groupname successfully!${NC}"
    else
        echo -e "${RED}Invalid username or group name!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to remove user from group
remove_user_from_group() {
    display_header
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    if id "$username" &>/dev/null && getent group "$groupname" >/dev/null 2>&1; then
        gpasswd -d "$username" "$groupname"
        echo -e "${GREEN}User $username removed from group $groupname successfully!${NC}"
    else
        echo -e "${RED}Invalid username or group name!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Function to list groups
list_groups() {
    display_header
    echo -e "${GREEN}System Groups:${NC}"
    echo "══════════════════════════════════════"
    awk -F: '$3 >= 1000 {print "- " $1 " (GID: " $3 ")"}' /etc/group
    echo ""
    read -p "Press Enter to continue..."
}

# Function to show group details
show_group_details() {
    display_header
    read -p "Enter group name: " groupname
    if getent group "$groupname" >/dev/null 2>&1; then
        echo -e "${GREEN}Group Details for $groupname:${NC}"
        echo "══════════════════════════════════════"
        getent group "$groupname"
        echo ""
        echo -e "${YELLOW}Members:${NC}"
        members=$(getent group "$groupname" | cut -d: -f4)
        if [[ -z $members ]]; then
            echo "  (No members)"
        else
            echo "  $members" | tr ',' '\n' | sed 's/^/  - /'
        fi
    else
        echo -e "${RED}Group $groupname does not exist!${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Group Management Menu
group_management_menu() {
    while true; do
        display_header
        echo -e "${GREEN}Group Management${NC}"
        echo "══════════════════════════════════════"
        echo "1. Create Group"
        echo "2. Update Group"
        echo "3. Delete Group"
        echo "4. Add User to Group"
        echo "5. Remove User from Group"
        echo "6. List Groups"
        echo "7. Show Group Details"
        echo "8. Back to Main Menu"
        echo ""
        read -p "[+] Insert option: " group_choice

        case $group_choice in
            1)
                create_group
                ;;
            2)
                update_group
                ;;
            3)
                delete_group
                ;;
            4)
                add_user_to_group
                ;;
            5)
                remove_user_from_group
                ;;
            6)
                list_groups
                ;;
            7)
                show_group_details
                ;;
            8)
                break
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Execute group management menu
group_management_menu