
library(tidyverse)

coffee_raw <- read_csv(
  here::here("exam-materials", 
             "coffee_kaggle.csv")
  ) |> 
  janitor::clean_names()

coffee_clean <- coffee_raw |> 
  select(
    -c(x1,
       id,
       region, 
       producer, 
       ico_number,
       number_of_bags, 
       bag_weight, 
       in_country_partner, 
       grading_date, 
       owner, 
       variety, 
       status, 
       defects, 
       total_cup_points, 
       moisture_percentage, 
       quakers, 
       expiration, 
       certification_body, 
       certification_address, 
       certification_contact
       ), 
    country = country_of_origin, 
    farm = farm_name, 
    lot_number, 
    company, 
    year = harvest_year, 
    altitude, 
    processing_method, 
    aroma:overall, 
    category_one_defects, 
    category_two_defects, 
    color
    )

write_csv(coffee_clean, file = "coffee_clean.csv")  
