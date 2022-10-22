#!/bin/bash

#lsta de colores
#Colours
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
endColour="\033[0m\e[0m"

#variablesd de rutas y ficheros
#prueba= "$(cat netplanconfig | sed "s/IP/$1/" |sed "s/nombreint/$2/")"


#funciones 
function ctrl_c ()
{
	exit 1
}
function banner(){
echo -e "${redColour} ___    __ __    __  ____          __  ____     ___   ____  ______    ___ "
sleep 0.08
echo -e "|   \  |  |  |  /  ]|    \        /  ]|    \   /  _] /    ||      |  /  _]"
sleep 0.08
echo -e "|    \ |  |  | /  / |  o  )      /  / |  D  ) /  [_ |  o  ||      | /  [_"
sleep 0.08
echo -e "|  D  ||  _  |/  /  |   _/      /  /  |    / |    _]|     ||_|  |_||    _] "
sleep 0.08
echo -e "|     ||  |  /   \_ |  |       /   \_ |    \ |   [_ |  _  |  |  |  |   [_  "
sleep 0.08
echo -e "|     ||  |  \     ||  |       \     ||  .  \|     ||  |  |  |  |  |     |"
sleep 0.08
echo -e "|_____||__|__|\____||__|        \____||__|\_||_____||__|__|  |__|  |_____|${endColour}" 
echo -e "${blueColour} Creado por Fran Moreno:${endColour}"                                                                                                                                                  
}
function Actualizar()
{
	apt update -y;
	apt upgrade -y;
}
function helpPanel()
{
	tput civis; 
	echo -e "${grayColour}[-p]${endColour}${turquoiseColour} Descarga el paquete isc-dhcp-server necesario para la instalacion:${endColour}"
    echo -e "${grayColour}[-t]${endColour}${yellowColour} Seleccionar tarea:${endColour}"
    	echo -e "${grayColour}\t [fixedip]${endColour} ${greenColour}Fijar IP servidor/cliente:  ${endColour}"
    	
    tput cnorm; exit 1
}

function descargaISC(){
	echo -e "${greenColour}Actualizano el sitemas${endColour}";
	apt update -y;
	apt upgrade -y;
	echo -e "${greenColour}Descargando el paquete${endColour}";
	apt install isc-dhcp-server -y;
	echo -e "${purpleColour}Paquete isc-dhcp-server descargados ${endColour}";
}
function FijarIPInterface(){
	ip=$1
	nombreInterface=$2
	
	ruta="/etc/netplan/0*"
	cat netplanconfig | sed "s/IP/$1/" |sed "s/nombreint/$2/" > $ruta 
	netplan apply

}
function configurarDHCP(){
 ipoption=$1 
 name=$2  
 maskoption=$3  
 routeroption=$4  
 tmediooption=$5 
 dominiooption=$6 
 Rangeoption=$7  
 DNSoption=$8  
 Tmaximooption=$9 

 if [[ name ]]; then
 	#statements
 	cat default-isc | grep -C 11 INTERFACESv4| sed "s/\"\"/\"$name\"/" > /etc/default/isc-dhcp-server
 else
 	echo "no hay nombre"
 fi
 
	cat dhcp-isc | grep 'IPSUBNET' |tr -d '#' | sed "s/IPSUBNET/$ipoption/" | sed "s/IPMASCARA/$maskoption/" > tmpisc.txt
	if [[ $Rangeoption ]]; then
		cat dhcp-isc | grep 'IPRANGO' |tr -d '#' | sed "s/IPRANGO/$Rangeoption/"  >> tmpisc.txt
	fi
	

	cat tmpisc.txt

 #cat dhcp-isc | grep -A 11 "A slight"| while read -r line;
 #do 
 #if [[ $line  == "subnet" ]]; then
	#statements
 
 # done;

#primero conficuramos el fichero default


}

trap ctrl_c INT


####flujo del programa####
banner;
#echo -e "${greenColour} Actualizando el sistema ...${endColour}";
#Actualizar;
#helpPanel;
#echo -e "${greenColour} Actualizacion finalizada vamos al turron ${endColour}";



#MAIN PROGRAM
#dependencies; 
parameter_counter=0
while getopts "pt:h" arg; do
    case $arg in
    p)	let parameter_counter+=10;;	
	t)	option=$OPTARG && let parameter_counter+=1;;
	h) helpPanel;;
    esac
done

if [ $parameter_counter -eq 0 ]; then
	helpPanel
else
	if [ $parameter_counter -eq 10 ]; then
		#statements
		descargaISC
		exit 0
	fi
	if [ "$(echo $option)" == "FixeIP" ] && [ $parameter_counter -eq 1 ]; then
		FijarIPInterface
	elif [ "$(echo $option)" == "DHCPConfig" ] && [ $parameter_counter -eq 1 ]; then
		#echo "$nameoption"
		configurarDHCP	
	else
		echo "fallo DHCP_Config"
		#echo -e "${redColour}!!!!!Error en la sistaxis del comando!!!!!\t${endColour}${greenColour}##### revise el panel de ayuda #####${endColour}"
		#helpPanel
	fi	
fi

