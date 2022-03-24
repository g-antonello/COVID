library(tidyverse)

covid_data_raw <-
  list.files(pattern = "*.csv",
             path = "data/epidemiology/italy/italy_whole/raw_data/",
             full.names = TRUE) %>%
  map_df( ~ data.table::fread(.)) %>%
  mutate(data = as.Date(data))

covid_data_italy_whole <- covid_data_raw %>%
  mutate(n_giorno_da_inizio_pandemia = 1:nrow(.)) %>%
  mutate(deceduti_nuovi = c(7, diff(deceduti))) %>%
  mutate(anno = factor(lubridate::year(data))) %>%
  mutate(mese = lubridate::month(data, label = TRUE, abbr = FALSE)) %>%
  mutate(giorno = factor(lubridate::day(data))) %>%
  mutate(stagione = date_to_Season(data)) %>%
  mutate(settimana = as.Date(cut(data, "weeks"))) %>% 
  mutate(giorno_settimana = weekdays(data)) %>% 
  dplyr::rename(totale_positivi_attualmente = totale_positivi,
         nuovi_deceduti = deceduti_nuovi) 
  


# genera variabile "nuovi tamponi"
covid_data_italy_whole$tamponi_nuovi <- c(covid_data_italy_whole$tamponi[1], diff(covid_data_italy_whole$tamponi))

# genera variabile "nuovi_guariti"
covid_data_italy_whole$dimessi_guariti_nuovi <- c(covid_data_italy_whole$dimessi_guariti[1], diff(covid_data_italy_whole$dimessi_guariti))

covid_data_italy_whole <- mutate(covid_data_italy_whole,
       totale_terapia_intensiva = c(0, diff(ingressi_terapia_intensiva)),
       n_settimana = lubridate::week(data),
       tasso_tamponi_pos_percent = nuovi_positivi/tamponi_nuovi*100)

# write the final file
write.csv(covid_data_italy_whole, "data/epidemiology/italy/italy_whole/covid_ITALY_data_clean.csv")
cat("Italy file saved in the following Dropbox location:\n")
cat(
  "/data/epidemiology/italy/italy_whole/covid_ITALY_data_clean.csv"
)
