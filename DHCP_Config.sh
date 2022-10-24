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
    	echo -e "\t\t${redColour}Parametro obligado: ${endColour}${blueColour}"
    	echo -e "\t\t[-i] --> Numero de IP a fijar separada por puntos${endColour}${yellowColour} [ejemplo: 192.168.1.100]${endColour}"
    	echo -e "${blueColour}\t\t[-n] --> Nombre de la INTERFACESv4 del equipo${endColour}${yellowColour} [ejemplo: enp0s4]${endColour}"
    	echo -e "${grayColour}\t [DHCP_Config]${endColour} ${greenColour}Configurar servicio DHCP:  ${endColour}"
    	echo -e "${blueColour}\t\t${redColour}Parametro obligado: ${endColour}${blueColour}"
    	echo -e "${blueColour}\t\t[-i] --> Numero de IP de la subnet separada por puntos${endColour}${yellowColour} [ejemplo: 192.168.1.0]${endColour}"
    	echo -e "${blueColour}\t\t[-m] --> Numero de mascara de la subnet separada por puntos${endColour}${yellowColour} [ejemplo: 255.255.255.0]${endColour}"
    	echo -e "${blueColour}\t\t[-n] --> Nombre de la INTERFACESv4 del equipo${endColour}${yellowColour} [ejemplo: enp0s4]${endColour}"
    	echo -e "\t\t${purpleColour}Parametro opcionales: ${endColour}${blueColour}"
    	echo -e "\t\t[-R] --> Rango de IP inicio y fin separadas por espacio${endColour}${yellowColour} [ejemplo: 192.168.1.10 192.168.1.50]${endColour}"
    	echo -e "${blueColour}\t\t[-D] --> DNS que quieras asignar puedes poner tantas como quieras pero separadas por espacio${endColour}${yellowColour} [ejemplo: 8.8.8.8 8.8.4.4]${endColour}"
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
while getopts "pt:i:n:m:r:t:d:R:D:T:h" arg; do
    case $arg in
    p)	let parameter_counter+=10;;	
	t)	option=$OPTARG && let parameter_counter+=1;;
	i)	ipoption=$OPTARG && let parameter_counter+=1;;
	n)	nameoption=$OPTARG && let parameter_counter+=1;;
	m)	maskoption=$OPTARG && let parameter_counter+=1;;
	r)	routeroption=$OPTARG && let parameter_counter+=1;;
	t)	tmediooption=$OPTARG && let parameter_counter+=1;;
	d)	dominiooption=$OPTARG && let parameter_counter+=1;;
	R)	Rangeoption=$OPTARG && let parameter_counter+=1;;
	D)	DNSoption=$OPTARG && let parameter_counter+=1;;
	T)	Tmaximooption=$OPTARG && let parameter_counter+=1;;
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
	if [ "$(echo $option)" == "fixedip" ] && [ $parameter_counter -eq 3 ]; then
		FijarIPInterface $ipoption $nameoption
	elif [ "$(echo $option)" == "DHCP_Config" ] && [ $parameter_counter -ge 1 ]; then
		#echo "$nameoption"
		configurarDHCP "$ipoption" "$nameoption" "$maskoption" "$routeroption" "$tmediooption" "$dominiooption" "$Rangeoption" "$DNSoption" "$Tmaximooption"	
	else
		echo "fallo DHCP_Config"
		#echo -e "${redColour}!!!!!Error en la sistaxis del comando!!!!!\t${endColour}${greenColour}##### revise el panel de ayuda #####${endColour}"
		#helpPanel
	fi	
fi

