variants_data <- read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/variants/covid-variants.csv")

write.csv(variants_data, file = "data/variants/variants_OWID_data.csv")

