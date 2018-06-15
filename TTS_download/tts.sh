#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'Usage: ' $0 ' <modid> <folder name>'
    exit 0
fi
DIR=$2_TTS
mkdir $DIR
cd $DIR
cp ../$1.json .
#curl http://gma.maurits.tv:8013/gma/download/?url=https://steamcommunity.com/sharedfiles/filedetails/?id=$1 > tmp.zip && unzip tmp.zip && rm tmp.zip && ~/program/bsontools/bson print pretty < ?orkshop?pload > $1.json
grep URL $1.json |grep -o "http.*" |sort -u|sed 's/",//g' |wget --content-disposition -i - && rm WorkshopUpload

#curl -X POST --data "itemcount=1&publishedfileids[0]="$1"&format=json" "http://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v0001/" --header "Content-Type:application/x-www-form-urlencoded" | grep file_url |grep -o "http.*" | sed 's/",//g' | wget -i - -O $1.bson && ~/program/bsontools/bson print pretty < $1.bson > $1.json && grep URL $1.json |grep -o "http.*" |sort -u|sed 's/",//g' |wget -i -
cd ..
#zip -r $DIR.zip $DIR && rm -r $DIR
