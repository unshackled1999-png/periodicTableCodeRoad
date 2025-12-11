#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

#check if input provided
 if [[ -z $1 ]] then
  echo  Please provide an element as an argument.
  exit
 fi

#get atomic number

if [[ $1 =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_id from elements where atomic_id=$1;")
else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_id from elements where name='$1' or symbol='$1';")
fi

