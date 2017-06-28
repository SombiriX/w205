--Removes redundant data from effective_care_national table;

--Note: ALTER TABLE is faster but exercise instructions specify using create
-- table as select from style

DROP TABLE effective_care_hospital_transformed;
CREATE TABLE effective_care_hospital_transformed AS
SELECT 
    case when score="Not Available"     then 0
        when score like "Low%"          then 0
        when score like "Medium%"       then 0
        when score like "High%"         then 0
        when score like "Very High%"    then 0
        else provider_id
    end as provider_id,
    condition, measure_id, 
    case when score="Not Available"     then 0
        when score like "Low%"          then 0
        when score like "Medium%"       then 0
        when score like "High%"         then 0
        when score like "Very High%"    then 0
        else score
    end as score, sample, footnote
    FROM effective_care_hospital;


DROP TABLE effective_care_state_transformed;
CREATE TABLE effective_care_state_transformed AS
SELECT state, condition, measure_id, score, footnote
    FROM effective_care_state;


-- No transformation required for hospitals data
DROP TABLE hospitals_transformed;
CREATE TABLE hospitals_transformed AS
SELECT provider_id, hospital_name, address, city, state, zip_code, county_name, 
        phone_number, hospital_type, hospital_ownership, emergency_services
    FROM hospitals;


-- No transformation required for measures data
DROP TABLE measures_transformed;
CREATE TABLE measures_transformed AS
SELECT * FROM measures;


DROP TABLE readmissions_hospital_transformed;
CREATE TABLE readmissions_hospital_transformed AS
SELECT provider_id, measure_id, compared_to_national, denominator, score,
        lower_estimate, higher_estimate, footnote
    FROM readmissions_hospital;


DROP TABLE readmissions_state_transformed;
CREATE TABLE readmissions_state_transformed AS
SELECT state, measure_id, number_of_hospitals_worse, number_of_hospitals_same,
        number_of_hospitals_better, number_of_hospitals_too_few, footnote
    FROM readmissions_state;


DROP TABLE survey_responses_transformed;
CREATE TABLE survey_responses_transformed AS
SELECT 
      case when hcahps_base_score="Not Available" then 0
            else provider_number
      end AS provider_id,
      case when hcahps_base_score="Not Available" then 0
            else hcahps_base_score
      end  as hcahps_base_score,
      case when hcahps_consistency_score="Not Available" then 0
            else hcahps_consistency_score
      end  as hcahps_consistency_score
   FROM survey_responses;


DROP TABLE complications_state_transformed;
CREATE TABLE complications_state_transformed AS
SELECT
  state,
  case when measure_id="PSI_12_POSTOP_PULMEMB_DVT" then "PSI_12"
        when measure_id="PSI_14_POSTOP_DEHIS" then "PSI_14"
        when measure_id="PSI_15_ACC_LAC" then "PSI_15"
        when measure_id="PSI_4_SURG_COMP" then "PSI_4"
        when measure_id="PSI_6_IAT_PTX" then "PSI_6"
        when measure_id="PSI_90_SAFETY" then "PSI_90"
        else measure_id
  end as measure_id,
  number_of_hospitals_worse,
  number_of_hospitals_same,
  number_of_hospitals_better,
  number_of_hospitals_too_few,
  footnote
FROM complications_state;


DROP TABLE complications_hospital_transformed;
CREATE TABLE complications_hospital_transformed AS
SELECT
  provider_id,
  case when measure_id="PSI_12_POSTOP_PULMEMB_DVT" then "PSI_12"
        when measure_id="PSI_14_POSTOP_DEHIS" then "PSI_14"
        when measure_id="PSI_15_ACC_LAC" then "PSI_15"
        when measure_id="PSI_4_SURG_COMP" then "PSI_4"
        when measure_id="PSI_6_IAT_PTX" then "PSI_6"
        when measure_id="PSI_90_SAFETY" then "PSI_90"
        else measure_id
  end as measure_id,
  compared_to_national,
  denominator,
  score,
  lower_estimate,
  higher_estimate,
  footnote
FROM complications_hospital;
