############# chapter 1
############# https://learn.datacamp.com/courses/market-basket-analysis-in-r
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  try(sapply(pkg, require, character.only = TRUE), silent = TRUE)
}
packages <- c("dplyr","tidyr","ggplot2")
ipak(packages)
# Market basket introduction
# chapter 1: introduction to market basket analysis
# chapter 2: metrics and techniques in market basket analysis
# chapter 3: visualization in market basket analysis
# chapter 4: (go beyond retail) Case study: movie recommendations @ movielens

# basket = collection of items
# products at supermarket
# products on online website
# datacamp courses
# movies by users

# grocery store example: what's in the store

store = c("Bread","Butter", "Cheese", "Wine")

set.seed(1234)
n_items = 4
my_basket = data.frame(TID = rep(1, n_items),
                       Product = sample(store, n_items, replace = TRUE))



# The focus on the market basket analysis
# is rather on the which products than
# on the how much

# one record per item purchased

my_basket = my_basket %>% add_count(Product) %>% 
  unique() %>% rename(Quantity = n)

# 
n_distinct(my_basket$Product)

# 
my_basket %>% summarize(sum(Quantity))

# Visualizing items in my basket
ggplot(my_basket, 
       aes(x = reorder(Product, Quantity),
           y = Quantity)) + geom_col() +
  coord_flip() + xlab("Items") + 
  ggtitle("Summary of items in my basket")

# Why are we looking at my basket?
# Question: Is there any relationship between items
# within a basket?

# Your basket @ the grocery store
# Your amazon shopping cart
# Your courses @ Datacamp, e.g., intro to R
# and intermediate R



# Item combinations
# Sets, subsets, and supersets
# itemset 
# What's the set of all possible subsets of X?
# intersections and unions
# 
A = c("Bread", "Butter")
B = c("Bread", "Wine")

intersect(A, B)

# 
union(A, B)

# how many baskets of size k from a
# set of size n
# n choose k

# how many possible baskets?
# Newton binom formula
# \sum k = 0, n n choose k = 2^n

# choose function
# plotting number of combinations
# use stat_function
# to plot function

# # Define number of items 
# n_items = 50
# 
# # Specify the function to be plotted
# fun_combi = function(x) choose(n_items, x)
# 
# # Plot the number of combinations
# ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
#   stat_function(fun = fun_combi) + xlim(0,n_items)


# # Define number of items 
# n_items = 100
# 
# # Specify the function to be plotted
# fun_combi = function(x) choose(n_items, x)
# 
# # Plot the number of combinations
# ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
#   stat_function(fun = fun_combi) + xlim(0,n_items)



# market basket analysis
# multiple baskets @ grocery store
# If 100 customers visit the grocery
# store, can we find associations of items
# that occur together?

# if this, then that
# learning from multiple baskets
# E-commerce: customers who bought this 
# also bought this

# Retail: iterms which
# are bundled or placed together

# Social media: Friends and connections recommendation

# videos and movies recommendation

# multiple baskets

# Basket id
# Product 

# What's in our baskets?
# n_distinct()

# using group_by, n() for size
# n_discinct() for # of distinct items

# how big are baskets?
# ggplot + geom_bar

# Specific products in the baskets
# Association rule mining: fiding
# frequent co-occuring associations 
# among a collection of items

# Bread -> butter
# Let's play with baskets




