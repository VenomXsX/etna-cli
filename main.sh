#!/bin/bash
source $ETNA_CLI/lib/current_activities.sh
source $ETNA_CLI/lib/utils/flush.sh
source $ETNA_CLI/lib/help.sh
source $ETNA_CLI/lib/login.sh
source $ETNA_CLI/lib/userinfo.sh
source $ETNA_CLI/lib/planning.sh
source $ETNA_CLI/lib/notifications.sh
source $ETNA_CLI/lib/marks.sh
source $ETNA_CLI/lib/today.sh
source $ETNA_CLI/lib/tickets.sh

case $1 in
login) login ;;

userinfo) userinfo ;;
user) userinfo ;;

activs) current_activities ;;
activities) current_activities ;;

flush) flush ;;

planning) planning ;;
plan) planning ;;

notifs) notifications ;;
notifications) notifications ;;

marks) marks ;;
notes) marks ;;

today) today ;;
td) today ;;

tickets) tickets ;;
tk) tickets ;;

help) help ;;
*)
    echo "use 'etna help' for usage"
    help
    ;;
esac
