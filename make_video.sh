#!/bin/bash

# CRF values (image quality):
# 23 default
# 18-26 normal range
# 16 "perfect"

outfile="video"
input_dir="frames/video"
frames=`ls ${input_dir}/*.png | wc -l`
fps="30"
crf="18"
tstamp=`date +%Y%m%d-%H%M%S`

rm -f ${outfile}.264

ffmpeg \
    -loglevel level+error \
    -pattern_type glob \
    -i "${input_dir}/*.png" \
    -pix_fmt yuv420p \
    -strict -1 \
    -f yuv4mpegpipe - | \
x264 \
    --crf ${crf} \
    --sar 1:1 \
    --frames ${frames} \
    --output ${outfile}.264 \
    --stdin y4m -

MP4Box \
    -add "${outfile}.264#trackID=1:fps=${fps}:par=1:1:name=" \
    -tmp . \
    -new ${outfile}-${tstamp}.mp4
