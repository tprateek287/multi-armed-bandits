## INSC 571 - Course Project
## Submitted by: Harkar Talwar, Prateek Tripathi

# Read in and analyze the data
df = read.csv("BanditRewards.csv")
View(df)

# Convert Simulation ID and Time into a factor
# Time is treated as a factor for the purpose of interpretation
df$Simulation = factor(df$Simulation)
df$Time = factor(df$Time)

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

# Interaction between Time and Algorithm
with(df, interaction.plot(Time, Algorithm, Rewards, ylim=c(0, max(df$Rewards))))

# Shapiro-Wilk Test for normality
for (time in unique(df$Time)) {
  for (algorithm in unique(df$Algorithm)) {
    gof = shapiro.test(df[df$Algorithm == algorithm & df$Time == time,]$Rewards)
    cat("Algorithm:", algorithm, ",Time:", time, "Statistic:", gof$statistic, ",p-value:", gof$p.value, "\n")
  }
}

# Tests for homoscedasticity (homogeneity of variance)
library(car)
leveneTest(Rewards ~ Algorithm * Time, data = df, center = mean) # Levene's test
leveneTest(Rewards ~ Algorithm * Time, data = df, center = median) # Brown-Forsythe test

# Set sum-to-zero contrasts for the Anova call
contrasts(df$Algorithm) <- "contr.sum"

# Linear Mixed Model on rewards. Random intercepts for each simulation nested within
# the levels of algorithm
library(lme4)
library(lmerTest)
m = lmer(Rewards ~ (Algorithm * Time) + (1 | Algorithm:Simulation), data = df)
Anova(m, type=3, test.statistic="F")
summary(m)

# Post hoc tests to check for differences in rewards for each pair of algorithms
# at the average time interval
library(multcomp)
library(emmeans)
summary(glht(m, emm(pairwise ~ Algorithm * Time)), test = adjusted(type = "holm"))

# Aligned Rank Transform on Error_Rate
library(ARTool) # for art, artlm
m = art(Rewards ~ (Algorithm * Time) + (1 | Algorithm:Simulation), data = df) # uses LMM
anova(m) # report anova

# m is the model returned by the call to art() above
# lsmeans reports p-values Tukey-corrected for multiple comparisons
# assume levels of 'X1' are 'a', 'b', and 'c'
lsmeans(artlm(m, "Algorithm"), pairwise ~ Algorithm)
lsmeans(artlm(m, "Time"), pairwise ~ Time)

# cross-factor pairwise comparisons using Wilcoxon signed-rank tests.
# we compare the 3 algorithms at the time levels of 200 and 600
eg.ucb.200 = wilcox.test(df[df$Algorithm == "Epsilon Greedy" & df$Time == 200,]$Rewards, 
                         df[df$Algorithm == "UCB" & df$Time == 200,]$Rewards, paired=TRUE, exact=FALSE)
eg.ts.200 = wilcox.test(df[df$Algorithm == "Epsilon Greedy" & df$Time == 200,]$Rewards, 
                        df[df$Algorithm == "Thompson Sampling" & df$Time == 200,]$Rewards, paired=TRUE, exact=FALSE)
ucb.ts.200 = wilcox.test(df[df$Algorithm == "UCB" & df$Time == 200,]$Rewards, 
                         df[df$Algorithm == "Thompson Sampling" & df$Time == 200,]$Rewards, paired=TRUE, exact=FALSE)
eg.ucb.600 = wilcox.test(df[df$Algorithm == "Epsilon Greedy" & df$Time == 600,]$Rewards, 
                         df[df$Algorithm == "UCB" & df$Time == 600,]$Rewards, paired=TRUE, exact=FALSE)
eg.ts.600 = wilcox.test(df[df$Algorithm == "Epsilon Greedy" & df$Time == 600,]$Rewards, 
                        df[df$Algorithm == "Thompson Sampling" & df$Time == 600,]$Rewards, paired=TRUE, exact=FALSE)
ucb.ts.600 = wilcox.test(df[df$Algorithm == "UCB" & df$Time == 600,]$Rewards, 
                         df[df$Algorithm == "Thompson Sampling" & df$Time == 600,]$Rewards, paired=TRUE, exact=FALSE)
p.adjust(c(eg.ucb.200$p.value, eg.ts.200$p.value, ucb.ts.200$p.value, 
           eg.ucb.600$p.value, eg.ts.600$p.value, ucb.ts.600$p.value), method="holm")


# End of Analysis
