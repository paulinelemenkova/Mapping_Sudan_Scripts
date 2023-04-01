# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
library(pals)
#
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/Sudan_IPVI")
# Infrared Percentage Vegetation Index (IPVI) = NIR / (NIR + Red)
# NIR = Band 5, Red = Band 4
vi <- function(img, i, k) {
  bk <- img[[k]]
  bi <- img[[i]]
  vi <- (bk) / (bi + bk)
  return(vi)
}
filenames <- paste0('LC09_L2SP_173049_20221221_20221224_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
ipvi <- vi(landsat, 5, 4)
ipvi
options(scipen=10000)
colors <- brewer.rdylgn(100)
plot(ipvi, col=colors, font.main = 1, main = "IPVI for Landsat-8 OLI/TIRS C1 image LC09_L2SP_173049_20221221_20221224_02_T1_SR_B: \nWhite Nile and Blue Nile confluence, Sudan (2022)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting the histogram of the IPVI
hist(ipvi, font.main = 1, main = "IPVI values for Landsat-8 OLI/TIRS C1 image \nLC09_L2SP_173049_20221221_20221224_02_T1_SR_B: White Nile and Blue Nile confluence, Sudan (2022)", xlab = "IPVI", ylab= "Frequency",
    col = "yellowgreen", xlim = c(0, 1),  breaks = 50, xaxt = "n")
axis(side=1, at = seq(0.0, 1, 0.1), labels = seq(0.0, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
