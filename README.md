# Mapping nursing homes in counties with high levels of Covid transmission

The ultimate goal of this project is to build an interactive Shiny app with a map where users can input the name of a state, then zoom in on individual counties and look at vaccination rates of nursing home residents and staff in counties that have high levels of Covid transmission. This map will pull data from the CDC API to get Covid case rates and the CMS API to get nursing home vaccination rates.


**Data Sources**




** R packages used **
+ API calls: `RSocrata`
+ Mapping: `urbanmapr`, `sf`
+ App development: `shiny`
