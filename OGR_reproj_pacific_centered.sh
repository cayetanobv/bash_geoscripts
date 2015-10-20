#!/usr/bin/env bash -x

#
#  Author: Cayetano Benavent, 2015.
#  https://github.com/GeographicaGS
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

######################################################################
# Reprojecting global vector data from Bash with ogr2ogr             #
# with a no "Greenwich centered" projection ("destroyed"             #
# geometries problem)                                                #
######################################################################

# Reprojecting Shapefile from EPSG:4326 to EPSG:3832
# http://epsg.io/3832

# This parameter is not necessary with 
# Natural Earth data...
export OGR_ENABLE_PARTIAL_REPROJECTION=TRUE

# Source layer and base folder for new data
src=/home/cayetano/Documentos/capas/NaturalEarth/10m_cultural/10m_cultural/ne_10m_admin_0_countries.shp
dst_basedir=/home/cayetano/Descargas/world_150

# New layers
dst_4326=$dst_basedir"/world_150_4326.shp"
dst_4326_tmp=$dst_basedir"/world_150_4326_tmp"
dst_3832=$dst_basedir"/world_150_3832.shp"

# Clipping source layer with EPSG:3832 maximum extension:
# first half of the world
ogr2ogr $dst_4326 $src -clipsrc -30 -85 180 85

# Clipping source layer with EPSG:3832 maximum extension: 
# second half of the world
ogr2ogr $dst_4326_tmp".shp" $src -clipsrc -180 -85 -30.0000000001 85

# Merging the world...
ogr2ogr -update -append $dst_4326 $dst_4326_tmp".shp"

# Removing temporal layers
rm $dst_4326_tmp"."*

# Reprojecting source data to EPSG:3832
ogr2ogr -t_srs EPSG:3832 $dst_3832 $dst_4326

