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
    echo -e "${GREEN}Create New Group${NC}"
    echo "══════════════════════════════════════"
    read -p "Enter group name: " groupname
    
    if grep -q "^$groupname:" /etc/group; then
        echo -e "${RED}Group $groupname already exists!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    read -p "Enter GID (leave empty for automatic): " gid
    
    if [[ -z "$gid" ]]; then
        groupadd "$groupname"
    else
        groupadd -g "$gid" "$groupname"
    fi
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Group $groupname created successfully!${NC}"
    else
        echo -e "${RED}Failed to create group $groupname${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# Function to update group
update_group() {
    display_header
    echo -e "${GREEN}Update Group${NC}"
    echo "══════════════════════════════════════"
    read -p "Enter group name to update: " groupname
    
    if ! grep -q "^$groupname:" /etc/group; then
        echo -e "${RED}Group $groupname does not exist!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo "1. Change GID"
    echo "2. Change group name"
    echo ""
    read -p "Select update option: " update_option
    
    case $update_option in
        1)
            read -p "Enter new GID: " new_gid
            groupmod -g "$new_gid" "$groupname"
            echo -e "${GREEN}GID updated for group $groupname${NC}"
            ;;
        2)
            read -p "Enter new group name: " new_groupname
            groupmod -n "$new_groupname" "$groupname"
            echo -e "${GREEN}Group name updated from $groupname to $new_groupname${NC}"
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    read -p "Press Enter to continue..."
}

# Function to delete group
delete_group() {
    display_header
    echo -e "${GREEN}Delete Group${NC}"
    echo "══════════════════════════════════════"
    read -p "Enter group name to delete: " groupname
    
    if ! grep -q "^$groupname:" /etc/group; then
        echo -e "${RED}Group $groupname does not exist!${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    groupdel "$groupname"
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Group $groupname deleted successfully!${NC}"
    else
        echo -e "${RED}Failed to delete group $groupname${NC}"
        echo "Note: Cannot delete primary group of existing users"
    fi
    
    read -p "Press Enter to continue..."
}

# Function to add user to group
add_user_to_group() {

}

# Function to remove user from group
remove_user_from_group() {

}

# Function to list groups
list_groups() {

}

# Function to show group details
show_group_details() {

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