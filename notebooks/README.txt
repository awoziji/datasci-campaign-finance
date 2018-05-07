

SQL Folder:
  Inside the SQL folder there is a file for data exploration. This file consists
of various sql queries to help gain knowlodge of the dataset. The candidate
contributions with election results file is an sql query that was created for
feature engineering. The output from this sql query can be used for machine
learning. This data set contains information about a contribution including
amount, date, and information about the donor. As well as it indicates if the
donation was made to a candidate who won or lost that election.


R Folder:
   This folder contains a CSV file with the dataset from the above mentioned
sql query. The R file creates a simple Regression Tree that can predict an 
outcome of an election based on contribution data. The tree uses all the 
features except candidate name and transaction ID. 

The top 5 features in order:
donor_name
filed_date
donor_zip_code
donor_city
transaction_date
