#!/bin/bash

#lsta de colores
#Colours
 esc="" # si esto no funciona probar "^[" que es ctrl+v+ESC
 
    negro="${esc}[30m"
    rojo="${esc}[31m"
    verde="${esc}[32m"
    amarillo="${esc}[33m"
    azul="${esc}[34m"
    rosa="${esc}[35m"
    cyan="${esc}[36m"
    blanco="${esc}[37m"
 
    f_negro="${esc}[40m"
    f_rojo="${esc}[41m"
    f_verde="${esc}[42m"
    f_amarllo="${esc}[43m"
    f_azul="${esc}[44m"
    f_rosa="${esc}[45m"
    f_cyan="${esc}[46m"
    f_blanco="${esc}[47m"
 
    negrita="${esc}[1m"
    q_negrita="${esc}[22m"
    italica="${esc}[3m"
    q_italica="${esc}[23m"
    subrayado="${esc}[4m"
    q_subrayado="${esc}[24m"
    inverso="${esc}[7m"
    q_inverso="${esc}[27m"
 
    reset="${esc}[0m"

#variablesd de rutas y ficheros
#prueba= "$(cat netplanconfig | sed "s/IP/$1/" |sed "s/nombreint/$2/")"


#funciones 
function ctrl_c ()
{
	exit 1
}
function banner(){
echo -e "${rojo} ___    __ __    __  ____          __  ____     ___   ____  ______    ___ "
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
echo -e "|_____||__|__|\____||__|        \____||__|\_||_____||__|__|  |__|  |_____|${reset}" 
echo -e "${cyan} Creado por Fran Moreno:${reset}"                                                                                                                                                  
}
function Actualizar()
{
	apt update -y;
	apt upgrade -y;
}
function helpPanel()
{
	tput civis; 
	echo -e "${blanco}[-p]${reset}${rosa} Descarga el paquete isc-dhcp-server necesario para la instalacion:${reset}"
    echo -e "${blanco}[-t]${reset}${amarillo} Seleccionar tarea:${reset}"
    	echo -e "${blanco}$negrita\t##[ FixeIP ]## ${reset} ${verde}$italica ** Fija la IP del servidor/cliente **${reset}"
    	
    tput cnorm; exit 1
}

function descargaISC(){
	echo -e "${verde}Actualizano el sitemas${reset}";
	apt update -y;
	apt upgrade -y;
	echo -e "${verde}Descargando el paquete${reset}";
	apt install isc-dhcp-server -y;
	echo -e "${rosa}Paquete isc-dhcp-server descargados ${reset}";
}
function FijarIPInterface(){
	listainterfaces=$(ip a|grep -i broadcast | awk '{print $2}'|tr -d ':')

	echo -e "$rosa Asistencia de fijacion IP fija,vamos realizarle uns serie de preguntas para la configuracion de ip.$reset\n $rojoIMPORTANTE NO ESCRIBIR MAL LOS DATOS ESTO PUEDE OCASIONAR ERRORES EN LA CONFIGURACION$reset"
	echo -e "Nombre de la interfa a fijar: Disponibles--> $verde$negrita$listainterfaces$reset" 

	#ruta="/etc/netplan/0*"
	#cat netplanconfig | sed "s/IP/$1/" |sed "s/nombreint/$2/" > $ruta 
	#netplan apply

}
function configurarDHCP(){


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
#echo -e "${verde} Actualizando el sistema ...${reset}";
#Actualizar;
#helpPanel;
#echo -e "${verde} Actualizacion finalizada vamos al turron ${reset}";



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
		#echo -e "${redColour}!!!!!Error en la sistaxis del comando!!!!!\t${reset}${verde}##### revise el panel de ayuda #####${reset}"
		#helpPanel
	fi	
fi

