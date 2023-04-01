# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
library(pals)
#
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/Sudan_GNDVI")
# Green Normalized Difference Vegetation Index (GNDVI) = (NIR – Green) / (NIR + Green)
# Nir = Band 5, Green = Band 3.
vi <- function(img, k, i) {
  bk <- img[[k]]
  bi <- img[[i]]
  vi <- (bk - bi) / (bk + bi)
  return(vi)
}
filenames <- paste0('LC08_L2SP_173049_20181218_20200830_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
gndvi <- vi(landsat, 5, 3)
options(scipen=10000)
colors <- brewer.spectral(100)
plot(gndvi, col=colors, font.main = 1, main = "GNDVI for Landsat-8 OLI/TIRS C1 image LC08_L2SP_173049_20181218_20200830_02_T1_SR_B: \nWhite Nile and Blue Nile confluence, Sudan (2018)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting the histogram of the GNDVI
hist(gndvi, font.main = 1, main = "GNDVI values for Landsat-8 OLI/TIRS C1 image \nLC08_L2SP_173049_20181218_20200830_02_T1_SR_B: White Nile and Blue Nile confluence, Sudan (2018)", xlab = "RECI", ylab= "Frequency",
    col = "peachpuff", xlim = c(-0.5, 1),  breaks = 50, xaxt = "n")
axis(side=1, at = seq(-0.6, 1, 0.1), labels = seq(-0.6, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
