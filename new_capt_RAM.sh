#! /bin/bash

set -vx 

### fx -> duracion_total 
. ../funciones.fx --source-only

URL=$1 

BASE_URL=$(echo $URL | sed 's|/[^/]*|/|5g')

playlist=`wget -qO - $URL`
file_chunk_list=`return_name_files "$playlist"`


#### Create buffer to store downloaded files  @segmentos_descargados
segmentos_descargados[];

while true
  do
    sleep $req_m3u8

    chunk_list=`wget -qO - $BASE_URL/$file_chunk_list`

######## Get the names of files to download
    segmentos_a_descargar=`return_name_files "$chunk_list"`

### DEBUG   echo  "$segmentos"

########## Getting the time in seconds to wait for the next request for a new INDEX chunks file ( M3U8 )
    dur=`duracion_total "$chunk_list"`

#### DEBUG    echo $dur

########## Setting in 2/3 of total amonunt of chunks files 
    req_m3u8=$(echo "$dur * 2/3 " | bc )

    echo $req_m3u8

############
#### Download files on the  list @segmentos_a_descargar 
####    from @BASE_URL 
####    NOT listed in @segmentos_descargados
####
    DL_from_fileList "$segmentos_a_descargar" $BASE_URL "$segmentos_descargados"
    
###   UNCOMMENT for Debugging  read -n 1 -s -r -p "Press any key to continue"
############
  done


#### solicita un nuevo chunkList despues de N segundos , siendo 
#    N igual a 2/3 del total del tiempo de la lista de reproduccion
