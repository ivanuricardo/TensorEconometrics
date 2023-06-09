###### Preprocessing for Models
library(readxl)
library(tidyverse)
library(reshape2)
library(bootUR)
library(abind)
library(rTensor)
set.seed(20230502)

###### Constructing Data
pathname <- "~/Desktop/Projects/RESEARCH/THESIS/TensorEconometrics/data-raw/GVARDatabase(1979Q2-2019Q4)/CountryData(1979Q2-2019Q4).xls"
sheet_names <- excel_sheets(pathname)
data <- read_excel(pathname, sheet = 1)
gvar_data <- data %>% 
  mutate(country = sheet_names[1])

for (sheet in (2:(length(sheet_names)-1))) {
  appending_data <- read_excel(pathname, sheet = sheet)
  appending_data <- appending_data%>%mutate(country = sheet_names[sheet])
  new_data <- plyr::rbind.fill(gvar_data, appending_data)
  gvar_data <- new_data
}

# remove unnecessary columns and columns with NA.
sa_gvar <- subset(gvar_data, country != "SAUDI ARABIA")
sa_gvar[, c("eps", "poil", "pmetal", "pmat", "ys", "Dps")] <- list(NULL)
updated_gvar <- sa_gvar[ , colSums(is.na(sa_gvar))==0]

# Reshape data for "traditional" analysis, additionally remove the date variable
traditional_gvar <- reshape(updated_gvar, idvar = "date", timevar = "country",
                            direction = "wide")
traditional_gvar[,"date"] <- list(NULL)
traditional_data_levels <- traditional_gvar

usethis::use_data(traditional_data_levels, overwrite = TRUE)

# Convert to stationarity and remove first two observations
stat_traditional <- order_integration(traditional_gvar)
traditional_data <- stat_traditional$diff_data[3:nrow(stat_traditional$diff_data), ]
traditional_data_diff <- traditional_data

usethis::use_data(traditional_data_diff, overwrite = TRUE)

# create 3-dimensional tensor of ROW
tensor_data_diff <- traditional_data %>% 
  as.matrix(byrow = TRUE) %>% 
  array(dim = c(161, 3, 32)) %>% 
  aperm(c(1, 3, 2))

usethis::use_data(tensor_data_diff, overwrite = TRUE)
saveRDS(tensor_data_diff, "tensor_data_diff.rds")

tensor_data_levels <- traditional_data_levels %>%
  as.matrix(byrow = TRUE) %>% 
  array(dim = c(163, 3, 32)) %>% 
  aperm(c(1, 3, 2))

usethis::use_data(tensor_data_levels, overwrite = TRUE)

tensor_data <- abind(tensor_data_diff[,,1], tensor_data_levels[3:163,,2:3], along = 3)
usethis::use_data(tensor_data, overwrite = TRUE)

traditional_data <- t(unfold(as.tensor(tensor_data), row_idx = c(3,2), col_idx = 1)@data)
colnames(traditional_data) <- colnames(traditional_data_levels)
usethis::use_data(traditional_data, overwrite = TRUE)
