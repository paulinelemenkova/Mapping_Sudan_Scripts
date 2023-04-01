# Computing vegetation indices
library(terra)
library(RColorBrewer)
library(Hmisc)
library(pals)
#
setwd("/Users/polinalemenkova/Documents/R/52_Image_Processing/Sudan_NDWI")
# Normalized Difference Water Index (NDWI) = (NIR - SWIR1) / (NIR + SWIR1)
# NIR = Band 5, SWIR1 = Band 6
vi <- function(img, i, k) {
  bk <- img[[k]]
  bi <- img[[i]]
  vi <- (bi - bk) / (bi + bk)
  return(vi)
}
filenames <- paste0('LC08_L2SP_173049_20131220_20200912_02_T1_SR_B', 1:7, ".tif")
filenames
landsat <- rast(filenames)
landsat
ndwi <- vi(landsat, 5, 6)
options(scipen=10000)
colors <- brewer.rdylgn(100)
plot(ndwi, col=colors, font.main = 1, main = "NDWI for Landsat-8 OLI/TIRS C1 image LC08_L2SP_173049_20131220_20200912_02_T1_SR_B: \nWhite Nile and Blue Nile confluence, Sudan (2013)", cex.main=0.9)
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
# Plotting the histogram
hist(ndwi, font.main = 1, main = "NDWI values for Landsat-8 OLI/TIRS C1 image \nLC08_L2SP_173049_20131220_20200912_02_T1_SR_B: White Nile and Blue Nile confluence, Sudan (2013)", xlab = "RECI", ylab= "Frequency",
    col = "mediumpurple1", xlim = c(-0.5, 1),  breaks = 50, xaxt = "n")
axis(side=1, at = seq(-0.6, 1, 0.1), labels = seq(-0.6, 1, 0.1))
minor.tick(nx = 10, ny = 10, tick.ratio = 0.3)
