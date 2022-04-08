##################################

### BUILD COUNTY-LEVEL COVID MAP ###

##################################

# This is an exploratory script for looking at different ways to map county-level Covid case rates

#### Urban tutorial - household income maps ----

# load packages
library(urbnmapr)
library(tidyverse)
library(urbnthemes)

# make simple map of U.S. states

states %>%
  ggplot(aes(long, lat, group = group)) +
  geom_polygon(fill = "grey", color = "#ffffff", size = 0.25) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)

# make simple map of U.S. counties

counties %>%
  ggplot(aes(long, lat, group = group)) +
  geom_polygon(fill = "grey", color = "#ffffff", size = 0.05) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)

# state-level homeownership rates with built-in data

statedata %>% 
  left_join(states, by = "state_name") %>% 
  ggplot(mapping = aes(long, lat, group = group, fill = horate)) +
  geom_polygon(color = "#ffffff", size = 0.25) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(fill = "Homeownership rate")

# county-level homeownership rates with built-in data

household_data <- left_join(countydata, counties, by = "county_fips") 

household_data %>%
  ggplot(aes(long, lat, group = group, fill = medhhincome)) +
  geom_polygon(color = "#ffffff", size = 0.05) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)

# focus in on one state: California

household_data %>%
  filter(state_name %in% c("California")) %>%
  ggplot(aes(long, lat, group = group, fill = medhhincome)) +
  geom_polygon(color = "#ffffff", size = 0.05) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)


# make that state map prettier with additional commands...
household_data %>%
  filter(state_name %in% c("California")) %>%
  ggplot(aes(long, lat, group = group, fill = medhhincome)) +
  geom_polygon(color = "#ffffff", size = 0.05) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradientn(labels = scales::dollar, colors = c("grey", "cornflower blue")) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_text(face = "bold", size = 11),
        legend.key.height = unit(.25, "in")) +
  labs(fill = "Median household income")



#### Activity: COVID map filtered by state ----

load("~/Documents/GitHub/ltcf_pharmacyvax/df_2022jan5.Rda")

df_2022jan5 <- df_2022jan5 %>%
  mutate(cases = cases_per_100k_7_day_count) %>%
  rename (county_fips = fips_code)


county_covid <- left_join(df_2022jan5, counties, by = "county_fips") %>% 
  rename(state_name = state_name.x)

county_covid <- county_covid %>%
  mutate(cases = as.numeric(cases_per_100k_7_day_count))
  
### NEED CODE TO REMOVE COMMAS!


county_covid %>%
  filter(state_name %in% c("Florida")) %>%
  ggplot(aes(long, lat, group = group, fill = cases)) +
  geom_polygon(color = "#ffffff", size = 0.05) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(
    low = "white",
    high = "red",
    na.value = "grey50"
  ) 




