# Note

- il file <https://opendata.comune.palermo.it/js/server/uploads/dataset/csv/_11012018072326.csv> ha un encoding veramente bizzarro, è quindi non elaborabile, perché frictionless va in errore. È `IBM850` e si risolve con `iconv -f IBM850 -t UTF-8`
- dà problemi <https://opendata.comune.palermo.it/js/server/uploads/dataset/csv/_11012018092656.csv> che frictionless non mappa e che è `Windows-1252`
- dà problemi <https://opendata.comune.palermo.it/js/server/uploads/dataset/csv/_10012018100714.csv> che frictionless non mappa e che è `ISO-8859-1`
