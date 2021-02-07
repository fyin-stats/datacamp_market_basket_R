############ chapter 4
############

#### Recap on transactions
#### perform market basket analysis to perform movie recommendations

#### Market basket analysis: focus on the what, not on how much
#### Main metrics: Support, confidence, lift

#### the set of extracted rules can be very large
#### Groceries dataset
#### arules package

#### 
library(arules)

####
data(Groceries)

####
summary(Groceries) # already in transaction dataset

#### plotting a sample of 200 transactions
image(sample(Groceries, 200)) # density is of 2.6%

#### contingency table
tbl = crossTable(Groceries)
tbl[1:4, 1:4]

# sort contingency table by frequency
tbl = crossTable(Groceries, sort=TRUE)
tbl[1:4, 1:4]

# counts 
tbl['whole milk', 'flour']

# Chi-square test
crossTable(Groceries, measure = "chi")['whole milk', 'flour']

# contingency tables with other metrics
# 
crossTable(Groceries, measure = "lift", sort = T)[1:4, 1:4]

# movielens dataset
# Web based recommender system that recommends movies for its users to watch
# 

# Split dataset into movies and users
data_list = split(movie_subset$title,
                  movie_subset$userId)

# Transform data into a transactional dataset
movie_trx = as(data_list, "transactions")

# Plot of the item matrix
image(movie_trx[1:100,1:100])

#
# Plot the absolute item frequency plot
itemFrequencyPlot(movie_trx,
                  type = "absolute",
                  topN = 10,
                  horiz = TRUE,
                  main = 'Absolute item frequency')

# Setting the plot configuration option
par(mfrow=c(2,1))

# Plot the relative and absolute item frequency plot
itemFrequencyPlot(movie_trx,
                  type = "relative",
                  topN = 10,
                  horiz = TRUE,
                  main = 'Relative item frequency')

itemFrequencyPlot(movie_trx,
                  type = "absolute",
                  topN = 10,
                  horiz = TRUE,
                  main = 'Absolute item frequency')

#
# Setting the plot configuration option
par(mar=c(2,30,2,2), mfrow=c(1,1))

# Plot the 10 least popular items
barplot(sort(table(unlist(LIST(movie_trx))))[1:10],
        horiz = TRUE,
        las = 1,
        main = 'Least popular items')

# Mining association rules
# Frequent itemsets with the apriori
# extract the set of most frequent itemsets
itemsets_freq2 = apriori(Groceries,
                         parameter = list(supp = 0.01, minlen = 2, target = "frequent"))

# 
inspect(head(sort(itemsets_freq2, by="support")))


# Rules with apriori
rules = apriori(Groceries, parameter = list(supp = 0.001,
                                            conf = 0.5,
                                            minlen = 2,
                                            target = "rules"))

# 
inspect(head(sort(rules, by="confidence")))

# Choose parameters arules
# set of confidence values
# can even loop over both confidence and support parameters
#
# set of confidence levels
confidenceLevels = seq(from = 0.1, to = 0.9, by = 0.1)
# create empty vector
rules_sup0005 = NULL
# Apriori algorithm with a support level of 0.5%
for(i in 1:length(confidenceLevels)){
  rules_sup0005[i] = length(apriori(Groceries,
                            parameter = list(supp = 0.005, 
                                             conf = confidenceLevels[i],
                                             target = "rules")))
  
}

# 
library(ggplot2)
# number of rules found with a support level of 0.5%
qplot(confidenceLevels,
      rules_sup0005,
      geom = c("point", "line"), xlab = "Confidence level",
      ylab = "Number of rules found") + theme_bw()

# can even loop through both confidence level and lift
# can be time consuming
# 
inspect(subset(rules, subset = items %in% c("soft cheese", "whole milk") & confidence > 0.95))

# Flexibility of subsetting

#

# Extract the set of most frequent itemsets
itemsets = apriori(movie_trx,
                   parameter = list(support = 0.4,
                                    target = 'frequent'
                   ))

# Inspect the five most popular items
inspect(sort(itemsets, by='support', decreasing = T)[1:5])


# Extract the set of most frequent itemsets
itemsets_minlen2 = apriori(movie_trx, parameter = 
                             list(support = 0.3,
                                  minlen = 2,
                                  target = 'frequent'
                             ))

# Inspect the five most popular items
inspect(sort(itemsets_minlen2, 
             by='support', decreasing = T)[1:5])

# Extract the set of most frequent itemsets
itemsets_minlen2 = apriori(movie_trx, parameter = 
                             list(support = 0.3,
                                  minlen = 2,
                                  target = 'frequent'
                             ))

# Inspect the five least popular items
inspect(sort(itemsets_minlen2, 
             by='support', decreasing = FALSE)[1:5])



# 
# Picking the right movie parameters
# 
# You are still wondering how to decide which parameters to add in the apriori() function. In particular, you need to decide the thresholds to use for the minimum support, confidence or eventually lift measures. 
# The parameters added to the apriori() function will have an impact on the set of movie rules we obtain. To help in deciding which parameters are most appropriate to obtain the set of movie rules, let's create a plot of the number of rules. 
# In this exercise, you will create a plot to decide on the most appropriate 
# combination of parameters to be used in the apriori() function.


# Create data frame with all metrics to be plotted
nb_rules = data.frame(rules_sup04, rules_sup03,
                      confidenceLevels)

