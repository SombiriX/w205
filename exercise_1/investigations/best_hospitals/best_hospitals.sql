-- This query answers: What hospitals are models of high-quality care?            ;
--                                                                             ;
-- The query finds splits the measures by those which measure absolute score   ;
-- and those which measure a time quantity. The score / time values are ranked ;
-- higher score and lower time are considered better. The average ranks of the ;
-- two quantities are used to provide the overall hospital rank. With these values;
-- calculated the query outputs the top 10 values.                             ;

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
