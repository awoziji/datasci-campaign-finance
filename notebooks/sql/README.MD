#### Main merge statement. 
campaign_finance_and_election_results.sql

#### The current match rate as of 04.08.2018 and a link to Mode Analytics workspace verifying the SQL statements.

[https://modeanalytics.com/editor/code_for_san_francisco/reports/d4e007734c45](https://modeanalytics.com/editor/code_for_san_francisco/reports/d4e007734c45)

* Query 1 -  142 distinct candidate_name matches with regular expression.
   distinct_candidate_name_matches_with_re_from_tacc_and_dicccser.sql

* Query 3 -  1550 recipient_candidate_name with regular expression.
   distinct_recipient_candidate_name_with_re_from_tacc.sql

* Query 5 -  225 candidate_names with regular expression.
   total_number_distinct_candidates_from_dicccser.sql

* Query 21 - 230 distinct candidate_name with no regular expression.
   distinct_candidate_name_with_no_re_from_dicccser.sql

* Query 22 - 1563 distinct recipient_candidate_name with no regular expression.
   distinct_recipient_candidate_name_with_no_re_ from_tacc.sql

> 145/225 =  0.644 match rate

#### Workspace Abbreviations

* trg_analytics.candidate_contributions => tacc_
 
* data_ingest.casos__california_candidate_statewide_election_results => dicccser_

* regular expression => re_
