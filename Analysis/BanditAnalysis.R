## INSC 571 - Course Project
## Submitted by: Harkar Talwar, Prateek Tripathi

# Read in and analyze the data
df = read.csv("BanditRewards.csv")
View(df)

# Convert Simulation ID into a factor
df$Simulation = factor(df$Simulation)

# Rename the rewards column for conciseness
colnames(df)[colnames(df)=="Cumulative.Reward"] <- "Rewards"

# Exploration and summary statistics
library(plyr)
summary(df)
ddply(df, ~ Algorithm, function(data) summary(data$Rewards))
ddply(df, ~ Algorithm * Time, function(data) summary(data$Rewards))
# Differences in rewards distribution by algorithm
plot(Rewards ~ Algorithm, data = df)
# Rewards histogram at a given time step for each algorithm
hist(df[df$Algorithm == 'Epsilon Greedy' & df$Time == 600,]$Rewards, breaks = 15)
hist(df[df$Algorithm == 'UCB' & df$Time == 600,]$Rewards, breaks = 15)
hist(df[df$Algorithm == 'Thompson Sampling' & df$Time == 600,]$Rewards, breaks = 15)

# Shapiro-Wilk Test for normality
for (time in unique(df$Time)) {
  for (algorithm in unique(df$Algorithm)) {
    gof = shapiro.test(df[df$Algorithm == algorithm & df$Time == time,]$Rewards)
    cat("Algorithm:", algorithm, ",Time:", time, "Statistic:", gof$statistic, ",p-value:", gof$p.value, "\n")
  }
}

# Set sum-to-zero contrasts for the Anova call
contrasts(df$Algorithm) <- "contr.sum"

# Linear Mixed Model on rewards. Random intercepts for each simulation nested within
# the levels of algorithm
library(lme4)
library(lmerTest)
m = lmer(Rewards ~ (Algorithm * Time) + (1|Algorithm:Simulation), data=df)
Anova(m, type=3, test.statistic="F")

# Post hoc tests to check for differences in rewards for each pair of algorithms
# at the average time interval
library(multcomp)
library(lsmeans)
summary(glht(m, lsm(pairwise ~ Algorithm * Time)), test=adjusted(type="holm"))
