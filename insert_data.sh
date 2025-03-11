#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  #do not add the heading to the table
  if [[ $YEAR != "year" ]]; then
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      if [[ -z $OPPONENT_ID ]]; then
        #if not, we gotta assign it
        echo -e "\nTEAM_ID not found for TEAM: $OPPONENT. Inserting now."
        INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]; then
          OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
          echo -e "\nSuccess! TEAM: $OPPONENT added with TEAM_ID of $OPPONENT_ID"
        fi
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      if [[ -z $WINNER_ID ]]; then
        #if not, we gotta assign it
        echo -e "\nTEAM_ID not found for TEAM: $WINNER. Inserting now."
        INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]; then
          WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
          echo -e "\nSucces! TEAM: $WINNER added with TEAM_ID of $WINNER_ID"
        fi
      fi
      #echo -e "\n Insert: $YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, $ROUND."
      INSERT_MATCH=$($PSQL "INSERT INTO games (year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES($YEAR, '$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")
  fi
done
