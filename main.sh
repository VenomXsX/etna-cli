#!bin/bash
source ./lib/login.sh

case $1 in
login) login ;;
userinfo) userinfo ;;
current_activities) current_activities ;;
flush) flush ;;
*) echo "bro learn the usage -h" ;;
esac
