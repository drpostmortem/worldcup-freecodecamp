#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games; ")
cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then 
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER';")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT';")
    if [[ -z $TEAM_ID_WINNER ]]
    then
      INSERT_TEAM_WINNER_RESULT=$($PSQL "insert into teams (name) values ('$WINNER') ;")
      echo $INSERT_TEAM_WINNER_RESULT
    elif [[ -z $TEAM_ID_OPPONENT ]]
    then
      INSERT_TEAM_OPPONENT_RESULT=$($PSQL "insert into teams (name) values ('$OPPONENT') ;")
      echo $INSERT_TEAM_OPPONENT_RESULT
    fi
  fi

done

cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then 
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
    GAME_ID=$($PSQL "select game_id from games where year=$YEAR and round='$ROUND' and winner_id=$WINNER_ID and opponent_id=$OPPONENT_ID and winner_goals=$WINNER_GOALS and opponent_goals=$OPPONENT_GOALS;")
    # echo $WINNER_ID $OPPONENT_ID $GAME_ID
    if [[ -z $GAME_ID ]]
    then      
      INSERT_GAME_RESULT=$($PSQL "insert into games (year,round,winner_goals,opponent_goals,winner_id,opponent_id) values ($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID) ;")
      echo $INSERT_GAME_RESULT
    fi
  fi

done
