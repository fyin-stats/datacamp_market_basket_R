#### chapter 2
#### Transactional data
# install.packages("arules")
library(arules)
# transactional data: list of all
# items bought by a customer
# in a single purchase

# The transactional class
# in R

# Transactions-class:
# represents transacton
# data used for mining
# itemsets or rules

# coercsion from
# lists, matrices
# dataframes

# important when
# considering transactional
# data 
# field / column used to identify a product
# field / column used to identify a transaction
# 


# Back to the grocery store
# group item by transaction id

# Transform ID into a factor

# Split into groups
data_list

# Transforming to transaction class
# as(data_list, "transactions")
# inspect(data_trx)
# not to inspect large dataset

# more inspections of transactions
# summary of the transational data


# image(data_trx)
# item matrix
# use the function on a limited
# number of transactions

# let's inspect transactions
# 

# 
# Correct. In practice, densities of ItemMatrix are usually very low (0-5%) due to the large number of items.

# metrics used for rule extraction
# support measure: popularity of an itemset


# confidence measure: how often the rule is true
# conf(x --> y) = supp(X U Y) / supp(X)

# Lift measure: how strong is the association
# lift(X --> Y) = supp(X U Y) / (supp(X) * supp(Y))

# lift > 1: Y is likely to be bounght with X
# lift < 1: Y is unlikely to be bought if X is bought

# e.g., the lift of bread implies butter is 1.16
# meaning that bread and butter occur together
# 1.16 times more than random

# The apriori funtion from the arules package allows to 
# compute these metrics

# apriori()
# minimum length rules
# 

# the apiori function for rules
# 
# Determine the support of both items with support 0.01
support_rosemary_thyme = 
  apriori(Online_trx,
          parameter = list(target = "frequent itemsets",
                           supp = 0.01),
          appearance = list(items = 
                              c("HERB MARKER ROSEMARY",
                                "HERB MARKER THYME"))
  )

# Inspect the itemsets 
inspect(support_rosemary_thyme)

# Frequent itemsets for all items
support_all = 
  apriori(Online_trx,
          parameter = list(target="frequent itemsets",
                           supp = 0.01)
  )

# Inspect the 5 most frequent items
inspect(head(sort(support_all, by="support"), 5))


# Call the apriori function with apropriate parameters
rules_all = apriori(Online_trx,
                    parameter = list(supp=0.01, conf = 0.4, minlen=2)
)


# Call the apriori function with apropriate parameters
rules_all = apriori(Online_trx,
                    parameter = list(supp=0.01, conf = 0.4, minlen=2)
)

# Inspect the rules with highest lift
inspect(head(sort(rules_all, by="lift"), 5))

# Find the confidence and lift measures
rules_rosemary_rhs = 
  apriori(Online_trx,
          parameter = list(supp=0.01, conf=0.5, minlen=2),
          appearance = list(rhs="HERB MARKER ROSEMARY",
                            default = "lhs")
  )

# Inspect the rules
inspect(rules_rosemary_rhs)


# Create the union of the rules and inspect
rules_rosemary = arules::union(rules_rosemary_rhs,
                               rules_rosemary_lhs)
inspect(rules_rosemary)

# the a priori analysis
# association rule mining allows to discover interesting relationships between items
# in a large transactional database
# This mining task can be decomposed to two tasks
# Frequent item set generation
# rule generation, from the above frequent itemsets, generate association rules with confidence
# idea behind a priori algorithm: bottom up approach
# 

# Apply the apriori function to the Online retail dataset
rules_online = apriori(Online_trx,
                       parameter = list(supp = 0.01, conf = 0.8, minlen = 2))

# Inspect the first 5 rules
inspect(head(rules_online, 5))

# Inspect the first 5 rules with highest lift
inspect(head(sort(rules_online, by="lift"), 5))

# Transform the rules back to a data frame
rules_online_df = as(rules_online, "data.frame")

# Check the first records 
head(rules_online_df)


# if this then that with the apriori
# appearance of frequent itemsets for cheese and wine
# target = "frequent itemsets"
supp_cheese_wine =  apriori(trans,         
                               parameter = list(target = "frequent itemsets",          
                                                supp = 3/7),        
                               appearance = list( items = c("Cheese",  "Wine")))


# specific rules


# redundant rule: a rule is redundant if a more general rule witht the same or higher
# confidence exists

# a rule is more general if it has the same RHS but one or more items removed from the LHS

# R function: is.redundant
