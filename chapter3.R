###################
###################
### Chapter 3
###################
###################


library(arules)
# Let's see what is in the basket
# Graphical visualizations
# We need to be able to visualize the results in an efficient way

# Item frequency plot
# 
itemFrequencyPlot(data_trx, main = "Absolute Item frequency plot", type = "absolute")
# or relative

# what if you have thousands of items
itemFrequencyPlot(data_trx, topN = 4, main = "Absolute Item Frequency Plot", type = "absolute")

# Further customization
# Flip and customize plot
# horiz = TRUE
# cex.names = 0.8
# col = rainbow(4)



###### Visualizing metrics
###### Interactive table with metrics
###### apriori

###### one of the biggest challenges for market basket analysis is the potentially large number of rules
###### 

library(arules)
rules = apriori(data_trx, parameter = list(supp = 3/7, conf = 0.6, minlen = 2))
inspect(rules)

#######
library(arulesViz)
inspectDT(rules) # gives an HTML table

########
plot(rules) # scatterplot from arulesViz


########
## options of the plot
plot(rulesObject, measure, shading, method) # shading: measure used to color points
# method: 

plot(rules, measure = c("confidence", "lift"), shading = "support", method = "scatterplot")

## Other arules plots
## two-key plot
plot(rules, method = "two-key plot")

## jittering your plots
## 
plot(rules, method = "two-key plot")

## with jittering
plot(rules, method = "two-key plot", jitter = 2)

## Interactive arules plots
## interactive rules
plot(rules, engine = "plotly") # 


## how to visualize thousands of rules?
## from rules to graph based visualizations
##
rules_html = plot(rules, method = "graph", engine = "htmlwidget")

## 
rules_html

## 
library(htmlwidgets)
saveWidget(rules_html, file = "rules_grocery.html")

## select item, select rule

## 
# Selecting items and rules from the graph
## sort rules by confidence
## 
top4subRules = head(sort(rules, by = "confidence"), 4)
inspect(top4subRules)


## saveAsGraph(rules, file = "rules.graphml")

## can be explored using Gephi software

## graph can allow you to have a clear overview of the different types of association
## between items

## Graphs and subgraphs
## sort rules by confidence

# HTML widget graph for the highest confidence rules
plot(head(sort(rules_online, by="confidence"), 5),
     method = "graph",
     engine = "htmlwidget")



# HTML widget graph for rules with lowest lift
plot(tail(sort(rules_online, by="lift"), 5),
     method = "graph",
     engine = "htmlwidget")


# Portability of your graph
# It is important to save your work, especially if you are 
# dealing with a very large set of transactions. 
# This will allow you to gain time and be sure to have 
# reproducible results. Once you have extracted rules and 
# generated insightful visualizations, you want to save your graph 
# for later inspection. The rules_online is saved in your workspace.



# Alternative rule plots
# wrap all plots within a shiny app
# group-based matrix visualizations
# apriori for rule extraction
# plot(rules, method = "grouped")
# grouped matrix for 15 rules

# Plot a group matrix-based visualization
plot(subset_rules, method = "grouped")

# Change the arguments of group matrix-based visualization
plot(subset_rules, 
     method = "grouped",
     measure = "lift",
     shading = "confidence")

# in this matrix looking plots antecedents or items on the left hand side
# are grouped using clustering techniques
# groups are represented by the most interesting item in the group
# the most interesting means that it has the highest ratio of
# support in the group to support in all rules
# Ballons in the matrix are used to represent with which
# consequent the antecedents are connected
# Group-based matrix visualizations
# plot(rules, method = "paracoord")
# shiny app
# ruleExplorer(rules)
# data table
# scatter
# matrix
# grouped
# graph

# shiny fundamentals
# 