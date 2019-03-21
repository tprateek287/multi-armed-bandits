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
plot(Rewards ~ Algorithm, data = df)
ddply(df, ~ Algorithm, function(data) summary(data$Rewards))
ddply(df, ~ Algorithm * Time, function(data) summary(data$Rewards))

# Test for normality
for (time in unique(df$Time)) {
  for (algorithm in unique(df$Algorithm)) {
    gof = shapiro.test(df[df$Algorithm == algorithm & df$Time == time,]$Rewards)
    cat("Algorithm:", algorithm, ",Time:", time, ",p-value:", gof$p.value, "\n")
  }
}

# set sum-to-zero contrasts for the Anova call
contrasts(df$Algorithm) <- "contr.sum"

# LMM test on rewards
library(lme4)
library(lmerTest)
m = lmer(Rewards ~ (Algorithm * Time) + (1|Algorithm:Simulation), data=df)
Anova(m, type=3, test.statistic="F")

# Post hoc tests
library(multcomp) # for glht
library(lsmeans) # for lsm
summary(glht(m, lsm(pairwise ~ Algorithm * Time)), test=adjusted(type="holm"))
