#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"

  # the important part
  --disable-all

  # external libaries
  --enable-gpl            # required by x264
  # --enable-nonfree        # required by fdk-aac
  --enable-zlib           # enable zlib
  --enable-libx264        # enable x264
  # --enable-libfdk-aac     # enable libfdk-aac

  # basic requirements to process video
  --enable-protocol=file
  --enable-avcodec
  --enable-avformat
  --enable-avfilter
  --enable-swresample
  --enable-swscale

  # all components we explicitly need
  --enable-demuxer=mov # also mp4,m4a,3gp,3g2,mj2
  --enable-decoder=h264,aac
  --enable-encoder=libx264,aac
  --enable-parser=h264,aac
  --enable-muxer=mp4

  # filters, that ffmpeg might add automatically
  # insert_trim https://github.com/FFmpeg/FFmpeg/blob/45ab5307a6e8c04b4ea91b1e1ccf71ba38195f7c/fftools/ffmpeg_filter.c#L355
  --enable-filter=trim,atrim
  # configure_output_video_filter https://github.com/FFmpeg/FFmpeg/blob/45ab5307a6e8c04b4ea91b1e1ccf71ba38195f7c/fftools/ffmpeg_filter.c#L428
  --enable-filter=buffersink,scale,format,fps
  # configure_output_audio_filter https://github.com/FFmpeg/FFmpeg/blob/45ab5307a6e8c04b4ea91b1e1ccf71ba38195f7c/fftools/ffmpeg_filter.c#L522
  --enable-filter=abuffersink,aformat
  # configure_input_video_filter https://github.com/FFmpeg/FFmpeg/blob/45ab5307a6e8c04b4ea91b1e1ccf71ba38195f7c/fftools/ffmpeg_filter.c#L710
  --enable-filter=transpose,hflip,vflip
  # configure_input_audio_filter https://github.com/FFmpeg/FFmpeg/blob/45ab5307a6e8c04b4ea91b1e1ccf71ba38195f7c/fftools/ffmpeg_filter.c#L835
  --enable-filter=abuffer
  # negotiate_audio https://github.com/FFmpeg/FFmpeg/blob/41a558fea06cc0a23b8d2d0dfb03ef6a25cf5100/libavfilter/formats.c#L336
  --enable-filter=amix,aresample
)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
emconfigure ./configure "${FLAGS[@]}"
