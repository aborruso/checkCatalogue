🏢 Catalogo Open Data Comune Palermo<br>
🔗 https://opendata.comune.palermo.it/dcat/dcat.php<br>
📅 2021-04-24

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
| bytes | 105 | 1747212 | 37422.801090 | 450 | 1182 | 3656 |
| fields | 1 | 247 | 12.089918 | 5 | 8 | 12 |
| rows | 0 | 15910 | 416.828338 | 10 | 20 | 56 |

### Encoding

Questo l'*encoding* delle risorse CSV del catalogo.

| encoding | count |
| --- | --- |
| iso8859-1 | 118 |
| utf-8 | 220 |
| cp1252 | 29 |

### Separatori

Questi i separatori di campo delle risorse CSV del catalogo.

| delimiter | count |
| --- | --- |
| , | 12 |
| ; | 355 |

## Errori

Il numero di file `CSV` che presenta almeno un errore è di **149** (il `35.65 %` del totale).

▶ [Report errori di dettaglio](./errorsReport.csv)

## Tipi di errore - totale per tipo

| error | count |
| --- | --- |
| blank-row | 3861 |
| type-error | 803 |
| blank-label | 711 |
| duplicate-label | 179 |

## Tipi di errore - numero di file per tipo

| error | count |
| --- | --- |
| blank-row | 89 |
| blank-label | 64 |
| duplicate-label | 41 |
| type-error | 23 |
