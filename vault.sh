#!/bin/sh

# cfg

folders=(vars host_vars group_vars certs)

# read from prompt

while true; do
    read -p "(de/en)crypt: " action
    case $action in
        decrypt* ) break;;
        encrypt* ) break;;
        * ) echo "Please answer encrypt or decrpyt.";;
    esac
done

read -s -p "vault password: " vault_password
echo ""

# create password file

password_file="./.vault"
touch $password_file
chmod og= $password_file
echo $vault_password > $password_file

# run action

for folder in ${folders[@]}; do
	if [[ "$action" == "encrypt" ]]; then
		ansible-vault --vault-password-file=$password_file encrypt $folder/*
	else
		ansible-vault --vault-password-file=$password_file decrypt $folder/*
	fi
done

# remove password file

rm -f $password_file