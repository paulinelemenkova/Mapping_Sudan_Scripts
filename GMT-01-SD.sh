#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO 15 arc sec global data set (here: Sudan)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

exec bash

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,0,dimgray \
    FONT_LABEL=7p,0,dimgray \
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Extract a subset of ETOPO1m for the study area
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R20/40/8/24.5 -Gsd1_relief.nc
gmt grdcut GEBCO_2019.nc -R20/40/8/24.5 -Gsd_relief.nc
gdalinfo -stats sd1_relief.nc
# actual_range={-2756,4326}

# Make color palette
gmt makecpt -Cgeo -V -T-2756/3042 > pauline.cpt

#####################################################################
# create mask of vector layer from the DCW of country's polygon
gmt pscoast -R20/40/8/24.5 -JT30/6.5i -Dh -M -ESD > Sudan.txt
#####################################################################

ps=Topo_SD.ps
# Make background transparent image

gmt grdimage sd_relief.nc -Cpauline.cpt -R20/40/8/24.5 -JT30/6.5i -I+a15+ne0.75 -t40 -Xc -P -K > $ps

# Add isolines
gmt grdcontour sd1_relief.nc -R -J -C250 -A500+f7p,26,darkbrown -Wthinnest,darkbrown -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J \
    -Ia/thinner,blue -Na -N1/thicker,tomato -W0.1p -Df -O -K >> $ps
    
#####################################################################
# CLIPPING
# 1. Start: clip the map by mask to only include country

gmt psclip -R20/40/8/24.5 -JT30/6.5i Sudan.txt -O -K >> $ps

# 2. create map within mask
# Add raster image
gmt grdimage sd_relief.nc -Cpauline.cpt -R20/40/8/24.5 -JT30/6.5i -I+a15+ne0.75 -Xc -P -O -K >> $ps
# Add isolines
gmt grdcontour sd1_relief.nc -R -J -C250 -A500+f7p,26,darkbrown -Wthinnest,darkbrown -O -K >> $ps
# Add coastlines, borders, rivers
gmt pscoast -R -J \
    -Ia/thinner,blue -Na -N1/thicker,tomato -W0.1p -Df -O -K >> $ps

# 3: Undo the clipping
gmt psclip -C -O -K >> $ps
#####################################################################
    
# Add color legend
gmt psscale -Dg19.5/6.5+w16.5c/0.15i+h+o0.3/0i+ml+e -R -J -Cpauline.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg500f100a500+l"Colormap: 'earth' Colors for global topography relief [R=-2756/3042, H, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    --MAP_TITLE_OFFSET=0.7c \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --FONT_LABEL=8p,25,black \
    --FONT_TITLE=13p,0,black \
        -Bpxg4f1a2 -Bpyg4f2a2 -Bsxg2 -Bsyg2 \
    -B+t"Topographic map of Sudan" -O -K >> $ps
    
# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=9p,0,black \
    --FONT_ANNOT_PRIMARY=9p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx13.0c/-2.4c+c10+w500k+l"Transverse Mercator prj; central meridian=30\232E. Scale (km)"+f \
    -UBL/0p/-70p -O -K >> $ps

