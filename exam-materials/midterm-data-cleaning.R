
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

## Need to Split Elevation Variable and Remove Letters from First Entry

coffee_clean <- coffee_clean |> 
  mutate(max_altitude = 
           if_else(
             str_length(altitude) > 4, 
             str_extract(altitude, pattern = "[~-]\\s*\\d+"),
             altitude
           ), 
         max_altitude = str_replace(max_altitude, 
                                    pattern = "[~-]", 
                                    replacement = ""), 
         max_altitude = str_trim(max_altitude, side = "both"), 
         min_altitude = if_else(
           str_length(altitude) > 4, 
           str_extract(altitude, pattern = "\\d+\\s*[~-]"),
           altitude
         ), 
         min_altitude = str_replace(min_altitude, 
                                    pattern = "[~-]", 
                                    replacement = ""),
         min_altitude = str_trim(min_altitude, side = "both"),
         altitude_new = if_else(
           min_altitude != max_altitude, 
           str_c(min_altitude, "-", max_altitude, sep = ""), 
           min_altitude
         ), 
         altitude_new = str_squish(altitude_new)
    ) |> 
  drop_na(max_altitude)

## Need to Filter Processing Methods to Only be the top 3-4

methods_to_keep <- tibble(processing_method = 
                            c("Natural / Dry", 
                              "Pulped natural / honey", 
                              "Washed / Wet")
                          )

coffee_clean <- coffee_clean |> 
  semi_join(methods_to_keep, by = "processing_method")

coffee_clean |> 
  select(-min_altitude, 
         -max_altitude, 
         - altitude) |>
  rename(altitude = altitude_new) |> 
  write_csv(file = "coffee_clean.csv")  
