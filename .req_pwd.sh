#!/bin/sh -e
# A simple wrapper script to deal with situations where pass, password-store, or
# my gpg key is not available.

pass "$1" && exit

# if pass fails, request password manually
stty -echo
printf "Password: " >&2
read passwd
stty echo
printf "\n" >&2

printf "$passwd"
