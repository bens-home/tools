You will need the following packages to read DVD's

```
sudo apt install libdvd-pkg && sudo dpkg-reconfigure libdvd-pkg
```

`libdvdcss` for encreptyed dvds (which is most of them)

I installed VLC and Handbrake packages with apt

Install Handbrake via the flatpak installer on their website
https://handbrake.fr/rotation.php?file=HandBrakeCLI-1.5.1-x86_64.flatpak


Add the flatpak bin path to your .bashrc or .zshrc
```
export PATH=$PATH:$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin
```

On ubuntu install some extras that will include a bunch of video codecs
```
sudo apt install ubuntu-restricted-extras
```

Run handbrake software
```
fr.handbrake.ghb
```

Mount /dev/sr0 to /cdrom so that you can copy any files off of it that you want to
```
sudo mount -t udf /dev/sr0 /cdrom
```

Copy the VIDEO_TS file off of the CD onto an ssd somewhere, which will make this process faster most of the time
```
cp /cdrom/VIDEO_TS/* /path/to/scratch/dir
```

Instal ffmpeg
```
sudo apt-get install ffmpeg
```

Use ffmpeg to convert the .VOB file to a good mp4
```
ffmpeg -analyzeduration 100M -probesize 100M -i /cdrom/VIDEO_TS/VTS_01_3.VOB -c:v libx264 -c:a aac -strict experimental fps=30 ./output_1_3.mp4
```

## FFMPEG
For Movies on a dvd you can concatinate all those files together, and then pass it directly to ffmpeg like this: 

```
cat VTS_01_1.VOB VTS_01_2.VOB VTS_01_3.VOB VTS_01_4.VOB VTS_01_5.VOB | ffmpeg -i - outfile.mp4
```

Sometimes the first few files are for menus or something, so check before starting as it takes a while to read off of disk.

For TV Show on dvd (like a box set or something) then normall each .VOB file is an individual episode. So you can just do 

ffmpeg -i /path/to/vob - outputfile.mp4