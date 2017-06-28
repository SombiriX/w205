#!/bin/bash

# Call after running load_data_lake.sh. Script assumes all SQL files are in
# calling directory

RED='\x1B[1;31m'
GRN='\x1B[1;32m'
BLU='\x1B[1;34m'
NC='\x1B[0m' # No Color

echo
echo -e "${BLU}[INFO]${NC}: Running hive_base_ddl.sql"
spark-sql -f hive_base_ddl.sql
echo
echo -e "${BLU}[INFO]${NC}: Running transform_hospital_data.sql"
spark-sql -f transform_hospital_data.sql
echo
echo -e "${BLU}[INFO]${NC}: Running hospital_variablility.sql"
spark-sql -f hospital_variablility.sql
echo
echo -e "${BLU}[INFO]${NC}: Running best_states.sql"
spark-sql -f best_states.sql
echo
echo -e "${BLU}[INFO]${NC}: Running hospitals_and_patients.sql"
spark-sql -f hospitals_and_patients.sql
echo
echo -e "${BLU}[INFO]${NC}: Running best_hospitals.sql"
spark-sql -f best_hospitals.sql

echo
echo -e "${BLU}[INFO]${NC}: ${GRN}COMPLETE!!${NC}"
exit 0
