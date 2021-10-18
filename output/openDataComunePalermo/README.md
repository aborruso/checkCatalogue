# scrivere

- encoding vari, occhio non è scritto nel file
- separatori vari, occhio non è scritto nel file
- file con poche righe
- avere un report è l'occasione di correggere e riprogettare. Tutti i file "Distribuzione CSV del dataset DATI E NUMERI STATISTICI DEI SERVIZI MUSEALI DELLA GALLERIA" da una riga, vanno ad esempio convertiti in una sola risorsa con l'aggiunta della colonna anno
- nota sul p25 di righe e colonne, non sono errori, ma alert

# errori

- file di una colonna https://opendata.comune.palermo.it/js/server/uploads/dataset/csv/_10122020093938.csv
- righe di intestazione e righe di riepilogo come in  https://opendata.comune.palermo.it/js/server/uploads/dataset/csv/_11012018095133.csv

# Note

- il file <https://opendata.comune.palermo.it/js/server/uploads/dataset/csv/_11012018072326.csv> ha un encoding veramente bizzarro, è quindi non elaborabile, perché frictionless va in errore. È `IBM850` e si risolve con `iconv -f IBM850 -t UTF-8`
