
--Query shows top Donors for 2015:
--select * from data_ingest.maplight__california_candidate where election_cycle=2015 order by transaction_amount desc


--Looks at distinct names to get an idea for name matching.
--select distinct(recipient_candidate_name) from data_ingest.maplight__california_candidate where recipient_candidate_name ilike '%Brown%'
--select distinct(candidate_name) from data_ingest.casos__california_candidate_statewide_election_results  where candidate_name ilike '%Brown%'


--Pulls the top 5 donors for each candidate for the year 2016
--select * from
--(
--select recipient_candidate_name, transaction_amount, donor_name, extract(year from election) as fund_year,
--Rank() over(Partition by recipient_candidate_name order by transaction_amount desc)
--as Rank 
--from trg_analytics.candidate_contributions 
--)as top5
--where Rank <=5
--and fund_year=2016


--Pulls the top 5 donors for each candidate for the year 2016 but only looking at companies
--select * from
--(
--select recipient_candidate_name, transaction_amount, donor_name, donor_organization, extract(year from election) as fund_year,
--Rank() over(Partition by recipient_candidate_name order by transaction_amount desc)
--as Rank 
--from trg_analytics.candidate_contributions 
--)as top5
--where Rank <=5
--and fund_year=2016
--and donor_organization ='COM'


--This displays the number of times a donor has made a contribution in the data set
--select count(donor_committee_id) as num_contrib, donor_name
--from trg_analytics.candidate_contributions
--group by donor_name
--order by num_contrib desc


--This displays the number of times a donor has made a contribution in 2016
--select count(donor_committee_id) as num_contrib, extract(year from election), donor_name
--from trg_analytics.candidate_contributions
--where extract(year from election)=2016
--group by donor_name, extract(year from election), donor_name
--order by num_contrib desc

--Displays the total amount of money each donor has given
--select sum(transaction_amount) as total_donations, donor_name
--from trg_analytics.candidate_contributions
--group by donor_name
--order by total_donations desc


--Displays the total amount of money each donor has given for 2016
--select sum(transaction_amount) as total_donations, extract(year from election), donor_name
--from trg_analytics.candidate_contributions
--where extract(year from election)=2016
--group by donor_name, extract(year from election), donor_name
--order by total_donations desc


