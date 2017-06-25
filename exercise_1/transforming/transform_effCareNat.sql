--Removes redundant data from effective_care_national table;

ALTER TABLE effective_care_national REPLACE COLUMNS
(
  measure_id string,
  condition string,
  category string,
  score string,
  footnote string
);