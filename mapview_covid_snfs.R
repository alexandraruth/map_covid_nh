##### trying other packages

library(mapview)
library(tidyverse)
library(lubridate)
library(RSocrata)
library(sf)
library(urbnmapr)


##############################################################
# LOAD DATA
##############################################################

# load state shapefile

states <- get_urbn_map(map = "states", sf = TRUE)

# load county shapefile

counties <- get_urbn_map(map = "counties", sf = TRUE)

# load nursing home point data
load("snf_geo.Rda")


# get county-level covid data from six days ago

sixdaysago = today() - days(6) # pulls covid data from days ago using lubridate
urldate = paste("https://data.cdc.gov/resource/8396-v7yb.json?report_date=",sixdaysago,"T00:00:00.000", sep="") # creates a url for the api call with the date from two days ago
urldate # inspect url

county_covid <- read.socrata(urldate)  # pull county-level case and death data from two days ago using CDC api

county_covid <- county_covid %>%
  mutate(cases_per_100k_7_day_count = gsub(",", "", cases_per_100k_7_day_count)) %>% # removes commas from case counts
  mutate(cases = as.numeric(cases_per_100k_7_day_count)) %>%                         # creates new numeric rolling 7-day case count variable
  rename(county_fips = fips_code)  %>%
  select(county_fips, cases_per_100k_7_day_count, community_transmission_level)

rm(sixdaysago, urldate)

# MERGE: covid data into county-level shapefile 

counties <- merge(counties, county_covid, by="county_fips", all.x=T)


#######################################################
# MAP BY STATE
######################################################

# filter county-level sf features and covid data for a single state

state <- counties %>%
  filter(state_abbv=="MI") %>%
  select(county_name, community_transmission_level, geometry)

# get state-level SNF locations
state_snf <- snf_geo %>%
 filter(`Provider State` =="MI")

state_snf_sf <- st_as_sf(state_snf, coords = c("longitude", "latitude"), crs = 4326, na.fail = FALSE, agr = "constant") %>%
  select(`Provider Name`, geometry)

# map locations of SNFs & county case rates

county_lyr = mapview(state, zcol = "community_transmission_level", legend = TRUE) 
snf_lyr = mapview(state_snf_sf, legend = FALSE)

county_lyr + snf_lyr


