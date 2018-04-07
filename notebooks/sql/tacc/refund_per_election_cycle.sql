--https://modeanalytics.com/editor/code_for_san_francisco/reports/b55118c60f67
--candidate refund per election cycle
--include scaled refund trans amount vs total trans amount; 
--refund = negative transaction

--Q2
with table_a as (

select
  recipient_candidate_name,
  election_cycle,
  sum(transaction_amount) as total_trans_amount
from trg_analytics.candidate_contributions
where recipient_candidate_name like '%YEE, LELAND Y.%'
group by recipient_candidate_name, election_cycle
order by election_cycle desc
), 

table_b as (
select
  recipient_candidate_name,
  election_cycle,
  sum(transaction_amount) as refund_trans_amount,
  count(transaction_amount) as num_refunds
from trg_analytics.candidate_contributions
where recipient_candidate_name like '%YEE, LELAND Y.%'
  and  transaction_amount < 0
group by recipient_candidate_name, election_cycle

order by election_cycle desc
)

select 
  table_a.recipient_candidate_name,
  table_a.election_cycle,
  num_refunds,
  refund_trans_amount,
  total_trans_amount,
  -1 * refund_trans_amount / total_trans_amount as scaled_refund_amount
from table_a
join table_b
on table_a.recipient_candidate_name = table_b.recipient_candidate_name
and table_a.election_cycle = table_b.election_cycle
  
