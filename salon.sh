#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"
SERVICES=$($PSQL "select service_id, name from services order by service_id")


MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo "$SERVICES" | sed 's/|/ /' | while read SID SNAME
  do
    echo "$SID) $SNAME"
  done
  read SERVICE_ID_SELECTED
  HAVE_THAT_SERVICE=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $HAVE_THAT_SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
  
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  #IF NOT REGISTERED CUSTOMER
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo "I don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi
    # NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENTS=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU


