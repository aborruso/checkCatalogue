🏢 Catalogo Open Data Comune Palermo<br>
🔗 https://opendata.comune.palermo.it/dcat/dcat.php<br>
📅 2021-05-04

---

# Intro

## Check HTTP

| httpReply | count |
| --- | --- |
| 200 | 370 |
| 404 | 48 |

▶ [Report HTTP completo](./HTTPreport.csv)


## Formati delle risorse

| format | count |
| --- | --- |
| XML | 685 |
| CSV | 418 |
| ZIP | 87 |
| OP_DATPRO | 22 |
| KML | 24 |
| SHP | 1 |

## Dataset e risorse - numeri

- Numero di dataset: `1150`
- Numero di risorse: `1237`

### Conteggi di risorse per dataset

| percentile 0.25 | percentile 0.50 | percentile 0.75 | mean | min | max |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 1.077526 | 1 | 7 |

# Check

## Intro

**NOTA BENE**: questo check è stato eseguito soltanto sulle risorse in formato `CSV`,
che qui sono un totale di **418** su 1237 (il `33.79 %`).

### Forma e dimensioni

A seguire uno spaccato su:

- dimensioni in *bytes*;
- numero di righe e numero di colonne.

`p25`, `p50` e `p75` sono i percentili al 25, 50 e 75 %.

| property | min | max | mean | p25 | p50 | p75 |
| --- | --- | --- | --- | --- | --- | --- |
| bytes | 105 | 1747212 | 42028.780488 | 450 | 1202 | 3695 |
| fields | 1 | 247 | 12.720867 | 5 | 8 | 12 |
| rows | 1 | 15910 | 431.691057 | 10 | 20 | 56 |

### Encoding

Questo l'*encoding* delle risorse CSV del catalogo.

| encoding | count |
| --- | --- |
| iso8859-1 | 113 |
| utf-8 | 221 |
| cp1252 | 31 |
| iso8859-9 | 4 |

### Separatori

Questi i separatori di campo delle risorse CSV del catalogo.

| delimiter | count |
| --- | --- |
| , | 12 |
| ; | 357 |

## Riepilogo anagrafico

Nel file seguente la raccolta ordinata, per tutti i file, delle informazioni principali di ogni risorsa:

▶ [Report anagrafico](./anagrafica.csv)


## Errori

Il numero di file `CSV` che presenta almeno un errore è di **146** (il `34.93 %` del totale).

▶ [Report errori di dettaglio](./errorsReport.csv)

### Tipi di errore - totale per tipo

| error | count |
| --- | --- |
| blank-row | 3861 |
| blank-label | 951 |
| type-error | 756 |
| duplicate-label | 177 |

### Tipi di errore - numero di file per tipo

| error | count |
| --- | --- |
| blank-row | 89 |
| blank-label | 65 |
| duplicate-label | 38 |
| type-error | 20 |
