# multi-armed-bandits
Ninth: Multi-armed Bandit Algorithms

##### Reward

A quantitative measure of success. In business, the ultimate rewards are profits, but we can often treat simpler metrics like click-through rates for ads or sign-up rates for new users as rewards. What matters is that (A) there is a clear quantitative scale and (B) it’s better to have more reward than less reward.

##### Arm

What options are available to us? What actions can we take? Here, we’ll refer to the options available to us as arms.

##### Bandit

A bandit is a collection of arms. When you have many options available to you, we call that collection of options a Multiarmed Bandit. A Multiarmed Bandit is a mathematical model you can use to reason about how to make decisions when you have many actions you can take and imperfect information about the rewards you would receive after taking those actions. We refer to the problem of choosing arms to pull as the Multiarmed Bandit Problem.

##### Play/Trial

When you deal with a bandit, it’s assumed that you get to pull on each arm multiple times. Each chance you have to pull on an arm will be called a play or, more often, a trial. The term "play" helps to invoke the notion of gambling that inspires the term "arm", but the term trial is quite commonly used.

##### Horizon

How many trials will you have before the game is finished? The number of trials left is called the horizon. If the horizon is short, you will often use a different strategy than you would use if the horizon were long, because having many chances to play each arm means that you can take greater risks while still having time to recover if anything goes wrong.

##### Exploitation

An algorithm for solving the Multiarmed Bandit Problem exploits if it plays the arm with the highest estimated value based on previous plays.

##### Exploration

An algorithm for solving the Multiarmed Bandit Problem explores if it plays any arm that does not have the highest estimated value based on previous plays. In other words, exploration occurs whenever exploitation does not.

##### Explore/Exploit Dilemma

The observation that any learning system must strike a compromise between its impulse to explore and its impulse to exploit. The dilemma has no exact solution, but the algorithms described here provide useful strategies for resolving the conflicting goals of exploration and exploitation.

##### Annealing

An algorithm for solving the Multiarmed Bandit Problem anneals if it explores less over time.

##### Temperature

A parameter that can be adjusted to increase the amount of exploration in the Softmax algorithm for solving the Multiarmed Bandit Problem. If you decrease the temperature parameter over time, this causes the algorithm to anneal.

#####  Streaming Algorithms

An algorithm is a streaming algorithm if it can process data one piece at a time. This is the opposite of batch processing algorithms that need access to all of the data in order to do anything with it.

##### Online Learning

An algorithm is an online learning algorithm if it can not only process data one piece at a time, but can also provide provisional results of its analysis after each piece of data is seen.

##### Active Learning

An algorithm is an active learning algorithm if it can decide which pieces of data it wants to see next in order to learn most effectively. Most traditional machine learning algorithm are not active: they passively accept the data we feed them and do not tell us what data we should collect next.

##### Bernoulli

A Bernoulli system outputs a 1 with probability p and a 0 with probability 1 – p.
