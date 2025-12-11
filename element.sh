#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#check if input provided
if [[ -z $1 ]] 
then
  echo  Please provide an element as an argument.
  exit
fi

#get atomic number

if [[ $1 =~ ^[0-9]+$ ]] 
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements where atomic_number=$1;")
else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements where name='$1' or symbol='$1';")
fi

#check if valid input
if [[ -z $ATOMIC_NUMBER ]] 
then
  echo I could not find that element in the database.
  exit
else
  ATOMIC_INFORMATION=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements as e inner join properties as p ON e.atomic_number = p.atomic_number inner join types as t on p.type_id = t.type_id where e.atomic_number = $ATOMIC_NUMBER;")
fi
echo "$ATOMIC_INFORMATION" | while IFS="|" read -r ATOM_NUM NAME SYMBOL MASS MELT BOIL TYPE
  do
    echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
