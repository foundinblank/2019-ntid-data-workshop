library(tidyverse)

# Internet Usage
df <- read_csv("data/originals/SYB61_T29_Internet Usage.csv",
               skip = 2,
               col_names = c("id",
                             "area",
                             "year",
                             "series",
                             "value",
                             "footnotes",
                             "source")) %>%
  mutate(value = value/100) %>%
  rename(country = area) %>%
  write_csv("data/Internet_Usage_by_Country.csv")

# Marvel Characters
df <- read_csv("data/originals/marvel_wiki_data.csv") %>%
  janitor::clean_names() %>%
  mutate(name = str_remove(name, '\\(.+\\)^'),
         name = str_remove(name, '\\\\.+\\\\"'),
         name = str_remove(name, '\\(Earth-616\\)')) %>%
  mutate(sex = str_remove(sex, "Characters"),
         sex = str_trim(sex)) %>%
  mutate(align = str_remove(align, "Characters"),
         align = str_trim(align)) %>%
  write_csv("data/Marvel_Characters.csv")

# Marvel Characters Tall
df <- read_csv("data/Marvel_Characters.csv") %>%
  group_by(year, sex) %>%
  summarise(characters = n()) %>%
  filter(!is.na(year)) %>%
  filter(!is.na(sex)) %>%
  write_csv("data/Marvel_Characters_tall.csv")

# Fingerspelling Fluency
df <- haven::read_sav("data/originals/Fingerspelling and Fluency PLoS Data Set.sav") %>%
  janitor::clean_names() %>%
  rename(id = vl2id,
         piat = raw_piatr,
         wj_reading_fluency = raw_rf_wj,
         kbit = raw_kb_matrices,
         asl_srt = raw_aslsrt,
         fingerspelling = raw_tc_fst) %>%
  select(-c(raw_b_span_man)) %>%
  write_csv("data/Stone_etal_PLoS_2015_Fingerspelling.csv")

# GoT Data (not checked into Github)
df <- readxl::read_xlsx("data/originals/GoTdata_FINAL.xlsx", sheet = 1) %>%
  mutate(sex = recode(sex, "1" = "Male",
                      "2" = "Female",
                      "9" = "Unknown/Unclear")) %>%
  mutate(social_status = recode(social_status, "1" = "Highborn",
                                "2" = "Lowborn",
                                "9" = "Unknown/Unclear/Other")) %>%
  mutate(allegiance_last = recode(allegiance_last, "1" = "Stark",
                                  "2" = "Targaryen",
                                  "3" = "Night's Watch",
                                  "4" = "Lannister",
                                  "5" = "Greyjoy",
                                  "6" = "Bolton",
                                  "7" = "Frey",
                                  "8" = "Other",
                                  "9" = "Unknown/Unclear")) %>%
  mutate(allegiance_switched = recode(allegiance_switched, "1" = "No",
                                      "2" = "Yes",
                                      "9" = "Unknown/Unclear")) %>%
  mutate(location = recode(location, "1" = "Indoors",
                           "2" = "Outdoors",
                           "9" = "Unknown/Unclear")) %>%
  mutate(continent = recode(continent, "1" = "Westeros",
                            "2" = "Essos",
                            "9" = "Unknown/Unclear")) %>%
  mutate(time_of_day = recode(time_of_day, "1" = "Day",
                              "2" = "Night",
                              "9" = "Unknown/Unclear")) %>%
  mutate(prominence_cat = recode(prominence_cat, "1" = "Low",
                                 "2" = "Medium",
                                 "3" = "High")) %>% 
  mutate(dth_flag = recode(dth_flag, "0" = "Alive",
                           "1" = "Dead")) %>%
  mutate(religion = recode(religion, "1" = "Great Stallion",
                           "2" = "Lord of Light",
                           "3" = "Faith of the Seven",
                           "4" = "Old Gods",
                           "5" = "Drowned God",
                           "6" = "Many Faced God",
                           "7" = "Great Shepard",
                           "8" = "White Walkers",
                           "9" = "Unknown",
                           "10" = "Ghiscari",
                           "11" = "None")) %>%
  mutate(occupation = recode(occupation, "1" = "Silk collar",
                             "2" = "Boiled leather collar",
                             "9" = "Unknown/unclear")) %>%
  rename(house_last = allegiance_last,
         intro_sec = intro_time_sec,
         death_season = dth_season,
         death_episode = dth_episode,
         death_sec = dth_time_sec,
         status = dth_flag,
         lifespan_season = exp_season,
         lifespan_episode = exp_episode,
         lifespan_sec = exp_time_sec) %>%
  select(-censor_time_sec, -prominence, -occupation, -COD, -COD_text, -continent,
         -place, -place_text, -time_of_day, -featured_episode_count, -diagnosis,
         -location) %>%
  select(ID, name, status, prominence_cat, everything()) %>%
  rename(prominence = prominence_cat,
        death_how = dth_description,
        diagnosis = diagnosis_text) %>%
  write_csv("data/GoT_data.csv")

# ASL-LEX
df <- read_csv("data/originals/SignData.csv") %>%
  janitor::clean_names() %>% 
  select(-x45) %>%
  write_csv("data/ASL-LEX_Sign_Data.csv")

# Tourism Data
df <- read_csv("data/originals/SYB61_T30_Tourist-Visitors Arrival and Expenditure.csv", skip = 1) %>%
  janitor::clean_names() %>%
  rename(country = x2) %>%
  filter(series == "Tourist/visitor arrivals (thousands)") %>%
  select(country, year, value) %>%
  spread(year, value) %>%
  write_csv("data/Tourism_Visitor_Arrivals.csv")
