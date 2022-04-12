# download world epidemiology huge dataset from Our World in Data 
today <- Sys.Date()
dest_dir <- "data/epidemiology/world/"
destfile <- paste0(dest_dir, "OWID_huge_table_latest.", Sys.Date(), ".csv")

if(length(grep(today, dir("data/epidemiology/world/"))) == 0){
download.file("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv", 
destfile = destfile)
  }else{
  print("OWID dataset of today is already downloaded")
}

print("deleting previous days' files...")

files_to_delete <- paste0(dest_dir, grep(pattern = paste0(today, "|.R$"), x =  dir(dest_dir), invert = TRUE, value = TRUE))
file.remove(files_to_delete)

closeAllConnections()
