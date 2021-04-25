#!/bin/bash

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

date=$(date --iso-8601)

if [ ! -f "$folder"/../source.yml ]; then
  echo "Non esiste il file sorgente"
  exit
fi

name=$(yq <"$folder"/../source.yml -r '.[].name')
URL=$(yq <"$folder"/../source.yml -r '.[].URL')
description=$(yq <"$folder"/../source.yml -r '.[].description')

mkdir -p "$folder"/../output/"$name"
mkdir -p "$folder"/../output/"$name"/rawdata
mkdir -p "$folder"/../output/"$name"/rawdata/download
mkdir -p "$folder"/../output/"$name"/processing
mkdir -p "$folder"/../output/"$name"/processing/report

# crea file metadati
echo "date=\"$date\"" >"$folder"/../output/"$name"/processing/report/meta
echo "description=\"$description\"" >>"$folder"/../output/"$name"/processing/report/meta
echo "URL=\"$URL\"" >>"$folder"/../output/"$name"/processing/report/meta

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

# estrai risorse e converti in jsonlines
xq <"$folder"/../output/"$name"/rawdata/catalogue.xml -c '.["rdf:RDF"]["rdf:Description"][]|select(.["rdf:type"][0]?["@rdf:resource"] | contains("Distribution"))' >"$folder"/../output/"$name"/rawdata/distributions.jsonl

# estrai dataset e converti in jsonlines
xq <"$folder"/../output/"$name"/rawdata/catalogue.xml -c '.["rdf:RDF"]["rdf:Description"][]|select(.["rdf:type"][0]?["@rdf:resource"] | contains("Dataset"))' >"$folder"/../output/"$name"/rawdata/dataset.jsonl

# converti in CSV le risorse che sono in CSV
mlr <"$folder"/../output/"$name"/rawdata/distributions.jsonl --j2c unsparsify then cut -x -r -f '[0-9]' then filter '${dc:format:@rdf:resource}=~"CSV"' >"$folder"/../output/"$name"/rawdata/distributionsCSV.csv

demo="no"

if [ $demo == "yes" ]; then
  mlr -I --csv head "$folder"/../output/"$name"/rawdata/distributionsCSV.csv
fi

### scarico dati ###

mlr --c2t cut -r -f 'downloadURL' then cat -n "$folder"/../output/"$name"/rawdata/distributionsCSV.csv | tail -n +2 >"$folder"/../output/"$name"/rawdata/distributionsCSV.tsv

download="no"

if [ $download == "yes" ]; then
  rm "$folder"/../output/"$name"/rawdata/download/*
  while IFS=$'\t' read -r n URL; do
    curl -kL -s -o "$folder"/../output/"$name"/rawdata/download/"$n".csv -w "%{http_code}" "$URL" >"$folder"/../output/"$name"/rawdata/download/response_"$n"
  done <"$folder"/../output/"$name"/rawdata/distributionsCSV.tsv
  # crea report http reply
  mlr --n2c cat then put '$file=FILENAME;$file=sub($file,"^.+_","")' then label httpReply,file "$folder"/../output/"$name"/rawdata/download/response_* >"$folder"/../output/"$name"/processing/httpReply.csv
  rm "$folder"/../output/"$name"/rawdata/download/response_*
fi

### scarico dati ###

# normalizza il carriage return in modalità UNIX, altrimenti si hanno questi problemi
# https://github.com/frictionlessdata/frictionless-py/issues/803#issuecomment-819445397

normalizeCR="no"

if [ $normalizeCR == "yes" ]; then
  {
    read
    while IFS=, read -r code file; do
      if echo "$code" | grep -P '^2'; then
        if dos2unix <"$folder"/../output/"$name"/rawdata/download/"$file".csv | cmp - "$folder"/../output/"$name"/rawdata/download/"$file".csv; then
          echo "ok"
        else
          dos2unix "$folder"/../output/"$name"/rawdata/download/"$file".csv
        fi
      else
        echo "non è necessario"
      fi
    done
  } <"$folder"/../output/"$name"/processing/httpReply.csv
fi

# esegui validazione

validate="yes"

if [ $validate == "yes" ]; then
  rm "$folder"/../output/"$name"/processing/validate.jsonl
  {
    read
    while IFS=, read -r code file; do
      # valida soltanto le risorse che hanno dato una risposta HTTP positiva
      if echo "$code" | grep -P '^2'; then
        frictionless validate --json "$folder"/../output/"$name"/rawdata/download/"$file".csv | jq -c '.|= .+ {file:"'"$file"'"}' >>"$folder"/../output/"$name"/processing/validate.jsonl
      else
        echo "non validare"
      fi
    done
  } <"$folder"/../output/"$name"/processing/httpReply.csv

  # estrai elenco errori

  jq <"$folder"/../output/"$name"/processing/validate.jsonl -r '.tasks[0]|if (.errors|type)=="array" then (.errors[].code + "," + .resource.path) else (.errors.code + "," + .resource.path) end' | mlr --n2c --ifs "," cat >"$folder"/../output/"$name"/processing/errors.csv

  mlr -I --csv label error,file then put -S '$file=sub($file,"^.+download/","")' then filter -x -S '$error==""' then count-distinct -f error,file "$folder"/../output/"$name"/processing/errors.csv

  jq <"$folder"/../output/"$name"/processing/validate.jsonl -r '.|[
.tasks[0].resource.encoding,.tasks[0].resource.dialect?.delimiter?,
.tasks[0].resource.stats.bytes,
.tasks[0].resource.stats.fields,
.tasks[0].resource.stats.rows,
.tasks[0].valid,
.stats.errors,
.valid,
(.errors|length),
.file
]|@csv' | mlr --csv -N --fs "," cat | mlr --n2c --ifs "," cat >"$folder"/../output/"$name"/processing/validate.csv

  mlr -I --csv label encoding,delimiter,bytes,fields,rows,valid,errors,validPackage,frictionLessError,file then put 'if($delimiter==""){$delimiter=","}else{$delimiter=$delimiter}' "$folder"/../output/"$name"/processing/validate.csv

  # versione wide report errori
  mlr --csv reshape -s error,count then unsparsify "$folder"/../output/"$name"/processing/errors.csv >"$folder"/../output/"$name"/processing/errors_wide.csv

  ### conteggio errori ###1

  # errrori totali
  # se un solo file ha 10 errori di riga vuota, conta 10

  mlr --csv stats1 -a sum -f count -g error "$folder"/../output/openDataComunePalermo/processing/errors.csv >"$folder"/../output/"$name"/processing/errorsCount.csv

  # numero di file per ogni tipo di errore
  mlr --csv count -g error,file then count -g error then sort -nr count "$folder"/../output/openDataComunePalermo/processing/errors.csv >"$folder"/../output/"$name"/processing/errorsCountFilePerTipo.csv
fi
