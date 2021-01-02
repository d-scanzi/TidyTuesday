
# packages ----------------------------------------------------------------

library(tidyverse)
library(here)
library(gganimate)
library(scales)
library(RColorBrewer)

# Data --------------------------------------------------------------------

birds <- read_csv(here("datasets", "birdoftheyear.csv"))

birds.clean <- birds %>% 
    select(-country) %>% 
    pivot_longer(cols = "vote_1":"vote_5", 
                 names_to = "rank",
                 names_prefix = "vote_",
                 values_to = "birds") %>%
    # Reversing the scoring points 
    mutate(points = max(as.integer(rank)) + 1 - as.integer(rank))

# Plotting ----------------------------------------------------------------

birds.cumulative <- birds.clean %>% 
    select(-c(rank, hour)) %>%
    # Dividing each day into a different column in order to facilitate cumulative sum of scores
    pivot_wider(names_from = date,
                values_from = points, 
                values_fn = sum) %>% 
    mutate(`2019-10-29` = `2019-10-28` + `2019-10-29`,
           `2019-10-30` = `2019-10-29` + `2019-10-30`,
           `2019-10-31` = `2019-10-30` + `2019-10-31`, 
           `2019-11-01` = `2019-10-31` + `2019-11-01`,
           `2019-11-02` = `2019-11-01` + `2019-11-02`,
           `2019-11-03` = `2019-11-02` + `2019-11-03`,
           `2019-11-04` = `2019-11-03` + `2019-11-04`,
           `2019-11-05` = `2019-11-04` + `2019-11-05`,
           `2019-11-06` = `2019-11-05` + `2019-11-06`, 
           `2019-11-07` = `2019-11-06` + `2019-11-07`, 
           `2019-11-08` = `2019-11-07` + `2019-11-08`,
           `2019-11-09` = `2019-11-08` + `2019-11-09`,
           `2019-11-10` = `2019-11-09` + `2019-11-10`) %>% 
    # restoring longer format
    pivot_longer(cols = -birds, 
                 names_to = "date", 
                 values_to = "points")

# Top five voted birds in 2019
top.five <- c("Yellow-eyed penguin",
              "Kākāpō",
              "Black Robin", 
              "Banded Dotterel",
              "Kākā")

# Plotting an increasing bar-plot of the votes for the the top five birds
birds.plot <- birds.cumulative %>% 
    filter(birds %in% top.five) %>% 
    group_by(birds) %>% 
    ggplot(aes(points, birds, fill = birds)) +
    geom_bar(stat = "identity") +
    scale_fill_brewer(type = "div", 
                      palette = "Set1") +
    # Tweaking the appearance of the plot
    theme_minimal() +
    theme(legend.position = "none",
          axis.text.y = element_text(colour = "black",
                                    size = 15),
          axis.text.x = element_text(size = 10, 
                                     angle = 90)) +
    labs(x = "Votes Count", 
         y = "", 
         title = '"Bird of the Year 2019"',
         subtitle = "Votes day-by-day") +
    xlim(0, 50000) +
    geom_text(aes(label = comma(points)),
              position = position_stack(vjust = 0.5), 
              colour = "black") +
    # Defining the animation
    transition_states(date, 
                      transition_length = 2,
                      state_length = 1) +
    ease_aes("linear")

# Setting animation specifications
animate(birds.plot, 
        width = 800,
        height = 500,
        fps = 500, 
        end_pause = 2)

# Save plot as gif
anim_save(filename = "birdsoftheyear.gif",
          animation = last_animation())