# Number of rules found with a support level of 40% and 30%
ggplot(data=nb_rules, aes(x=confidenceLevels)) +
  # Lines and points for rules_sup04
  geom_line(aes(y=rules_sup04, colour="Support level of 40%")) + 
  geom_point(aes(y=rules_sup04,colour="Support level of 40%")) +
  # Lines and points for rules_sup03
  geom_line(aes(y=rules_sup03, colour="Support level of 30%")) +
  geom_point(aes(y=rules_sup03,colour="Support level of 30%")) + 
  # Polishing the graph
  theme_bw() + ylab("") +
  ggtitle("Number of extracted rules with apriori")


# Extract rules with the apriori
rules_movies = apriori(movie_trx,
                       parameter = list(supp = 0.3,
                                        conf = 0.9,
                                        minlen = 2, 
                                        target = "rules"))

# Summary of extracted rules
inspect(rules_movies)


# Extract rules with the apriori
rules_movies = apriori(movie_trx,
                       parameter = list(supp = 0.3,
                                        conf = 0.9,
                                        minlen = 2, 
                                        target = "rules"))

# Summary of extracted rules
summary(rules_movies)

# Create redudant rules and filter from extracted rules
rules_red = is.redundant(rules_movies)
rules.pruned = rules_movies[!rules_red]
# Inspect the non-redundant rules with highest confidence
inspect(head(sort(rules.pruned, by="confidence")))



# Visualizing transactions and rules
# interactive inspection

# inspectDT(rules)
# interactively filter the rules
# 

# arulesViz
# plot(rules, method, engine)

# plot rules as graph
# method = "graph"
# engine = "html"
# think about subsetting rules to be displayed

# Interactive subgraphs
# sorting extracted rules
# top 10 rules with highest confidence
# 
top10_rules_Groceries = head(sort(rules, by = "confidence"), 10)
inspect(top10_rules_Groceries)

# 
plot(top10_rules_Groceries, method = "graph", engine = "html")

# 
rules = apriori(Groceries, parameter = list(sup=0.001, conf=0.8))
ruleExplorer(rules)

# Let's visualize some movie rules
# 

# Interactive matrix-based plot
plot(rules_movies, method = "matrix",
     shading ="confidence",
     engine = "html"
)

# Plot rules as scatterplot
plot(rules_movies,
     measure = c("confidence", "lift"),
     shading = "support",
     jitter = 1,
     engine = "html")

# Grouped matrix plot of rules
plot(rules_movies, 
     method = "grouped",
     measure = "lift",
     shading = "confidence")

# Parallel coordinate plots with confidence as color coding
plot(rules_movies, 
     method = "paracoord", 
     shading = "confidence")

# Plot movie rules as a graph
plot(rules_movies,
     method = "graph",
     engine = "htmlwidget")

# Plot movie rules as a graph
plot(rules_movies,
     method = "graph",
     engine = "htmlwidget")

# Retrieve the top 10 rules with highest confidence
top10_rules_movies = head(sort(rules_movies,
                               by = "confidence"), 10)

# Plot as an interactive graph the top 10 rules
plot(top10_rules_movies,
     method = "graph",engine = "htmlwidget")



###################################
# Making the most of market basket analysis
# true impact of market basket analysis
# 


# Understanding customers / users
# Understand which items are purchased in combination
# Extract sets of rules
# Infer on the relationship between items

# The extra mile to MBA
# add customer/user information
# segment (cluster) customers according to their preferences

# Reccommedations to customers / users
# Offline world: placing items strategically in the shop such that items 
# often purchased together are close to each other

# online world: expose related items on the same page, just a click away

# yogurt as a consequent
# 

# Extract rules with Yogurt on the right side
yogurt_rules_rhs <- apriori(Groceries,
                            parameter = list(supp = 0.001, conf = 0.8),
                            appearance = list(default = "lhs", rhs="yogurt"))

# 
inspect(head(sort(yogurt_rules_rhs, by =  "lift")))

# can make the shopping experience better for customers

# What did yogurt influence?
# Yogurt as an antecedent
# Extract rules with Yogurt on the right hand side
yogurt_rules_lhs = apriori(Groceries, 
                           parameter = list(supp = 0.001, conf = 0.8, minlen=2),
                           appearance = list(default = "rhs", lhs = "yogurt"))
# Summary of rules
summary(yogurt_rules_lhs)

# we should not decrease the confidence level just for the purpose of
# finding rules
# A confidence of 50% means that you are 50% sure that the inferred relationship
# holds true
# Hence the confidence you have in the inferred rules is not high
# enough to take actionable measures

# What influenced Pulp Fiction?

# In the video exercise, 
# you were exposed to the value created by Market Basket Analysis in the 
# offline word when applied to retail. In this exercise, 
# you will take the same concepts to build movie recommendations online. When building movie recommendations, it's essential to be able to take in a watched movie by a customer and based on the viewing behavior of the customer and customers like them, to provide actionable recommendations. In this exercise, you will figure out which watched movies are most likely to lead to a recommendation of the movie Pulp Fiction, by figuring out the rules associated with it on the RHS. 
# The transactional dataset movie_trx is loaded in the workspace.

# Inspect the first few rules with the item Pulp Fiction 
# as a antecedent item and at least two items for the rules.

# Extract rules with Pulp Fiction on the left side
pulpfiction_rules_lhs = apriori(movie_trx, 
                                parameter = list(supp = 0.3,
                                                 conf = 0.5, 
                                                 minlen = 2), 
                                appearance = list(
                                  default = "rhs",
                                  lhs = "Pulp Fiction")) 

# Inspect the first rules
inspect(head(pulpfiction_rules_lhs))


# Use your market basket skills
# Other points to consider with market basket analysis

# Not in the scope of this course
# Time dimension, when transactions were done, when a user watched a movie
# qualitative asssessment of transactions, e.g., movie ratings

# use sorting options, head and tail
# do not print blindly rules
# work with smaller subsets of rules

# 