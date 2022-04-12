library(tidyverse)

# download covid epidemiology data
####################################### ITALY AS WHOLE #################################################
cat("downloading covid epidemiology data in the whole Italy\n")
# repository/directory to download data from (italian government's github repos)
data_repos <-
  "https://github.com/pcm-dpc/COVID-19/tree/master/dati-andamento-nazionale"

# get list of files from that repository
data_repos_raw <-
  stringr::str_replace(data_repos, pattern = "tree/", replacement = "") %>%
  stringr::str_replace(pattern = "github.com", replacement = "raw.githubusercontent.com")

# generate all dates since the beginning of the directory
dates <-
  seq(as.Date("2020-02-24"), Sys.Date(), by = "days") %>% gsub(
    pattern = "-",
    replacement = "",
    x = . ,
    fixed = TRUE
  )
dates <- dates[1:(length(dates) - 1)]

# generate all csv file
csv_file_list <-
  paste("dpc-covid19-ita-andamento-nazionale-", dates, ".csv", sep = "")
# download ONLY the files we don't have locally
csv_file_list_only_missing <-
  csv_file_list[!(csv_file_list %in% dir("data/epidemiology/italy/italy_whole/raw_data/"))]
rm(csv_file_list)
# generate the list of csv URLs
csv_file_list_url <-
  paste(data_repos_raw, csv_file_list_only_missing, sep = "/")


# download only missing files
for (i in 1:length(csv_file_list_only_missing)) {
  if (length(csv_file_list_only_missing) != 0) {
    download.file(
      csv_file_list_url[i],
      destfile = paste(
        "data/epidemiology/italy/italy_whole/raw_data/",
        csv_file_list_only_missing[i],
        sep = ""
      )
    )
  }
}
rm(csv_file_list_url,
   csv_file_list_only_missing,
   data_repos_raw,
   dates)


##############################################################################################################
##################################### REGIONS OF ITALY #######################################################
# repository/directory to download data from (italian government's github repos)
data_repos <-
  "https://github.com/pcm-dpc/COVID-19/tree/master/dati-regioni/"

# get list of files from that repository
data_repos_raw <-
  stringr::str_replace(data_repos, pattern = "tree/", replacement = "") %>%
  stringr::str_replace(pattern = "github.com", replacement = "raw.githubusercontent.com")

# generate all dates since the beginning of the directory
dates <-
  seq(as.Date("2020-02-24"), Sys.Date(), by = "days") %>% gsub(
    pattern = "-",
    replacement = "",
    x = . ,
    fixed = TRUE
  )
dates <- dates[1:(length(dates) - 1)]

# generate all csv file
csv_file_list <-
  paste("dpc-covid19-ita-regioni-", dates, ".csv", sep = "")
# download ONLY the files we don't have locally
csv_file_list_only_missing <-
  csv_file_list[!csv_file_list %in% dir("data/epidemiology/italy/regions/raw_data/")]
rm(csv_file_list)
# generate the list of csv URLs
csv_file_list_url <-
  paste(data_repos_raw, csv_file_list_only_missing, sep = "")


# download only missing files
for (i in 1:length(csv_file_list_only_missing)) {
  if (length(csv_file_list_only_missing) != 0) {
    download.file(
      csv_file_list_url[i],
      destfile = paste(
        "data/epidemiology/italy/regions/raw_data/",
        csv_file_list_only_missing[i],
        sep = ""
      )
    )
    
  }
}
rm(csv_file_list_url,
   csv_file_list_only_missing,
   data_repos_raw,
   dates)
#########################################################################################################
#########################################################################################################

# dowload covid VACCINES data

# download covid VARIANTS data
