--https://modeanalytics.com/editor/code_for_san_francisco/reports/9b612f447429
--candidate_donor_state_contributions
--q1: candidate donor state source and total transaction
--q2: candidate in-state and out-of-state contributions per election cycle; scaled in state transactions per election cycle;

--Q1

select 
  recipient_candidate_name,
  election_cycle,
  count(*) as num_contrib,
  regexp_replace(upper(donor_state), '[^A-Z]', '' , 'g')  as candidate_donor_states,
  sum(transaction_amount)  as state_transaction,
        --DECLARE @money money = '125000';
        --SELECT FORMAT ( @money, 'C', 'en-US'  ) AS MyMoney;
  sum(transaction_amount) / count(*) as avg_$_per_contribution
  
from trg_analytics.candidate_contributions
where  regexp_replace(upper(donor_state), '[^A-Z]', '' , 'g') in ( 
    'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY'
) 
  and recipient_candidate_name like '%BROWN, EDMUND G. (JERRY)%'
group by recipient_candidate_name, election_cycle, candidate_donor_states
order by election_cycle desc


--Q2

with table_ten as ( -- candidate in state contributions per election cycle

select 
  recipient_candidate_name,
  election_cycle,
  count(*) as num,
  regexp_replace(upper(donor_state), '[^A-Z]', '' , 'g')  as candidate_donor_states,
  sum(transaction_amount) as in_state_trans
  
from trg_analytics.candidate_contributions
where  regexp_replace(upper(donor_state), '[^A-Z]', '' , 'g') in ( 
    'CA'
 -- 'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY'
) 
  and recipient_candidate_name like '%BROWN, EDMUND G. (JERRY)%'
group by recipient_candidate_name, election_cycle, candidate_donor_states
order by election_cycle desc
),

table_eleven as ( -- candidate total donor city per election cycle
select 
  recipient_candidate_name,
  election_cycle,
  count(*) as total_donor_states,
  sum(transaction_amount) as total_trans
from trg_analytics.candidate_contributions
where recipient_candidate_name like '%BROWN, EDMUND G. (JERRY)%'
group by 
  election_cycle, 
  recipient_candidate_name
order by election_cycle desc
)

select 
  table_ten.recipient_candidate_name as candidate_name,
  table_ten.election_cycle as election_cycle,
  --in state
  table_ten.num as num_in_state_contib,
  table_ten.in_state_trans as in_state_transaction,

  case when table_ten.num != 0
       then table_ten.in_state_trans / table_ten.num
       else 0
  end as avg_trans_per_in_state_contrib,
  
  table_ten.in_state_trans / table_eleven.total_trans as scaled_in_state_trans,
  
  -- out of state
  table_eleven.total_donor_states - table_ten.num as num_out_state_contib,
  table_eleven.total_trans - table_ten.in_state_trans as out_state_trans,
  
  case when (table_eleven.total_donor_states - table_ten.num) != 0
       then (table_eleven.total_trans - table_ten.in_state_trans) / (table_eleven.total_donor_states - table_ten.num) 
       else 0
  end as avg_trans_per_out_state_contrib

from table_ten
join table_eleven
on table_ten.recipient_candidate_name = table_eleven.recipient_candidate_name
  and  table_ten.election_cycle = table_eleven.election_cycle
  
  
