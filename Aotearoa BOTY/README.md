# Aotearoa Bird of The Year

This is the [week 47, year 2019](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-11-19) #TidyTueasday R project.
I decided to start from this project because since I moved to Aotearoa(New Zealand) I loved this "native birdlife" competition. To know more about it,
click [here](https://www.birdoftheyear.org.nz/). 

## Details
My goal was to create an animated bar plot representing the daily changes in votes for the five most voted birds in 2019. The dataset provided only
contained the votes for each day, but not the cumulative votes [day(n) = day1 + day2 + ... + day(n)]; the main challenge was to compute these for each of the five birds.
Furthermore, New Zealand Bird of the Year is voting system is based on an *instant runoff voting system* in which voters have to rank up to 5 birds. From their page:

*Voting is based on an instant runoff voting (IRV) system, which is similar to the system we use in local elections. 
When you vote, you can rank up to five of your favourite birds, with #1 indicating your favourite bird, #2 indicating your second favourite bird, and so on. 
It’s no problem if you want to vote for less than five birds.*

Points are then assigned accordance with the ranking. I assumed that the number of points assigned ranged from 1 to 5, with an inverse relationship between ranking
and point system. That is: 5 points to first bird, 4 points to second birds, etc... Fof each voter I converted ranking to points, eliminating NAs. In fact voters can 
list less than five birds.

The animation was created using the package [`{gganimate}`](https://gganimate.com/).

