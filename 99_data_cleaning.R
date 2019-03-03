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
  write_csv("data/GoT_data.csv")
