#! /bin/bash


#########
#  Se agrego  " || [[ -n "$line" ]]; " 
#  por compatibilidad segun
#  
#  https://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable
#



################# Nombre de archivos #############
#
#  return_name_files "$(wget -qO - http://111.223.51.5/desktop/ch8_360p/playlist.m3u8)"
#  retorna array de strings ( usar ""), con los nombres de archivo

function return_name_files(){

while IFS='' read -r line || [[ -n "$line" ]]
do
    [[ ${line:0:1} = '#' ]] && continue
    echo $line
done <<< $1
}

################# DL from filelist  #############
##### recibe BASE_URL + el el nombre del chunk_list

function DL_from_fileList(){

# @1 chunk_list
# @2 base_URL
# @3 array con segmentos ya descargados

FILE_LIST=$1 
BASE_URL=$2

### array con los ultimos segmentos descargados
last_chunks="$3"


#####
##  Exit if the arguments != 3
#####
if [ $# != 3 ]
  then
    echo "Need the right arguments"
    exit 1
fi


  while IFS='' read -r line || [[ -n "$line" ]]
    do
	[[ ${line:0:1} = '#' ]] && continue
	if [[ ! " ${last_chunks[@]} " =~ " ${line} "  ]]   
	  then 
	    wget -q -o /dev/null $BASE_URL$line
	    echo "${last_chunks[1]}"
	    if [[ ${#last_chunks[@]} -gt 28 ]]
	       then
	        echo "Cantidad en el array ${#last_chunks[@]}"
		rm "${last_chunks[1]}"    
	        last_chunks=("${last_chunks[@]:1}")
### removidos los () antes de las ""
	     fi
	   last_chunks+=("$line")
	   echo "${last_chunks[@]}"
	fi
	
   done <<< "$FILE_LIST"
   
}

################# DURACION TOTAL #############
#### duracion_total $chunk_list
duracion_total(){
n=0;
while IFS='' read -r line || [[ -n "$line" ]]; 
  do 
    if [[ ${line:0:7} = '#EXTINF' ]] ;
      then num=${line//[^0-9 | . ]} ; 
      	#printf $num+'\n'
	n=`echo $n + $num| bc`; 
    fi ;
  done <<< "$1"

#echo $(( `echo $n / 3 | bc` )) 
### si quisiera retornar la tercerar parte del total del tiempo

echo $n
}

"$@"

