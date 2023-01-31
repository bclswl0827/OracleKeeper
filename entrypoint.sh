#!/bin/bash

videos="
    https://www.youtube.com/watch?v=dQw4w9WgXcQ
"

# 检查依赖项是否存在
function check_deps() {
    value=`which $1 | grep -qs $1; echo $?`
    echo $value
    return $value
}

# 下载指定 YouTube 影片
function download_video() {
    youtube-dl "$2" -f bestvideo+bestaudio --merge-output-format mp4 -o "$1"
}

# 影片转黑白
function convert_video() {
    ffmpeg -i $1 -vf fade=in:0:90 -y -f mp4 $2
}

# 影片镜像
function mirror_video() {
    ffmpeg -i $1 -vf hflip -y -f mp4 $2
}

# 影片倍速
function speed_video() {
    ffmpeg -i $1 -filter:v "setpts=0.5*PTS" -y -f mp4 $2
}

function main() {
    # 设定依赖项
    deps="youtube-dl ffmpeg"
    # 检查依赖项
    for i in $deps; do
        if [[ `check_deps $i` != 0 ]]; then
            echo "Error: $i not found"
            exit 1
        fi
    done
    while (true); do
        # 下载列表中影片
        for i in $videos; do
            # 创建缓存目录
            temp_dir=`mktemp -d`
            # 构造文件路径
            file_path="$temp_dir/`date +%s`.mp4"
            # 下载影片到缓存目录
            download_video $file_path $i
            # 转黑白，输出到 /dev/null
            convert_video $file_path /dev/null
            # # 影片镜像，输出到 /dev/null
            # mirror_video $file_path /dev/null
            # # 影片倍速，输出到 /dev/null
            # speed_video $file_path /dev/null
            # 删除缓存目录
            rm -rf $temp_dir
        done
        sleep_interval=$RANDOM
        echo "Sleep $sleep_interval seconds"
        sleep $sleep_interval
    done
}

main
