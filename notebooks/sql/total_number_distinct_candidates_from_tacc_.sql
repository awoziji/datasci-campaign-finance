--results: 1550 recipient_candidate_name with regular expression
select count(sub. re_name_distinct) as distinct_re_name_tacc
from (
  select
      distinct( regexp_replace(lower(split_part(recipient_candidate_name, ',', 2) || split_part(recipient_candidate_name, ',', 1)), '[^a-z]', '', 'g') )  as re_name_distinct
  from trg_analytics.candidate_contributions 
) sub
