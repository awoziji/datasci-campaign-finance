drop table if exists fuzzy_merge.all_candidate_names;
create table fuzzy_merge.all_candidate_names
(
  source_election_fn text,
  source_election_ln text,
  source_election_candidate_name text,
  source_donation_fn text,
  source_donation_ln text,
  source_donation_candidate_name text
);

insert into fuzzy_merge.all_candidate_names

with candidate_donations as
(
select distinct
    lower(trim(regexp_replace(split_part(recipient_candidate_name, ', ', 2),'\s.(\.|$)',''))) as first_name,
    lower(trim(split_part(recipient_candidate_name, ', ', 1))) as last_name,
    recipient_candidate_name as candidate_name
from trg_analytics.candidate_contributions
where recipient_candidate_name is not null
),

election_results as
(
select distinct
  *,
  lower(trim(regexp_replace(substring(candidate_name, 0, position(last_name in lower(candidate_name))),'\s.(\.|$)',''))) as first_name
from
  (
    select
      contest_name,
      candidate_name,
      vote_total,
      rank() over (partition by contest_name order by vote_total desc) = 1 as is_winner,
      lower(trim(regexp_replace((regexp_matches(candidate_name,'[^ ]*$'))[1],'\*',''))) as last_name
    from data_ingest.casos__california_candidate_statewide_election_results
    where county_name in ('State Totals', 'District Totals')
      and candidate_name is not null
  ) as sub
)

select
  election_results.first_name as source_election_fn,
  election_results.last_name as source_election_ln,
  election_results.candidate_name as source_election_candidate_name,
  candidate_donations.first_name as source_donation_fn,
  candidate_donations.last_name as source_donation_ln,
  candidate_donations.candidate_name as source_donation_candidate_name
from candidate_donations
cross join election_results
