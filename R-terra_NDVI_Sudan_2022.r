# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
library(pals)
#
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/Sudan_NDVI")
# 1. Normalized Difference Vegetation Index (NDVI) = (NIR - R) / (NIR + R), i.e., NDVI = (Band 5 – Band 4) / (Band 5 + Band 4).
vi <- function(img, k, i) {
  bk <- img[[k]]
  bi <- img[[i]]
  vi <- (bk - bi) / (bk + bi)
  return(vi)
}
# For Landsat NIR = 5, red = 4.
filenames <- paste0('LC09_L2SP_173049_20221221_20221224_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
ndvi <- vi(landsat, 5, 4)
options(scipen=10000)
colors <- brewer.rdylgn(100)
plot(ndvi, col=colors, font.main = 1, main = "NDVI for Landsat-8 OLI/TIRS C1 image LC09_L2SP_173049_20221221_20221224_02_T1_SR_B: \nWhite Nile and Blue Nile confluence, Sudan (2022)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting the histogram of the NDVI
hist(ndvi, font.main = 1, main = "NDVI values for Landsat-8 OLI/TIRS C1 image \nLC09_L2SP_173049_20221221_20221224_02_T1_SR_B: White Nile and Blue Nile confluence, Sudan (2022)", xlab = "NDVI", ylab= "Frequency",
    col = "darkgoldenrod1", xlim = c(-0.5, 1),  breaks = 30, xaxt = "n")
axis(side=1, at = seq(-0.6, 1, 0.1), labels = seq(-0.6, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
#
