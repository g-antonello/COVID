library(tidyverse)
source("../personal_R_functions/my_personal_functions.R")
######## WRANGLE REGION DATA ############
# load raw data
covid_data_raw <-
  list.files(pattern = "*.csv",
             path = "data/epidemiology/italy/regions/raw_data/",
             full.names = TRUE) %>%
  map_df( ~ data.table::fread(.)) %>%
  mutate(data = as.Date(data))
colnames(covid_data_raw)[4] <- "Regione"

# load region demographics data
region_demographics <-
  readxl::read_xlsx(
    "data/epidemiology/italy/regions/raw_data/region_demographics/abitanti per regione_inizio_2020.xlsx"
  )

### merge the two ###
covid_data_raw_with_regions <-
  merge(
    covid_data_raw,
    region_demographics,
    all.x = TRUE,
    by = "Regione",
    sort = FALSE
  )



colname_map_df <-
  data.frame(
    oldnames = colnames(covid_data_raw_with_regions),
    newnames = c(
      "region",
      "date",
      "country",
      "region_code",
      "lat",
      "long",
      "hospitalized_with_symptoms",
      "hospitalized_intensive_care_all",
      "hospitalized_total",
      "home_isolation",
      "positives_tot",
      "positive_tot_variation",
      "positives_new",
      "hospitalized_recovered",
      "deaths",
      "cases_suspected_by_diagnosis",
      "cases_from_screening",
      "cases_total",
      "tests",
      "tests_n_tested",
      "notes",
      "hospitalized_intensive_care_new",
      "tests_notes",
      "cases_notes",
      "test_molec_positives",
      "test_quick_positives",
      "test_molec_n_tests",
      "test_quick_n_tests",
      "nuts_code_1",
      "nuts_code_2",
      "region_inhabitants",
      "region_surface",
      "region_pop_density",
      "region_n_municipalities",
      "region_n_provinces"
    )
  )

correct_order <-
  c(
    "country",
    "date",
    "region",
    "region_code",
    "lat",
    "long",
    "cases_total",
    "cases_suspected_by_diagnosis",
    "cases_from_screening",
    "positives_tot",
    "positive_tot_variation",
    "positives_new",
    "home_isolation",
    "hospitalized_total",
    "hospitalized_with_symptoms",
    "hospitalized_intensive_care_all",
    "hospitalized_intensive_care_new",
    "hospitalized_recovered",
    "deaths",
    "tests",
    "tests_n_tested",
    "test_molec_n_tests",
    "test_quick_n_tests",
    "notes",
    "tests_notes",
    "cases_notes",
    "test_molec_positives",
    "test_quick_positives",
    "nuts_code_1",
    "nuts_code_2",
    "region_inhabitants",
    "region_surface",
    "region_pop_density",
    "region_n_municipalities",
    "region_n_provinces"
  )

colname_map_df_reorder <-
  colname_map_df[match(correct_order, colname_map_df$newnames), ]

covid_data_raw_with_regions <-
  tibble(covid_data_raw_with_regions)[, colname_map_df_reorder$oldnames]

colnames(covid_data_raw_with_regions) <-
  colname_map_df_reorder$newnames

covid_data_raw_with_regions <-
  select(covid_data_raw_with_regions,-country)


tmp_list <-
  split(covid_data_raw_with_regions, f = covid_data_raw_with_regions$region)
tmp_list_deaths_new <-
  lapply(tmp_list, function(x)
    base::transform(x, deaths_new = c(0, diff(deaths))))

covid_data_deaths_new <- do.call(rbind, tmp_list_deaths_new) %>%
  mutate(year = factor(lubridate::year(date))) %>%
  mutate(month = lubridate::month(date, label = TRUE, abbr = FALSE)) %>%
  mutate(day = factor(lubridate::day(date)))

tmp_date_day_map <-
  data.frame(
    date = unique(covid_data_deaths_new$date),
    day_since_pandemic_began = 1:length(unique(covid_data_deaths_new$date))
  ) %>%
  mutate(week_since_pandemic_began = bin_integer_into_integer(day_since_pandemic_began, multiples = 7))

covid_data_deaths_new <-
  merge(covid_data_deaths_new,
        tmp_date_day_map,
        by = "date",
        sort = FALSE)


correct_order_2 <-
  c(
    "date",
    "year",
    "month",
    "day",
    "day_since_pandemic_began",
    "week_since_pandemic_began",
    "region",
    "region_code",
    "lat",
    "long",
    "cases_total",
    "cases_suspected_by_diagnosis",
    "cases_from_screening",
    "positives_tot",
    "positive_tot_variation",
    "positives_new",
    "home_isolation",
    "hospitalized_total",
    "hospitalized_with_symptoms",
    "hospitalized_intensive_care_all",
    "hospitalized_intensive_care_new",
    "hospitalized_recovered",
    "deaths",
    "deaths_new",
    "tests",
    "tests_n_tested",
    "test_molec_n_tests",
    "test_quick_n_tests",
    "notes",
    "tests_notes",
    "cases_notes",
    "test_molec_positives",
    "test_quick_positives",
    "nuts_code_1",
    "nuts_code_2",
    "region_inhabitants",
    "region_surface",
    "region_pop_density",
    "region_n_municipalities",
    "region_n_provinces"
  )

covid_data_clean <- covid_data_deaths_new[, correct_order_2]
rownames(covid_data_clean) <- NULL

rm(
  correct_order,
  colname_map_df,
  colname_map_df_reorder,
  covid_data_raw,
  region_demographics,
  covid_data_deaths_new,
  covid_data_raw_with_regions
)


write.csv(
  covid_data_clean,
  "data/epidemiology/italy/regions/covid_REGIONS_data_clean.csv"
)
cat("Region file saved in the following location:\n")
cat(
  "/home/ubiminor/Dropbox/COVID data analysis/data/epidemiology/covid_data_regions/covid_REGIONS_data_clean.csv"
)

