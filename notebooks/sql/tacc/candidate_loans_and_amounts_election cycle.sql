--https://modeanalytics.com/editor/code_for_san_francisco/reports/c8cb5e40e52e
--candidate's number of loans and amounts per election cycle
--scavenger hunt question #8
--Q1

select 
  recipient_candidate_name,
  election_cycle,
  sum(transaction_amount) as loan_amount,
  count(transaction_type) as num_loans,
  recipient_candidate_office
from trg_analytics.candidate_contributions
where transaction_type like '%Loan%'
group by 
  recipient_candidate_name,
  election_cycle,
  recipient_candidate_office
order by 
  loan_amount desc,
  num_loans desc
