#!bin/bash
source ./lib/functions.sh

case $1 in
login) login ;;
userinfo) userinfo ;;
activs) current_activities ;;
flush) flush ;;
help) help ;;
*)
    echo "use 'etna help' for usage"
    help
    ;;
esac
