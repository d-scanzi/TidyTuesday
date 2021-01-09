
# Loading packages --------------------------------------------------------
install.packages("countrycode")
install.packages("gghighlight")

library(tidyverse)
library(here)
library(janitor)
library(countrycode)
library(gghighlight)



# importing data ----------------------------------------------------------

costs <- read_csv("mergedcosts.csv")


# Tidy up dataset ---------------------------------------------------------

costs.tidy <- costs %>% 
    janitor::clean_names() %>% 
    select(-c("e", 
              "rr", 
              "reference")) %>% 
    
    # Translating country codes into country names
    mutate(country.name = countrycode(sourcevar = country, 
                                      origin = "iso2c",
                                      destination = "country.name",
                                      custom_match = c("UK" = "United Kingdom")))


# Operations and plotting -------------------------------------------------

# Median of USD/Km 
mdn.to.display <- median(costs.tidy$cost_km_millions, na.rm = TRUE)

mdn.km.display <- median(costs.tidy$length, na.rm =  TRUE)



# Country costs
costs.country <- costs.tidy %>% 
    group_by(country.name) %>% 
    
    # Computing sum and median cost/km for each country
    summarise(tot.cost = sum(cost_km_millions, na.rm = TRUE),
              mdn.cost = median(cost_km_millions, na.rm = TRUE),
              mdn.km = median(length, na.rm = TRUE)) %>% 
    drop_na() %>% 
    ungroup()


# Selecting Countries in which the median price is higher than grand median
# and median km built is lower than grand median for km
country.expensive <- costs.country %>% 
    filter(mdn.cost > mdn.to.display & mdn.km < mdn.km.display)
    

country.cheap <- costs.country %>% 
    filter(mdn.cost < mdn.to.display & mdn.km > mdn.km.display)


#Plotting
costs.country %>% ggplot(aes(mdn.cost, reorder(country.name, mdn.km))) +
    geom_point(size = 3, 
               colour = "#C6C5B9") +
    
    # Highlighting expensive countries
    geom_point(data = country.expensive, 
               aes(mdn.cost, country.name), 
               size = 3,
               shape = 21,
               fill = "#C6C5B9", 
               colour = "#F2545B",
               stroke = 1.3) +
    
    # Highlighting cheap countries
    geom_point(data = country.cheap, 
               aes(mdn.cost, country.name), 
               size = 3,
               shape = 21,
               fill = "#C6C5B9",
               colour = "#2BA84A",
               stroke = 1.3) +
    
    # Adding lines for cheap countries
    geom_hline(yintercept = country.cheap$country.name, 
               linetype = "dashed",
               colour = "#2BA84A", 
               size = 0.5) +
    
    # Adding lines for expensive countries
    geom_hline(yintercept = country.expensive$country.name, 
               linetype = "dotdash",
               colour = "#F2545B") +
    
    
# Adding grand median line
    geom_vline(xintercept = mdn.to.display, 
               linetype = "solid",
               colour = "#393424", 
               size = 1.3) +
    geom_text(aes(x = 175, y = 4, label = "World"), 
              angle = 90,
              size = 3) + 
    geom_text(aes(x = 190, y = 4, label = "Median"), 
                                    angle = 90,
                                    size = 3) +
    
    # General plot aesthetics
    theme(
          # Set Background colour
          plot.background = element_rect(fill = "#006E90"),
          panel.background = element_rect(fill = "#006E90"),
          
          #Removing grids
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          #Set text colour
          axis.text = element_text(colour = "Black", 
                                   size = 11),
          axis.text.x = element_text(angle = 90)) +
    
    # Fixing breaks and adding titles
    scale_x_continuous(breaks = seq(100,900,50)) +
    labs(x = "Median Cost per Km(USD)",
         y = "",
         title = "Transit Infrastructure Costs by Country")
    
    
