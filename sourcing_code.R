source("functions.R")

source("landing_page.R")
data <- read.csv("20210214 - goodreads_library_export.csv", 
                 check.names = F, 
                 encoding = "UTF-8")
data <- process_data(data)

source("visualisation_page.R")
source("server.R")
source("ui.R")