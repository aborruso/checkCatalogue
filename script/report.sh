#!/bin/bash

set -x
set -e
set -u
set -o pipefail

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
mkdir -p "$folder"/../output/"$name"/processing/report

source "$folder"/../output/"$name"/processing/report/meta

### http reply ###

# titolo sezione
cat <<- EOF > "$folder"/../output/"$name"/processing/report/"$name".md
📅 $date

---

## Check HTTP

EOF

# aggiungi riepilogo
mlr --c2m count-distinct -f httpReply "$folder"/../output/openDataComunePalermo/processing/httpReply.csv >>"$folder"/../output/"$name"/processing/report/"$name".md

# aggiungi link a file dettagli

mlr --n2c --ifs '\t' label id,downloadURL  "$folder"/../output/openDataComunePalermo/rawdata/distributionsCSV.tsv >"$folder"/../output/"$name"/rawdata/tmp.csv

mlr --csv join --ul -j "dcat:downloadURL:@rdf:resource" -l "dcat:downloadURL:@rdf:resource" -r downloadURL -f "$folder"/../output/openDataComunePalermo/rawdata/distributionsCSV.csv then unsparsify then reorder -f id "$folder"/../output/openDataComunePalermo/rawdata/tmp.csv >"$folder"/../output/"$name"/processing/report/HTTPreport.csv

mlr --csv join --ul -j id -l id -r file -f "$folder"/../output/openDataComunePalermo/processing/report/HTTPreport.csv then unsparsify then sort -n id "$folder"/../output/openDataComunePalermo/processing/httpReply.csv | sponge "$folder"/../output/openDataComunePalermo/processing/report/HTTPreport.csv

# titolo sezione
cat <<- EOF >> "$folder"/../output/"$name"/processing/report/"$name".md

▶ [Report HTTP completo](./HTTPreport.csv)

EOF

### http reply ###

