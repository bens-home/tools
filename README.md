# Tools

A generic tools repo that I can throw some common scripts, configs, or other unrelated stuff in. 

## Commands that I forget when I need them 

List what is using any bound ports on the machine
```
sudo netstat -tulpn
```

List the amount of disk space on a machine
```
df -h
```


## InstallCommonAptPackages

This will install any packages in the specified file (defaulting ot `packagesToInstall.txt`). Useful to run
on a fresh server to get all the common stuff that I use on ubuntu.
