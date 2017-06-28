-- This query answers: Which procedures have the greatest variability between  ;
--  hospitals?
--                                                                             ;


select h.hospital_name, h.city, h.state, z.aggregate_score, z.aggregate_time,
    (score_rank + time_rank)/2 as overall_rank
from (
    select distinct sc.provider_id, sc.aggregate_score, tim.aggregate_time, 
    dense_rank() over (order by sc.aggregate_score desc) as score_rank,
    dense_rank() over (order by tim.aggregate_time) as time_rank
    from (
        select y.provider_id, avg(y.mean_score) 
            over (partition by y.provider_id) as aggregate_score
        from (
            select provider_id, measure_id, avg(score) 
                over (partition by provider_id, measure_id) as mean_score
            from effective_care_hospital_transformed
            where score IS NOT NULL AND score<>"Not Available"
                AND NOT (
                            score like "Low%" OR
                            score like "Medium%" OR
                            score like "High%" OR
                            score like "Very High%"
                )
                AND NOT (
                            measure_id="OP_5" OR
                            measure_id="OP_1" OR
                            measure_id="OP_21" OR
                            measure_id="OP_3b"
                )
            ) as y
        ) as sc
        inner join (
                select x.provider_id,
                    avg(x.mean_time) over (partition by x.provider_id)
                        as aggregate_time
                from (
                    select provider_id, measure_id, avg(score) 
                    over (partition by provider_id, measure_id) as mean_time
                    from effective_care_hospital_transformed
                    where score IS NOT NULL AND score<>"Not Available"
                        AND NOT (
                            score like "Low%" OR
                            score like "Medium%" OR
                            score like "High%" OR
                            score like "Very High%"
                        )
                        AND (
                            measure_id="OP_5" OR
                            measure_id="OP_1" OR
                            measure_id="OP_21" OR
                            measure_id="OP_3b"
                        )
                    ) as x
            ) as tim
            on sc.provider_id = tim.provider_id
    ) as z
    inner join hospitals_transformed as h
        on z.provider_id = h.provider_id
order by overall_rank
limit 10;



select distinct cmp.measure_id, cmp.measure_var
from (
    select c.measure_id, variance(c.score)
        over (partition by c.measure_id) as measure_var
    from complications_hospital_transformed as c
    where c.score IS NOT NULL AND c.score<>"Not Available"
    ) as cmp
inner join measures_transformed as meas
    on meas.measure_id=cmp.measure_id;




DROP TABLE complications_hospital_transformed;
CREATE TABLE complications_hospital_transformed AS
SELECT
  provider_id,
  measure_id,
  compared_to_national,
  denominator,
  score,
  lower_estimate,
  higher_estimate,
  footnote
FROM complications_hospital;
