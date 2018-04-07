--results: 341 distinct candidate_name with NO regular expression

select count( sub.name) as distinct_original_names_dicccser
from (
  select
    distinct(candidate_name) as name
  from data_ingest.casos__california_candidate_statewide_election_results
 where county_name like 'State Totals' 
    and contest_name not like 'President%'
    and contest_name not like 'president%'
    and contest_name not like 'US Senate%' 
    and contest_name not like 'United States Representative%'
    and contest_name not like 'us'
    and contest_name not like 'united%'
    and contest_name not like '%Congressional District'
)sub
