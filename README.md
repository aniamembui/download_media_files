# download_media_files

The script is created because capture and retransmission of streaming through software such as VLC or FFMPEG ( let's say capture in some server to send media files to another  server to display de vieo in a web browser ), sooner or later, 
  these applications would hang at some point, canceling the media retransmission.


I tried to keep it as simple I could ( KISS ) , because I dont want to depend from third parties software, since high quality software also fails

It is Bash script using WGET to download and replicate streaming files indexed in M3U8 file, locally.

In order to put in a remote server, I mapped a local folder in a remote server ( using a VPN or just a SSH connection ).

The file funciones.fx stores the functions called in captureFiles.sh

captureFiles.sh SHOULD receive the URL containing the streaming INDEX files

Ej: "captureFiles.sh https://SITE/FOLDER/media_index_file.m3u8"
