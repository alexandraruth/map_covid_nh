######## This is a simple script that pulls recent county-level Covid data from the CDC API - this will form the base layer for a flexdashboard map app that gets updated with nursing home vaccination rates in hardest-hit counties.


### LOAD PACKAGES

library(tidyverse)
library(lubridate)
library(RSocrata)
library(urbnmapr)


### GET DATA (GLOBAL)

## get county covid data and relevant geodata for mapping

twodaysago = today() - days(2) # pulls date from two days ago using lubridate

urldate = paste("https://data.cdc.gov/resource/8396-v7yb.json?report_date=",twodaysago,"T00:00:00.000", sep="") # creates a url for the api call with the date from two days ago
urldate # inspect url

recent_covid <- read.socrata(urldate)  # pull county-level case and death data from two days ago using CDC api

recent_covid <- recent_covid %>%
  mutate(cases_per_100k_7_day_count = gsub(",", "", cases_per_100k_7_day_count)) %>% # removes commas from case counts
  mutate(cases = as.numeric(cases_per_100k_7_day_count)) %>%                         # creates new numeric rolling 7-day case count variable
  rename(county_fips = fips_code)                                                    # preps fips code for merge

county_covid <- left_join(recent_covid, counties, by = "county_fips") %>%            # merges in geodata via fips codes for mapping
  rename(state_name = state_name.x)



# get SNF-level COVID vax rates and bed counts from CMS



# merge SNF vax rates with SNF geolocation data


### MAPPING: COUNTY COVID CASE RATES by state input

county_covid %>%
  filter(state_name %in% c("Vermont")) %>%
  ggplot(aes(long, lat, group = group, fill = cases)) +
  geom_polygon(color = "#ffffff", size = 0.05) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(
    low = "white",
    high = "red",
    na.value = "grey50"
  ) 

# + labs(fill = "7-day rolling cases per 100k")


#### NOTES FEBRUARY 2/12: 

# Problems with very very small counties (Loving County TX; Mehnomen County MN) that have inflated transmission rates
# not sure how to code/handle suppressed counties...the "high/low/moderate" variable isn't very useful because almost all are "high"
# review how NYT is doing this: https://www.nytimes.com/interactive/2021/us/texas-covid-cases.html 
# review how Mayo Clinic is doing this: https://www.mayoclinic.org/coronavirus-covid-19/map/texas 

#### How-to links for mapping tasks
# https://urbaninstitute.github.io/r-at-urban/mapping.html#Spatial_Operations 
# https://stackoverflow.com/questions/63649308/convert-latitude-longitude-points-to-map-with-geom-sf

### Reactive elements:

# state 
# current date

