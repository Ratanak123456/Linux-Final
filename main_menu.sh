#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to display header
display_header() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║      Linux System Management         ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check sudo permissions
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: This script must be run with sudo permissions${NC}"
        exit 1
    fi
}

# Function to source and run other scripts
run_script() {
    local script_name="$1"
    local script_path="$SCRIPT_DIR/$script_name"
    
    if [[ -f "$script_path" ]]; then
        source "$script_path"
    else
        echo -e "${RED}Error: Script $script_name not found!${NC}"
        read -p "Press Enter to continue..."
    fi
}

# Main menu
main_menu() {
    while true; do
        display_header
        echo "1. System Information"
        echo "2. User Management"
        echo "3. Group Management"
        echo "4. Exit"
        echo ""
        read -p "[+] Insert option: " main_choice

        case $main_choice in
            1)
                run_script "system_info.sh"
                ;;
            2)
                run_script "user_management.sh"
                ;;
            3)
                run_script "group_management.sh"
                ;;
            4)
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Main execution
check_sudo
main_menu