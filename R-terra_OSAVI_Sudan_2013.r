# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
library(pals)
#
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/Sudan_OSAVI")
# 1. Optimized Soil Adjusted Vegetation Index (OSAVI) = (NIR - R) / (NIR + R + 0.16), i.e., NDVI = (Band 5 – Band 4) / (Band 5 + Band 4).
vi <- function(img, k, i) {
  bk <- img[[k]]
  bi <- img[[i]]
  vi <- (bk - bi) / (bk + bi + 0.16)
  return(vi)
}
filenames <- paste0('LC08_L2SP_173049_20131220_20200912_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
osavi <- vi(landsat, 5, 4)
options(scipen=10000)
colors <- kovesi.diverging_rainbow_bgymr_45_85_c67(100)
plot(osavi, col=colors, font.main = 1, main = "OSAVI for Landsat-8 OLI/TIRS C1 image LC08_L2SP_173049_20131220_20200912_02_T1_SR_B: \nWhite Nile and Blue Nile confluence, Sudan (2013)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting the histogram of the OSAVI
hist(ndvi, font.main = 1, main = "OSAVI values for Landsat-8 OLI/TIRS C1 image \nLC08_L2SP_173049_20131220_20200912_02_T1_SR_B: White Nile and Blue Nile confluence, Sudan (2013)", xlab = "OSAVI", ylab= "Frequency",
    col = "dodgerblue", xlim = c(-0.5, 1),  breaks = 30, xaxt = "n")
axis(side=1, at = seq(-0.6, 1, 0.1), labels = seq(-0.6, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
