#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$(( RANDOM % 1000 ))

echo "Enter your username:"
read NAME

PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")

if [[ -z $PLAYER_ID ]]
then

INSERT_PLAYER=$($PSQL "INSERT INTO players(name) VALUES('$NAME')")
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")
USERNAME=$($PSQL "SELECT name FROM players WHERE player_id=$PLAYER_ID")
echo "Welcome, $USERNAME! It looks like this is your first time here."

else


GAMES_PLAYED=$($PSQL "SELECT COUNT(player_id) FROM games GROUP BY player_id HAVING player_id=$PLAYER_ID") 
BEST_GAME=$($PSQL "SELECT MIN(tries) FROM games WHERE player_id=$PLAYER_ID")
USERNAME=$($PSQL "SELECT name FROM players WHERE player_id=$PLAYER_ID")

    
 echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    

fi


echo "Guess the secret number between 1 and 1000:"


MENU()
{

    if [[ $1 ]]
    then
    echo -e "\n$1"
    fi

    read NUMBER



if [[ ! $NUMBER  =~ ^[0-9]+$ ]]
then
MENU "That is not an integer, guess again:"
else

  if [[ $NUMBER -eq $SECRET_NUMBER ]]
  then

  i=$((i+1))
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (player_id, tries) VALUES($PLAYER_ID, $i)")


  echo "You guessed it in $i tries. The secret number was $SECRET_NUMBER. Nice job!"
  
  elif [[ $NUMBER -lt $SECRET_NUMBER ]]
  then

  i=$((i+1))
  MENU "It's higher than that, guess again:"


  elif [[ $NUMBER -gt $SECRET_NUMBER ]]
  then

  i=$((i+1))
  MENU "It's lower than that, guess again:"

  fi
fi
}
MENU
