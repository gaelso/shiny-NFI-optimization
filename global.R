



## + Libraries ----

library(shiny)
library(tidyverse)
library(terra)
library(sf)
library(showtext)

## + Add fonts ----
font_names <- c("Lora")

dir.create("fonts", showWarnings = F)

purrr::walk(font_names, function(x){
  
  ## Download and extract font
  if (!dir.exists(file.path("fonts", x))) {
    download.file(
      url = paste0("https://fonts.google.com/download?family=", x), 
      destfile = paste0("fonts/", x, ".zip"), 
      mode = "wb"
    )
    unzip(zipfile = paste0("fonts/", x, ".zip"), exdir = file.path("fonts", x))
    unlink(paste0("fonts/", x, ".zip"))
  } ## End if download font
  
}) ## End walk



## Make font easy to use

font_add("LoraIt", "fonts/Lora/static/Lora-Italic.ttf")
showtext_auto()


## + Download Avitabile 2016 biomass map ----
## Article: https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.13139
## Map: http://lucid.wur.nl/storage/downloads/high-carbon-ecosystems/Avitabile_AGB_Map.zip
dir.create("data", showWarnings = F)

check_AGB_map <- "Avitabile_AGB_Map.tif" %in% list.files("data/Avitabile_AGB_Map")

if (!check_AGB_map) {
  
  message("Downloading Avitabile et al. 2016 dataset...")
  
  time1 <- Sys.time()
  
  utils::download.file(
    url      = "http://lucid.wur.nl/storage/downloads/high-carbon-ecosystems/Avitabile_AGB_Map.zip", 
    destfile = file.path("data", "Avitabile_AGB_Map.zip")
  )
  
  utils::unzip(
    zipfile = file.path("data", "Avitabile_AGB_Map.zip"),
    exdir   = "data"
  )
  
  unlink(file.path("data", "Avitabile_AGB_Map.zip"))
  
  time2 <- Sys.time()
  dt    <- round(as.numeric(time2-time1, units = "secs"))
  message(paste0("...Done", " - ", dt, " sec."))
  
}

## + Load spatial data ----

rs_agb_init <- terra::rast("data/Avitabile_AGB_Map/Avitabile_AGB_Map.tif")
names(rs_agb_init) <- "agb_avitabile"
# summary(rs_agb_init)
# plot(rs_agb_init)
# levels(rs_agb_init)
# cats(rs_agb_init)

# rs_agb_prepa1 <- terra::crop(rs_agb_init, terra::ext(124, 128, -10, -8))
# # plot(rs_agb_prepa1)
# 
# rs_agb_prepa2 <- terra::project(rs_agb_prepa1, "EPSG:32751", method = "near")
# # plot(rs_agb_prepa2)
# 
# rs_agb_prepa3 <- mask(rs_agb_prepa2, vect(sf_country))
# # plot(rs_agb_prepa3)
# # plot(sf_country, add=T)
# 
# rs_agb <- crop(rs_agb_prepa3, rs_jica)
# # plot(rs_agb)
# # plot(sf_country, add=T)
# 
# df_agb <- terra::as.data.frame(rs_agb, xy = TRUE) %>% 
#   as_tibble() %>%
#   na.omit()
# 
# rs_jica100 <- resample(rs_jica, rs_agb)
# 
# df_jica100 <- as.data.frame(rs_jica100, xy = TRUE) %>% 
#   as_tibble() %>%
#   na.omit()

