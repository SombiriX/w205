--Removes redundant data from effective_care_national table;

--Note: ALTER TABLE is faster but exercise instructions specify using create
-- table as select from style

DROP TABLE effective_care_hospital_transformed;
CREATE TABLE effective_care_hospital_transformed AS
SELECT provider_id, condition, measure_id, score, sample, footnote
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
SELECT provider_number AS provider_id,
        communication_with_nurses_achievement_points,
        communication_with_nurses_improvement_points,
        communication_with_nurses_dimension_score,
        communication_with_doctors_achievement_points,
        communication_with_doctors_improvement_points,
        communication_with_doctors_dimension_score,
        responsiveness_of_hospital_staff_achievement_points,
        responsiveness_of_hospital_staff_improvement_points,
        responsiveness_of_hospital_staff_dimension_score,
        pain_management_achievement_points,
        pain_management_improvement_points,
        pain_management_dimension_score,
        communication_about_medicines_achievement_points,
        communication_about_medicines_improvement_points,
        communication_about_medicines_dimension_score,
        cleanliness_and_quietness_of_hospital_environment_achievement_points,
        cleanliness_and_quietness_of_hospital_environment_improvement_points,
        cleanliness_and_quietness_of_hospital_environment_dimension_score,
        discharge_information_achievement_points,
        discharge_information_improvement_points,
        discharge_information_dimension_score,
        overall_rating_of_hospital_achievement_points,
        overall_rating_of_hospital_improvement_points,
        overall_rating_of_hospital_dimension_score,
        hcahps_base_score,
        hcahps_consistency_score
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