# Cities -R20/40/8/24.5
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
30.38 15.68 Omdurman
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
32.48 15.65 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
25.03 11.70 Nyala
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
24.88 12.05 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,blue1+jLB >> $ps << EOF
37.35 19.65 Port
37.35 19.25 Sudan
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
37.22 19.62 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
30.37 13.10 El-Obeid
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
30.22 13.18 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
35.35 15.60 Kassala
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
36.4 15.45 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
29.35 21.57 Wadi Halfa
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
31.37 21.78 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
34.25 13.50 El-Gadarif
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
35.38 14.03 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
25.50 13.45 Al-Fashir
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
25.35 13.62 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
26.05 14.37 Umm Badr
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
27.69 14.25 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
30.47 19.32 Dongola
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
30.47 19.17 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
32.05 18.40 Karima
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
31.85 18.55 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
33.33 19.68 Abu Hamad
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
33.33 19.53 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
28.25 10.66 Kaduqli
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
29.72 11.01 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,21,ivory1+jLB >> $ps << EOF
33.20 11.43 Ad-Damazin
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
34.35 11.76 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,ivory1+jLB >> $ps << EOF
32.50 17.68 Atbara
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
33.97 17.68 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,22,yellow+jLB >> $ps << EOF
32.75 15.45 Khartoum
EOF
gmt psxy -R -J -Sa -W0.5p -Gred -O -K << EOF >> $ps
32.55 15.5 0.35c
EOF
#------ countries
gmt pstext -R -J -N -O -K \
-F+jTL+f18p,19,black+jLB -Gwhite@80 >> $ps << EOF
27.0 16.5 S  U  D  A  N
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
28.2 22.8 E   G   Y   P   T
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
22.5 20.8 L I B Y A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
20.3 16.3 C H A D
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,19,gray25+jLB >> $ps << EOF
21.1 9.2 CENTRAL
21.1 8.7 AFRICAN
21.1 8.2 REPUBLIC
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB >> $ps << EOF
26.5 8.5 S O U T H   S U D A N
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB -Gwhite@50 >> $ps << EOF
36.2 11.2 E T H I O P I A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,19,gray25+jLB -Gwhite@50 >> $ps << EOF
37.0 15.5 ERITREA
EOF
# water
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue1+jLB+a-65 >> $ps << EOF
30.5 19.0 Nile
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue2+jLB+a-60 >> $ps << EOF
35.0 17.2 Atbara
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue1+jLB+a20 >> $ps << EOF
32.8 16.6 Nile
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue2+jLB+a-65 >> $ps << EOF
33.25 15.3 Blue Nile
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue2+jLB+a-65 >> $ps << EOF
32.2 14.6 White Nile
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue2+jLB -Gwhite@60 >> $ps << EOF
37.2 21.5 Red Sea
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blue2+jLB+a65 >> $ps << EOF
28.0 13.9 Wadi
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blue2+jLB+a83 >> $ps << EOF
28.5 14.8 Al-Malik
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue2+jLB >> $ps << EOF
26.8 9.9 Bahr
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,23,blue2+jLB+a-25 >> $ps << EOF
27.8 9.9 al-Arab
EOF
# GEOGRAPHY
gmt pstext -R -J -N -O -K \
-F+f12p,20,lightgoldenrod2+jLB >> $ps << EOF
24.5 19.2 LIBYAN
24.5 18.5 DESERT
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,20,darkred+jLB -Gkhaki@50 >> $ps << EOF
32.5 21.3 NUBIAN
32.5 20.8 DESERT
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,20,white+jLB >> $ps << EOF
26.1 20.3 S    A    H    A    R    A
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,21,darkred+jLB >> $ps << EOF
27.8 19.6 Jebel
27.8 19.1 Abyad
27.8 18.6 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,0,floralwhite+jLB+a45 >> $ps << EOF
23.7 12.5 Marrah Mts.
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,floralwhite+jLB >> $ps << EOF
25.0 15.6 Teiga
25.0 15.1 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,0,floralwhite+jLB >> $ps << EOF
29.5 11.5 Nuba Mts.
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,floralwhite+jLB >> $ps << EOF
30.2 11.0 Moro Hills
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,21,white+jLB+a-80 >> $ps << EOF
36.2 21.5 Red Sea Hills
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,20,white+jLB >> $ps << EOF
24.8 12.4 S    A    H    E    L
EOF
#
# Nile cataractes
gmt pstext -R -J -N -O -K \
-F+f10p,23,blueviolet+jLB -Glightgoldenrod@50 >> $ps << EOF
32.48 23.60 1st Cataract
EOF
gmt psxy -R -J -S- -W0.8p,deeppink -O -K << EOF >> $ps
32.88 24.08 0.45c
EOF
gmt psxy -R -J -Sx -W0.8p,deeppink -O -K << EOF >> $ps
32.88 24.08 0.45c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blueviolet+jLB -Glightgoldenrod@50 >> $ps << EOF
28.55 21.25 2nd Cataract
EOF
gmt psxy -R -J -S- -W1.0p,deeppink -O -K << EOF >> $ps
30.97 21.48 0.45c
EOF
gmt psxy -R -J -Sx -W1.0p,deeppink -O -K << EOF >> $ps
30.97 21.48 0.45c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blueviolet+jLB -Glightgoldenrod@50 >> $ps << EOF
30.57 19.76 3rd Cataract
EOF
gmt psxy -R -J -S- -W1.0p,deeppink -Gslateblue1 -O -K << EOF >> $ps
30.37 19.76 0.45c
EOF
gmt psxy -R -J -Sx -W1.0p,deeppink -O -K << EOF >> $ps
30.37 19.76 0.45c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blueviolet+jLB -Glightgoldenrod@50 >> $ps << EOF
32.56 18.91 4th Cataract
EOF
gmt psxy -R -J -Sx -W1.0p,deeppink -O -K << EOF >> $ps
32.36 18.91 0.45c
EOF
gmt psxy -R -J -S- -W1.0p,deeppink -O -K << EOF >> $ps
32.36 18.91 0.45c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blueviolet+jLB -Glightgoldenrod@50>> $ps << EOF
34.12 17.70 5th Cataract
EOF
gmt psxy -R -J -S- -W1.0p,deeppink -O -K << EOF >> $ps
33.97 17.68 0.45c
EOF
gmt psxy -R -J -Sx -W1.0p,deeppink -O -K << EOF >> $ps
33.97 17.68 0.45c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blueviolet+jLB -Glightgoldenrod@50 >> $ps << EOF
32.85 16.29 6th Cataract
EOF
gmt psxy -R -J -S- -W1.0p,deeppink -O -K << EOF >> $ps
32.67 16.29 0.45c
EOF
gmt psxy -R -J -Sx -W1.0p,deeppink -O -K << EOF >> $ps
32.67 16.29 0.45c
EOF
# insert map
gmt psbasemap -R -J -O -K -DjTL+w3.0c+stmp >> $ps
read x0 y0 w h < tmp
gmt pscoast --MAP_GRID_PEN_PRIMARY=thin,grey -Rg -JG28.0/8.0N/$w -Da -Glightgoldenrod1 -A5000 -Bga -Wfaint -ESD+gred -Sdodgerblue -O -K -X$x0 -Y$y0 >> $ps
gmt psxy -R -J -O -K -T  -X-${x0} -Y-${y0} >> $ps

# Add GMT logo
gmt logo -Dx6.5/-3.1+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y7.6c -N -O \
    -F+f10p,0,black+jLB >> $ps << EOF
3.0 10.4 Digital elevation data: SRTM/GEBCO, 15 arc sec resolution grid
EOF

# Convert to image file using GhostScript
gmt psconvert Topo_SD.ps -A1.5c -E720 -Tj -Z
