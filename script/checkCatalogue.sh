#!/bin/bash

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$folder"/../source.yml ]; then
  echo "Non esiste il file sorgente"
  exit
fi

name=$(yq <"$folder"/../source.yml -r '.[].name')
URL=$(yq <"$folder"/../source.yml -r '.[].URL')

mkdir -p "$folder"/../output/"$name"
mkdir -p "$folder"/../output/"$name"/rawdata
mkdir -p "$folder"/../output/"$name"/rawdata/download
mkdir -p "$folder"/../output/"$name"/processing

# scarica dati
if [ ! -f "$folder"/../output/"$name"/rawdata/catalogue.ttl ]; then
  curl -kL "$URL" >"$folder"/../output/"$name"/rawdata/catalogue.ttl
fi

# converti in XML
if [ ! -f "$folder"/../output/"$name"/rawdata/catalogue.xml ]; then
  cd "$folder"/../output/"$name"/rawdata

  riot -out RDF/XML ./catalogue.ttl >./catalogue.xml

  cd "$folder"
fi

# estrai risorse

xq <"$folder"/../output/"$name"/rawdata/catalogue.xml -c '.["rdf:RDF"]["rdf:Description"][]|select(.["rdf:type"][0]?["@rdf:resource"] | contains("Distribution"))' >"$folder"/../output/"$name"/rawdata/distributions.jsonl
xq <"$folder"/../output/"$name"/rawdata/catalogue.xml -c '.["rdf:RDF"]["rdf:Description"][]|select(.["rdf:type"][0]?["@rdf:resource"] | contains("Dataset"))' >"$folder"/../output/"$name"/rawdata/dataset.jsonl

# estrai CSV
mlr <"$folder"/../output/"$name"/rawdata/distributions.jsonl --j2c unsparsify then cut -x -r -f '[0-9]' then filter '${dc:format:@rdf:resource}=~"CSV"' >"$folder"/../output/"$name"/rawdata/distributionsCSV.csv

demo="yes"

if [ $demo == "yes" ]; then
  mlr -I --csv head "$folder"/../output/"$name"/rawdata/distributionsCSV.csv
fi

# scarica dati

download="no"

if [ $download == "yes" ]; then
  cd "$folder"/../output/"$name"/rawdata/download
  mlr --csv cut -r -f 'downloadURL' "$folder"/../output/"$name"/rawdata/distributionsCSV.csv | tail -n +2 | while read line; do
    wget "$line"
  done
  cd "$folder"
fi
