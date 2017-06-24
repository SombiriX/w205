/* Data defnition language file for Meicare patients */

DROP TABLE effective_care_hospital;
CREATE EXTERNAL TABLE IF NOT EXISTS effective_care_hospital
(
  Provider_ID string,
  Hospital_Name string,
  Address string,
  City string,
  State string,
  ZIP_Code string,
  County_Name string,
  Phone_Number string,
  Condition string,
  Measure_ID string,
  Measure_Name string,
  Score string,
  Sample string,
  Footnote string,
  Measure_Start_Date string,
  Measure_End_Date string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION ‘/user/w205/hospital_compare/effective_care_-_Hospital/effective_care_-_Hospital.csv’;

DROP TABLE effective_care_hospital;
CREATE EXTERNAL TABLE IF NOT EXISTS effective_care_hospital
(
  Provider_ID string,
  Hospital_Name string,
  Address string,
  City string,
  State string,
  ZIP_Code string,
  County_Name string,
  Phone_Number string,
  Condition string,
  Measure_ID string,
  Measure_Name string,
  Score string,
  Sample string,
  Footnote string,
  Measure_Start_Date string,
  Measure_End_Date string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION ‘/user/w205/hospital_compare/effective_care_-_Hospital/effective_care_-_Hospital.csv’;