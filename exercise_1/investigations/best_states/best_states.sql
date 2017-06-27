-- This query answers: What states are models of high-quality care?            ;
--                                                                             ;
-- The query finds splits the measures by those which measure absolute score   ;
-- and those which measure a time quantity. The score / time values are ranked ;
-- higher score and lower time are considered better. The average ranks of the ;
-- two quantities are used to provide the overall state rank. With these values;
-- calculated the query outputs the top 10 values.                             ;

select z.state, z.aggregate_score, z.aggregate_time,
    (score_rank + time_rank)/2 as overall_rank
from (
    select distinct sc.state, sc.aggregate_score, tim.aggregate_time, 
    dense_rank() over (order by sc.aggregate_score desc) as score_rank,
    dense_rank() over (order by tim.aggregate_time) as time_rank
    from (
        select y.state, avg(y.mean_score) 
            over (partition by y.state) as aggregate_score
        from (
            select state, measure_id, avg(score) 
                over (partition by state, measure_id) as mean_score
            from effective_care_state_transformed
            where score IS NOT NULL AND score<>"Not Available"
                AND NOT (
                            measure_id="OP_5" OR
                            measure_id="OP_1" OR
                            measure_id="OP_21" OR
                            measure_id="OP_3b" OR
                            measure_id="ED_2b_LOW_MIN" OR
                            measure_id="ED_2b_OVERALL_MIN" OR
                            measure_id="ED_2b_MEDIUM_MIN" OR
                            measure_id="ED_2b_HIGH_MIN" OR
                            measure_id="ED_2b_VERY_HIGH_MIN" OR
                            measure_id="SCIP_INF_3" OR
                            measure_id="OP_18b_VERY_HIGH_MIN" OR
                            measure_id="OP_18b_LOW_MIN" OR
                            measure_id="OP_18b_MEDIUM_MIN" OR
                            measure_id="OP_18b_HIGH_MIN" OR
                            measure_id="OP_18b_OVERALL_MIN" OR
                            measure_id="ED_1b_LOW_MIN" OR
                            measure_id="ED_1b_MEDIUM_MIN" OR
                            measure_id="ED_1b_OVERALL_MIN" OR
                            measure_id="ED_1b_VERY_HIGH_MIN" OR
                            measure_id="ED_1b_HIGH_MIN"
                        )
            ) as y
        ) as sc
        inner join (
                select x.state,
                    avg(x.mean_time) over (partition by x.state)
                        as aggregate_time
                from (
                    select state, measure_id, avg(score) 
                    over (partition by state, measure_id) as mean_time
                    from effective_care_state_transformed
                    where score IS NOT NULL AND score<>"Not Available"
                        AND (
                            measure_id="OP_5" OR
                            measure_id="OP_1" OR
                            measure_id="OP_21" OR
                            measure_id="OP_3b" OR
                            measure_id="ED_2b_LOW_MIN" OR
                            measure_id="ED_2b_OVERALL_MIN" OR
                            measure_id="ED_2b_MEDIUM_MIN" OR
                            measure_id="ED_2b_HIGH_MIN" OR
                            measure_id="ED_2b_VERY_HIGH_MIN" OR
                            measure_id="SCIP_INF_3" OR
                            measure_id="OP_18b_VERY_HIGH_MIN" OR
                            measure_id="OP_18b_LOW_MIN" OR
                            measure_id="OP_18b_MEDIUM_MIN" OR
                            measure_id="OP_18b_HIGH_MIN" OR
                            measure_id="OP_18b_OVERALL_MIN" OR
                            measure_id="ED_1b_LOW_MIN" OR
                            measure_id="ED_1b_MEDIUM_MIN" OR
                            measure_id="ED_1b_OVERALL_MIN" OR
                            measure_id="ED_1b_VERY_HIGH_MIN" OR
                            measure_id="ED_1b_HIGH_MIN"
                        )
                    ) as x
            ) as tim
            on sc.state = tim.state
    ) as z
order by overall_rank
limit 10;
