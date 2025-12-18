# Premier_League_Analysis_K_Modes_in_R

All sports leagues have sponsors. Sponsors are the backbone that keeps sports alive. Without them, leagues would lose funding, teams would scramble for talent, and fewer people would tune into match-ups (with the number decreasing season by season).

In the Premier League, 18 sponsors are publicly traded across all 20 teams and the premier league as an entity organization. The likes of these companies include American Express, Adobe, Microsoft, Puma, Nike, Adidas, etc. With many public sponsors forming decade-long partnerships (like Manchester United and Adidas for their kits/jerseys). These sponsors are all across many industries (Tech, finance, gambling/betting, sportswear, etc). There is also a large portion of private companies that have longstanding partnerships within the Premier League as well (like Arsenal and Emirates). 

With all that being said, the question we are trying to answer is: Does sponsorship value (Based on the industry you are in) indirectly/directly affect League Standing?

For this model, we partake in a K-modes clustering exploration in R (a type of unsupervised ML model for grouping categorical data via calculated distance, followed by a central cluster point for each group. In this model, we went for 3 clusters as teams can have different sponsors for kits, sleeves, and more, to find a pattern in our dataset containing sponsor information, partnerships, public vs private sector, and current league standing (as of December 17th, 2025).

The graph shows that there is no significant correlation/grouping between teams that have a "good" mix of sponsors (Finance, Tech, Tourism, etc. rated positively in our cluster) vs a "bad" mix (in this case: Sports Betting/Gambling (this category is not bad in the literal sense. It just holds a negative value for our groupings)).

While sponsorships don't necessarily predict good seasons in the Premier League, we can analyze a trend, as a lot of sponsors have:

- A large Market Cap in sectors like Tech and Finance dominating stock portfolios

- Private/government-backed organizations that usually have large cash reserves and/or capital accumulation

With the data we have, we can argue for a case of Mid-Market/ Middle ground firms/companies to invest in teams within the premier league to widen exposure and increase overall sponsor market competition going forward. There are a few companies that currently fall under this proposition like Rezzil (a VR company working with the Premier league to increase fan engagement and create simulations alongside matches) valued at around 30-40 Million GBP. 

Competition creates interest, interest leads to engagement, and engagement leads to increased earnings and fan satisfaction. There are "die-hard" Premier League football fans across the world. Why not increase exposure?! 

What do you think? Let us know!

Hope you enjoyed the Analysis!

Tech Stack: R and Claude 4.5 sonnet (Data Collection, Model layout)

# Resources 

https://www.listendata.com/2016/01/cluster-analysis-with-r.html

https://rpubs.com/saporitoangelo_2/cluster-pres

https://medium.com/learning-data/which-machine-learning-algorithm-should-i-use-for-my-analysis-962aeff11102

https://medium.com/@shailja.nitp2013/k-modesclustering-ef6d9ef06449

https://scikit-learn.org/stable/modules/clustering.html

Use of Real Stock Data (December 17th, 2025) 

Use of Claude 4.5 sonnet to learn about K-Modes clustering applications, Model Layout, debugging, etc.



