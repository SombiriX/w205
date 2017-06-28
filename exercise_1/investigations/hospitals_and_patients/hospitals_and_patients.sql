-- This query answersthe question:  Are average scores for hospital quality or;
-- procedural variability correlated with patient survey responses?           ;
--                                                                            ;
--  To answer this question the query finds the Pearson correlation           ;
--  coefficients for survey base score and average care quality, and survey   ;
--  base score and care variance between all hospitals.                       ;


-- Calculate correlation between survey base score and average care quality   ;
select corr(cast(eff.overall_score as double),
        cast(surv.hcahps_base_score as int))
from survey_responses_transformed as surv
inner join (
    select h.provider_id as provider_id,
        (score_rank + time_rank)/2 as overall_score
    from (
        select distinct sc.provider_id, sc.aggregate_score, tim.aggregate_time, 
        dense_rank() over (order by sc.aggregate_score) as score_rank,
        dense_rank() over (order by tim.aggregate_time desc) as time_rank
        from (
            select y.provider_id, avg(y.mean_score) 
                over (partition by y.provider_id) as aggregate_score
            from (
                select provider_id, measure_id, avg(score) 
                    over (partition by provider_id, measure_id) as mean_score
                from effective_care_hospital_transformed
                where score IS NOT NULL AND score<>"Not Available"
                    AND NOT (
                                measure_id="OP_5" OR
                                measure_id="OP_1" OR
                                measure_id="OP_21" OR
                                measure_id="OP_3b"
                    )
                    AND not provider_id=0
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
                            AND (
                                measure_id="OP_5" OR
                                measure_id="OP_1" OR
                                measure_id="OP_21" OR
                                measure_id="OP_3b"
                            )
                            AND not provider_id=0
                        ) as x
                ) as tim
                on sc.provider_id = tim.provider_id
        ) as z
        inner join hospitals_transformed as h
            on z.provider_id = h.provider_id
    ) as eff
    on surv.provider_id=eff.provider_id
where not surv.provider_id=0;


-- Calculate correlation between survey base score and care variance         ;
select corr(cast(eff.aggregate_var as double),
        cast(surv.hcahps_base_score as int))
from survey_responses_transformed as surv
inner join (
    select distinct y.provider_id, y.measure_var as aggregate_var
    from (
        select provider_id, measure_id, variance(score) 
            over (partition by provider_id, (
                measure_id="PN_6" AND
                measure_id="HF_2" AND
                measure_id="IMM_2" AND
                measure_id="IMM_3_FAC_ADHPCT" AND
                measure_id="VTE_1" AND
                measure_id="SCIP_VTE_2" AND
                measure_id="ED_1b" AND
                measure_id="ED_2b" AND
                measure_id="SCIP_INF_1" AND
                measure_id="SCIP_INF_2" AND
                measure_id="SCIP_INF_3" AND
                measure_id="OP_20" AND
                measure_id="OP_18b" AND
                measure_id="SCIP_INF_9" AND
                measure_id="SCIP_INF_10" AND
                measure_id="OP_22" AND
                measure_id="OP_21"
            )) as measure_var
        from effective_care_hospital_transformed
        where not provider_id=0
        ) as y
        where y.measure_var > 500
    ) as eff
    on surv.provider_id=eff.provider_id
where not surv.provider_id=0;
