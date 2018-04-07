--results: 1563 distinct recipient_candidate_name with NO regular expression

select count(sub.name) as distinct_original_names_tacc
from (
  select
      distinct(recipient_candidate_name) as name
  from trg_analytics.candidate_contributions 
) sub
