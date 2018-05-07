library(rpart)
library(rpart.plot)
library(maptree)

dat = read.csv("FinanceData.csv")
summary(dat)
str(dat)
table(dat$is_winner)                     # 30k lost / 89K won
dat=dat[,c(-1,-2,-6,-7,-14)]     # Drops Candidate Names and Transaction ID


write.csv(dat, file="combined_finance_data.csv")
dat$is_winner=factor(dat$is_winner)
dat$election_year=factor(dat$election_year)

nrows=nrow(dat)
tr_rows=sample(1:nrows,0.3*nrows)        # Uses 30% of data to train on yields about 89% accuracy
tr_dat=dat[tr_rows,]
te_dat=dat[-tr_rows,]

fit=rpart(is_winner~., data=tr_dat, method="class")

summary(fit)                    # Order of Importance: donor_name -> filed_date -> donor_zip_code -> donor_city -> transaction_date
prp(fit, type=2, extra=106, varlen=-1, main="Regression Tree Campaign Data", box.col=c("green", "blue")[fit$frame$yval])
predicted=predict(fit,te_dat, type = "class")
actuals=te_dat$is_winner
accuracy=mean(actuals==predicted)
accuracy                        # Accuracy averages between 83-90% depending on size of training data
conf_matrix=table(actuals, predicted)
conf_matrix
