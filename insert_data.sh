#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#Empty game database:
echo "$($PSQL "delete from games")";
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do 
  #select name from teams - if not in teams, add to teams.
  if [[ $winner != 'winner' ]]
    then
    winnerTemp="$($PSQL "select name from teams where name='$winner'")";
    opponentTemp="$($PSQL "select name from teams where name='$opponent'")";
    if [[ -z $winnerTemp ]]
      then "$($PSQL "Insert into teams(name) values ('$winner')")"
    fi

    if [[ -z $opponentTemp ]]
      then echo "$($PSQL "Insert into teams(name) values ('$opponent')")";
    fi
    winner_id="$($PSQL "select team_id from teams where name='$winner'")";
    opponent_id="$($PSQL "select team_id from teams where name='$opponent'")";
    echo "$($PSQL "Insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values ($year,'$round',$winner_goals,$opponent_goals,$winner_id,$opponent_id)")";
  fi
done
#echo "$($PSQL "COPY ${table} ${columns} FROM '${file}' WITH (FORMAT CSV, DELIMITER ',');")";
echo -e "\nDone";
# Do not change code above this line. Use the PSQL variable above to query your database.
