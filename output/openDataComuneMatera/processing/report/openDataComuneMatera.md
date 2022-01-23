🏢 Catalogo Open Data Comune Matera<br>
🔗 http://dati.comune.matera.it/catalog.ttl<br>
📅 2021-10-17

---

# Intro

## Check HTTP

| httpReply | count |
| --- | --- |
| 200 | 101 |
| 404 | 14 |
| 410 | 5 |

▶ [Report HTTP completo](./HTTPreport.csv)


## Formati delle risorse

| format | count |
| --- | --- |
| JSON | 14 |
| CSV | 120 |
| XLSX | 82 |
| ZIP | 22 |
| GEOJSON | 20 |
| PDF | 8 |
| KML | 15 |
| ARC | 3 |
| XML | 2 |
| HTML | 4 |
| XLS | 1 |
| ODT | 1 |
| TIFF | 1 |

## Dataset e risorse - numeri

- Numero di dataset: `100`
- Numero di risorse: `293`

### Conteggi di risorse per dataset

| percentile 0.25 | percentile 0.50 | percentile 0.75 | mean | min | max |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 1.028070 | 1 | 9 |

# Check

## Intro

**NOTA BENE**: questo check è stato eseguito soltanto sulle risorse in formato `CSV`,
che qui sono un totale di **120** su 293 (il `40.96 %`).

### Forma e dimensioni

A seguire uno spaccato su:

- dimensioni in *bytes*;
- numero di righe e numero di colonne.

`p25`, `p50` e `p75` sono i percentili al 25, 50 e 75 %.

| property | min | max | mean | p25 | p50 | p75 |
| --- | --- | --- | --- | --- | --- | --- |
| bytes | 145 | 1051319 | 27245.158416 | 671 | 2548 | 7385 |
| fields | 1 | 135 | 13.079208 | 5 | 7 | 13 |
| rows | 0 | 4626 | 206.900990 | 12 | 26 | 87 |

### Encoding

Questo l'*encoding* delle risorse CSV del catalogo.

| encoding | count |
| --- | --- |
| iso8859-1 | 52 |
| utf-8 | 348 |
| cp1252 | 4 |

### Separatori

Questi i separatori di campo delle risorse CSV del catalogo.

| delimiter | count |
| --- | --- |
| , | 404 |

## Riepilogo anagrafico

Nel file seguente la raccolta ordinata, per tutti i file, delle informazioni principali di ogni risorsa:

▶ [Report anagrafico](./anagrafica.csv)


## Errori

Il numero di file `CSV` che presenta almeno un errore è di **20** (il `16.67 %` del totale).

▶ [Report errori di dettaglio](./errorsReport.csv)

### Tipi di errore - totale per tipo

| error | count |
| --- | --- |
| blank-row | 924 |
| extra-cell | 676 |
| duplicate-label | 192 |
| type-error | 120 |
| blank-label | 52 |

### Tipi di errore - numero di file per tipo

| error | count |
| --- | --- |
| type-error | 11 |
| blank-label | 7 |
| blank-row | 2 |
| duplicate-label | 1 |
| extra-cell | 1 |
