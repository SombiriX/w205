-- This query answers: Which procedures have the greatest variability between  ;
--  hospitals?                                                                 ;
--                                                                             ;
-- The query returns the top 10 highest variability procedures amongst         ;
-- hospitals within the Centers for Medicare & Medicaid Services database      ;
-- to perform the query this SQL code uses data from the hospital complications;
-- and effective care tables. The variability is calculated for each measure   ;
-- and entries with null or non-numeric values are omitted.                    ;


select distinct 
  case 
    when a.measure_id is null then b.measure_id
    else a.measure_id
  end as m_id,
  case 
    when a.measure_var is null then b.measure_var
    else a.measure_var
  end as m_var,
  case 
    when a.measure_name is null then b.measure_name
    else a.measure_name
  end as m_name
from (
    select cmp.measure_id, cmp.measure_var, meas.measure_name
    from (
        select c.measure_id, variance(cast(c.score as double))
            over (partition by c.measure_id) as measure_var
        from complications_hospital_transformed as c
        where c.score IS NOT NULL AND c.score<>"Not Available"
            AND NOT c.provider_id=0
        ) as cmp
    inner join measures_transformed as meas
        on meas.measure_id=cmp.measure_id
) a
full outer join (
    select eff.measure_id, eff.measure_var, meas.measure_name
    from (
        select v.measure_id, variance(cast(v.score as double)) 
            over (partition by measure_id) as measure_var
        from effective_care_hospital_transformed as v
        where v.score IS NOT NULL AND v.score<>"Not Available"
            AND NOT v.provider_id=0
            AND NOT (
                v.score like "Low%" OR
                v.score like "Medium%" OR
                v.score like "High%" OR
                v.score like "Very High%"
            )
        ) as eff
    inner join measures_transformed as meas
        on meas.measure_id=eff.measure_id
) b
on a.measure_id=b.measure_id
where a.measure_id is null or b.measure_id is null
order by m_var desc
limit 10;
