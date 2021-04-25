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
cat <<-EOF >"$folder"/../output/"$name"/processing/report/"$name".md
🏢 $description<br>
🔗 $URL<br>
📅 $date

---

# Intro

## Check HTTP

EOF

# aggiungi riepilogo
mlr --c2m count-distinct -f httpReply "$folder"/../output/"$name"/processing/httpReply.csv >>"$folder"/../output/"$name"/processing/report/"$name".md

# aggiungi link a file dettagli

mlr --n2c --ifs '\t' label id,downloadURL "$folder"/../output/"$name"/rawdata/distributionsCSV.tsv >"$folder"/../output/"$name"/rawdata/tmp.csv

mlr --csv join --ul -j "dcat:downloadURL:@rdf:resource" -l "dcat:downloadURL:@rdf:resource" -r downloadURL -f "$folder"/../output/"$name"/rawdata/distributionsCSV.csv then unsparsify then reorder -f id "$folder"/../output/"$name"/rawdata/tmp.csv >"$folder"/../output/"$name"/processing/report/HTTPreport.csv

mlr --csv join --ul -j id -l id -r file -f "$folder"/../output/"$name"/processing/report/HTTPreport.csv then unsparsify then sort -n id "$folder"/../output/"$name"/processing/httpReply.csv | sponge "$folder"/../output/"$name"/processing/report/HTTPreport.csv

mlr -I --csv reorder -f id,httpReply "$folder"/../output/"$name"/processing/report/HTTPreport.csv

# titolo sezione
cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

▶ [Report HTTP completo](./HTTPreport.csv)

EOF

### http reply ###

### tipo di risorse ###

# titolo sezione
cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

## Formati delle risorse

EOF

mlr <"$folder"/../output/"$name"/rawdata/distributions.jsonl --json unsparsify then \
  cut -x -r -f '[0-9]' then \
  rename -r '.*format.*,format' then \
  put '$format=sub($format,"^.+/","")' then \
  count-distinct -f format >"$folder"/../output/"$name"/processing/distributionsFormat.json

mlr <"$folder"/../output/"$name"/processing/distributionsFormat.json --j2m cat >>"$folder"/../output/"$name"/processing/report/"$name".md

### tipo di risorse ###

### risorse per dataset ###

numeroDataset=$(wc <"$folder"/../output/"$name"/rawdata/dataset.jsonl -l)
numeroRisorse=$(wc <"$folder"/../output/"$name"/rawdata/distributions.jsonl -l)
numeroCSV=$(mlr --j2n filter '$format=="CSV"' then cut -f count "$folder"/../output/"$name"/processing/distributionsFormat.json)
numeroFileErrore=$(mlr --c2n count -n -g file "$folder"/../output/"$name"/processing/errors.csv)

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

## Dataset e risorse - numeri

- Numero di dataset: \`$numeroDataset\`
- Numero di risorse: \`$numeroRisorse\`

### Conteggi di risorse per dataset

EOF

mlr <"$folder"/../output/"$name"/rawdata/distributions.jsonl --j2m unsparsify then cut -x -r -f '[0-9]' then rename -r '.*accessURL.*,accessURL' then count-distinct -f accessURL then cut -f count then stats1 -a p25,p50,p75,mean,min,max -f count then rename -r '.+p,percentile 0.' then rename -r '.*count_,' >>"$folder"/../output/"$name"/processing/report/"$name".md
### risorse per dataset ###

### errori ###

mlr --csv join --ul -j "dcat:downloadURL:@rdf:resource" -l "dcat:downloadURL:@rdf:resource" -r downloadURL -f "$folder"/../output/"$name"/rawdata/distributionsCSV.csv then unsparsify then reorder -f id then put -S '$id=$id.".csv"' "$folder"/../output/"$name"/rawdata/tmp.csv >"$folder"/../output/"$name"/processing/report/errorsReport.csv

mlr --csv join --ul -j id -l id -r file -f "$folder"/../output/"$name"/processing/report/errorsReport.csv then unsparsify "$folder"/../output/"$name"/processing/errors_wide.csv | sponge "$folder"/../output/"$name"/processing/report/errorsReport.csv

mlr -I --csv put -S '$id=sub($id,"\..+","")' then sort -n id "$folder"/../output/"$name"/processing/report/errorsReport.csv

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

# Check

## Intro

**NOTA BENE**: questo check è stato eseguito soltanto sulle risorse in formato \`CSV\`,
che qui sono un totale di **$numeroCSV** su $numeroRisorse (il \`$(awk "BEGIN {printf \"%.2f\n\", $numeroCSV / $numeroRisorse*100}") %\`).

### Forma e dimensioni

A seguire uno spaccato su:

- dimensioni in *bytes*;
- numero di righe e numero di colonne.

\`p25\`, \`p50\` e \`p75\` sono i percentili al 25, 50 e 75 %.

EOF

mlr --c2m filter -x -S '$encoding==""' then cut  -f bytes,fields,rows then stats1 -a min,max,mean,p25,p50,p75 -f bytes,fields,rows then reshape -r  '_' -o item,value then nest --explode --values --across-fields -f item --nested-fs "_" then reshape -s item_2,value then rename item_1,property ../output/"$name"/processing/validate.csv >>"$folder"/../output/"$name"/processing/report/"$name".md

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

### Encoding

Questo l'*encoding* delle risorse CSV del catalogo.

EOF

mlr --c2m filter -x -S '$encoding==""' then count-distinct -f encoding "$folder"/../output/"$name"/processing/validate.csv >>"$folder"/../output/"$name"/processing/report/"$name".md

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

### Separatori

Questi i separatori di campo delle risorse CSV del catalogo.

EOF

mlr --c2m filter -x -S '$encoding==""' then count-distinct -f delimiter "$folder"/../output/"$name"/processing/validate.csv >>"$folder"/../output/"$name"/processing/report/"$name".md

### anagrafica di base

mlr --csv join --ul -j file -l file -r id -f "$folder"/../output/"$name"/processing/validate.csv then unsparsify  "$folder"/../output/"$name"/rawdata/tmp.csv >"$folder"/../output/"$name"/rawdata/tmp_validate.csv

mlr --csv join --ul -j downloadURL -l downloadURL -r "dcat:downloadURL:@rdf:resource" -f "$folder"/../output/"$name"/rawdata/tmp_validate.csv then unsparsify then reorder -e -f downloadURL "$folder"/../output/"$name"/rawdata/distributionsCSV.csv >"$folder"/../output/"$name"/processing/report/anagrafica.csv

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

## Riepilogo anagrafico

Nel file seguente la raccolta ordinata, per tutti i file, delle informazioni principali di ogni risorsa:

▶ [Report anagrafico](./anagrafica.csv)

EOF

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

## Errori

Il numero di file \`CSV\` che presenta almeno un errore è di **$numeroFileErrore** (il \`$(awk "BEGIN {printf \"%.2f\n\", $numeroFileErrore / $numeroCSV*100}") %\` del totale).

▶ [Report errori di dettaglio](./errorsReport.csv)

### Tipi di errore - totale per tipo

EOF

mlr --c2m sort -nr count_sum then label error,count "$folder"/../output/"$name"/processing/errorsCount.csv >>"$folder"/../output/"$name"/processing/report/"$name".md

cat <<-EOF >>"$folder"/../output/"$name"/processing/report/"$name".md

### Tipi di errore - numero di file per tipo

EOF

mlr --c2m cat "$folder"/../output/"$name"/processing/errorsCountFilePerTipo.csv >>"$folder"/../output/"$name"/processing/report/"$name".md
