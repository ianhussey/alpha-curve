# Alpha curve

## Notes

.pdf and .txt files scraped from pdfs are not stored on github, only .csv files containing short strings scraped from them.  



## Useful Zsh commands for dev

Remove all non-pdf files from a folder. NB you MUST cd to the correct directory first or you risk wiping your hard drive.

```rm -- **/^*.(pdf)(.)```

count number of files in each dir

```du -a | cut -d/ -f2 | sort | uniq -c | sort -nr```