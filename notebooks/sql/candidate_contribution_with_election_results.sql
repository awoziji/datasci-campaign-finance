--This SQL statement focuses on the contributions and shows which donors donated to candidates who won or lost.
--The SQL statement creates a table with 119,860 rows
--This table can be used for machine learning to predict a winner based off who donates to them.

with t1 as ( --cadidate_contribution_per_election_cycle
  select 
      recipient_candidate_name as rcn,
      election_cycle as ec,
      transaction_amount,
      donor_name,
      donor_city,
      donor_state,
      donor_zip_code,
      donor_organization,
      transaction_id,
      transaction_type,
      transaction_date,
      filed_date,
      recipient_candidate_office
      
  from trg_analytics.candidate_contributions
  where cast(election_cycle as int) >= 2009 -- The election cycle year has to match the dicccser table election year time interval as to obtian the election results.
  group by transaction_id
),

t2 as (
  select
    replace( candidate_name, '*', '') as cn,
    party_name,
    election_name,
    contest_name,
    sum(vote_total) as total_votes,
    incumbent_flag,
    rank() over (partition by election_name,  contest_name  order by sum(vote_total)  desc)  = 1 as is_winner
  from data_ingest.casos__california_candidate_statewide_election_results
  where county_name like 'State Totals' 
    and contest_name not like 'President%'
    and contest_name not like 'president%'
    and contest_name not like 'US Senate%' 
    and contest_name not like 'United States Representative%'
    and contest_name not like 'us'
    and contest_name not like 'united%'
    and contest_name not like '%Congressional District'
  group by 
    candidate_name,
    party_name,
    contest_name,
    election_name,
    incumbent_flag
),

t2_a as (
  select 
    t2.cn,
    regexp_replace(lower(split_part(t2.cn, ',', 2) || split_part(t2.cn, ',', 1)), '[^a-z]', '', 'g') as cn_dicccser,
    cast(SUBSTRING( election_name, 1, 4) as int) as election_year,
    incumbent_flag,
    is_winner::int as is_winner
  from t2
 ),   
 
t1_a as (
  select 
      t1.rcn ,
      regexp_replace(lower(split_part(rcn, ',', 2) || split_part(rcn, ',', 1)), '[^a-z]', '', 'g') as rcn_tacc,
      --t1.rcn_tacc,
      cast( t1.ec as int)+1 as election_year,
      t1.transaction_amount,
      t1.donor_name,
      t1.donor_city,
      t1.donor_state,
      t1.donor_zip_code,
      t1.donor_organization,
      t1.transaction_id,
      t1.transaction_type,
      t1.transaction_date,
      t1.filed_date,
      t1.recipient_candidate_office
  from t1
)

select *
from t2_a 
join t1_a
on cn_dicccser = rcn_tacc
and t2_a.election_year = t1_a.election_year
order by t2_a.election_year


