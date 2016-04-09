#!/bin/bash
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

exec < /dev/tty

printf "Removing old database dumps... "
#remove old dumps
rm database/fields_meta_data.sql database/workflows.sql
echo "${GREEN}Done${RESET}"

printf "Starting to dump fields_meta_data and workflow related tables... \n"
read -s -p "Enter MySql password: " mysql_password
printf "\n"

#dump important tables
MSG="$((
  mysqldump -u {{ mysql_root_username }} -h {{ domain_name }} --password=$mysql_password --extended-insert=FALSE --skip-dump-date {{ sugar_db_name }} fields_meta_data  > database/fields_meta_data.sql
  mysqldump -u {{ mysql_root_username }} -h {{ domain_name }} --password=$mysql_password --extended-insert=FALSE --skip-dump-date {{ sugar_db_name }} workflow workflow_actions workflow_actionshells workflow_alerts workflow_alertshells workflow_schedules workflow_triggershells expressions > database/workflows.sql
) 2>&1)"

if [ $? -ne 0 ]; then
  echo "${RED}$MSG"
  echo "Commit failed${RESET}"
  exit 1
fi

echo "${GREEN}Done${RESET}"

printf "Adding database dump to commit... "
git add database/*
echo "${GREEN}Done${RESET}"