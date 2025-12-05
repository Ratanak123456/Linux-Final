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
    echo "║      Linux System Management         ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to display system information
system_info() {
    display_header
    echo -e "${GREEN}System Information${NC}"
    echo "══════════════════════════════════════"
    echo -e "${YELLOW}Hostname:${NC} $(hostname)"
    echo -e "${YELLOW}Operating System:${NC} $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo -e "${YELLOW}Kernel Version:${NC} $(uname -r)"
    echo -e "${YELLOW}Architecture:${NC} $(uname -m)"
    echo -e "${YELLOW}Uptime:${NC} $(uptime -p | sed 's/up //')"
    echo -e "${YELLOW}CPU Info:${NC} $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
    echo -e "${YELLOW}Memory:${NC} $(free -h | grep Mem: | awk '{print $2}') Total, $(free -h | grep Mem: | awk '{print $3}') Used"
    echo -e "${YELLOW}Disk Usage:${NC} $(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 ")"}')"
    
    # Additional system info
    echo ""
    echo -e "${GREEN}Network Information${NC}"
    echo "══════════════════════════════════════"
    echo -e "${YELLOW}IP Addresses:${NC}"
    ip addr show | grep -E "inet (192|10|172)" | awk '{print "  " $2}'
    
    echo ""
    echo -e "${GREEN}Logged in Users${NC}"
    echo "══════════════════════════════════════"
    who
    
    echo ""
    read -p "Press Enter to continue..."
}

# Execute system info function
system_info