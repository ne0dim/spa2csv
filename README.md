# spa2csv
Simple converter for Thermo Fisher Scientific spectrum binary format *.SPA.
To use this app just provide it with SPA file as an argument like so:

```bash
ruby spa2csv spectrum.spa
```
It will create plain text file containing your data in text format 
named like this: `spectrum.spa.csv` with comma as a delimeter.
Hope it will be useful for someone.
