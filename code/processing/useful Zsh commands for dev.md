## Useful Zsh commands for dev

Remove all non-pdf files from a folder. NB you MUST cd to the correct directory first or you risk wiping your hard drive.

```rm -- **/^*.(pdf)(.)```

count number of files in each dir

```du -a | cut -d/ -f2 | sort | uniq -c | sort -nr```