#! /bin/sh -x

############################################################################
#
# MODULE:       osmphgarmin map build script
#
# AUTHOR(S):    Emmanuel Sambale esambale@yahoo.com emmanuel.sambale@gmail.com
#
# PURPOSE:      Shell script for creating Garmin maps from OSM data.
#               Requires mkgmap, gmapi-builder python script, nsis. 
#
#               This program is free software under the GNU General Public
#               License (>=v2).
#
#############################################################################

# Prerequisites                                                                             
# Symlink mkgmap.jar from your downloaded mkgmap.jar                                                                         
# Symlink gmapi-builder from your gmapi-builder python script                                                                 

# Set paths
download_dir=~/Downloads/osm/routable_garmin/data/
echo ${download_dir}
cd ${download_dir}

# Get latest extract from geofabrik
wget -c http://download.geofabrik.de/osm/asia/philippines.osm.bz2
bunzip2 philippines.osm.bz2
cd  ${download_dir}

# compile map with logging properties report
time java -Dlog.config=logging.properties -Xmx1512m -jar mkgmap.jar --read-config=args.list philippines.osm

mv *.img for_mapsource/
mv *.mdx for_mapsource/
mv *.tdb for_mapsource/

# gmapsupp.img generation
time java -Xmx1512m -jar mkgmap.jar --read-config=args2.list philippines.osm MINIMAL.TYP

ls -al

zip osmph_img_latest.zip gmapsupp.img
mv osmph_img_latest.zip /home/maning/Downloads/osm/routable_garmin/data/latest/

ls -al

# Mac Roadtrip installer
python gmapi-builder -t for_mapsource/40000001.tdb -b for_mapsource/40000001.img for_mapsource/*.img -s for_mapsource/MINIMAL.TYP -i for_mapsource/40000001.mdx -m for_mapsource/40000001_mdr.img

ls -al
zip -r osmph_macroadtrip_latest.zip OSM_PHIL.gmapi
mv osmph_macroadtrip_latest.zip /home/maning/Downloads/osm/routable_garmin/data/latest/
rm -rf OSM_PHIL.gmapi

cd for_mapsource

ls -al

# Win Mapsource installer
makensis osmph_mapsource_installer.nsi
mv osmph_winmapsource_latest.exe /home/maning/Downloads/osm/routable_garmin/data/latest/
rm *.img 
rm *.mdx 
rm *.tdb 

cd ..
rm *.img 
rm *.tdb
rm *.mdx
# rm philippines.osm

rm -rf OSM_PHIL.gmapi
mv mkgmap.log.0 /home/maning/Downloads/osm/routable_garmin/data/latest/mkgmap.log.0.txt
date > latest/log.txt

# Miscellaneous
# sawtooth script
cd ~/Downloads/osm/sawtooth
./sawtooth.sh

cd ~/Downloads/osm/routable_garmin/data

# archiving downloaded philippine osm file
tar -cjvf "philippines_$(date +%Y%m%d).tar.bz2" philippines.osm
mv philippines_$(date +%Y%m%d).tar.bz2 archive/philippines_$(date +%Y%m%d).tar.bz2
rm philippines.osm
