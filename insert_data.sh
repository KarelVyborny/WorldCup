#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAM1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]  
  then 
    if [[ -z $TEAM1 ]]
      then
      #echo $YEAR $WINNER $OPPONENT
      INSERT_TEAM1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
        then 
        echo inserted: $WINNER
      fi
    fi
  fi

  TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]  
    then 
    if [[ -z $TEAM2 ]]
      then
      #echo $YEAR $WINNER $OPPONENT
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
        then 
         echo inserted: $OPPONENT
      fi
    fi
fi
  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]] 
  then
  INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O ,$WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then 
    echo inserted: $YEAR
  fi
fi

done
