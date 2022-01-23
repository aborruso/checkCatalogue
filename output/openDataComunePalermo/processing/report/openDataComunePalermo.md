🏢 Catalogo Open Data Comune Palermo<br>
🔗 https://opendata.comune.palermo.it/dcat/dcat.php<br>
📅 2022-01-23

---

# Intro

## Check HTTP

| httpReply | count |
| --- | --- |
| 200 | 379 |
| 404 | 45 |

▶ [Report HTTP completo](./HTTPreport.csv)


## Formati delle risorse

| format | count |
| --- | --- |
| XML | 694 |
| CSV | 424 |
| ZIP | 105 |
| OP_DATPRO | 22 |
| KML | 24 |
| SHP | 1 |

## Dataset e risorse - numeri

- Numero di dataset: `1187`
- Numero di risorse: `1270`

### Conteggi di risorse per dataset

| percentile 0.25 | percentile 0.50 | percentile 0.75 | mean | min | max |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 1.071730 | 1 | 7 |

# Check

## Intro

**NOTA BENE**: questo check è stato eseguito soltanto sulle risorse in formato `CSV`,
che qui sono un totale di **424** su 1270 (il `33.39 %`).

### Forma e dimensioni

A seguire uno spaccato su:

- dimensioni in *bytes*;
- numero di righe e numero di colonne.

`p25`, `p50` e `p75` sono i percentili al 25, 50 e 75 %.

| property | min | max | mean | p25 | p50 | p75 |
| --- | --- | --- | --- | --- | --- | --- |
| bytes | 105 | 1747212 | 36087.300792 | 451 | 1228 | 3735 |
| fields | 1 | 131 | 12.686016 | 5 | 9 | 13 |
| rows | 1 | 15910 | 427.633245 | 10 | 20 | 56 |

### Encoding

Questo l'*encoding* delle risorse CSV del catalogo.

| encoding | count |
| --- | --- |
| iso8859-1 | 118 |
| utf-8 | 227 |
| cp1252 | 30 |
| iso8859-9 | 4 |

### Separatori

Questi i separatori di campo delle risorse CSV del catalogo.

| delimiter | count |
| --- | --- |
| , | 12 |
| ; | 367 |

## Riepilogo anagrafico

Nel file seguente la raccolta ordinata, per tutti i file, delle informazioni principali di ogni risorsa:

▶ [Report anagrafico](./anagrafica.csv)


## Errori

Il numero di file `CSV` che presenta almeno un errore è di **145** (il `34.20 %` del totale).

▶ [Report errori di dettaglio](./errorsReport.csv)

### Tipi di errore - totale per tipo

| error | count |
| --- | --- |
| blank-row | 3105 |
| blank-label | 470 |
| duplicate-label | 177 |
| type-error | 50 |

### Tipi di errore - numero di file per tipo

| error | count |
| --- | --- |
| blank-row | 89 |
| blank-label | 63 |
| duplicate-label | 38 |
| type-error | 21 |
