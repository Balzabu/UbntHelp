#!/bin/bash
#  ╦ ╦╔╗ ╔╗╔╔╦╗┬ ┬┌─┐┬  ┌─┐
#  ║ ║╠╩╗║║║ ║ ├─┤├┤ │  ├─┘
#  ╚═╝╚═╝╝╚╝ ╩ ┴ ┴└─┘┴─┘┴     by Balzabu
#                                2021


echo ".---------------------------."
echo "|          UBNThelp         |"
echo -e "'------------------------'\n"
echo -e "Per vedere le funzionalità disponibili digita 'comandi'\n"

# Funzione che mostra i comandi disponibili
comandi() {
	echo -e "\nComandi disponibili:"
	echo "diffusore_attuale"
	echo "qualita_segnale" 
	echo "factory_reset"
	echo "scansiona_station"
	echo "imposta_station"
	echo "ottieni_info"
	echo ""
}

# Funzione che mostra il diffusore(station) attualmente utilizzata dal cliente
diffusore_attuale() {
	tempstring=`iwconfig ath0 | grep 'ESSID:' | cut -f2 -d:`
	echo "Diffusore attuale: $tempstring"
}

# Funzione che mostra la potenza in dB del diffusore attualmente utilizzato
qualita_segnale(){
	tempstring=`mca-status | grep signal | cut -f2 -d=`
	echo "Potenza segnale attuale: $tempstring"
}

# Funzione che resetta l'antenna alle impostazioni di fabbrica, fare molto attenzione quando la si utilizza
factory_reset() {
	while true; do
		read -p 'Attenzione! Questa procedura è sconsigliata se si sta lavorando da remoto, vuoi continuare?(S/N) ' vuoi_continuare
		case "$vuoi_continuare" in
			s|S ) 
				echo "[INFO] Ok, ripristino in corso..."
				cp /usr/etc/system.cfg /tmp/system.cfg
				echo "[INFO] Configurazione importata, a breve il sistema sara' riavviato."
				save
				reboot
				break
				;;
			n|N )
				echo "[INFO] Ok, sto uscendo.."
				break
				;;
			* )
				echo " Scelta non valida!"
		esac
	done
}

# Fa una scansione delle station visibili dal dispositivo
scansiona_station() {
	tempstring=`iwlist ath0 scanning | grep -E 'Address|ESSID|Quality' | awk -F: 'NR%3{printf "%s ",$0;next;}1'`
	echo -e "Lista delle station visibili dall'antenna:\n"
	echo "$tempstring"
	echo ""
}


# Funzione per impostare una station diversa rispetto a quella attuale, modifica la password dell'AAA presente
# all'inizio del file /tmp/system.cfg solo se specificato poiché si presume sia già impostata correttamente
imposta_station() {
	read -p 'Nome nuova station: ' new_name
	vecchia_pass_1=`grep wpasupplicant.profile.1.network.1.psk /tmp/system.cfg | cut -f2 -d=`
	vecchia_pass_2=`grep wpasupplicant.profile.1.network.2.psk /tmp/system.cfg | cut -f2 -d=`
	echo "Password Network 1 attualmente in uso: $vecchia_pass_1"
	echo "Password Network 2 attualmente in uso: $vecchia_pass_2"
	while true; do
		read -p 'Vuoi cambiare la password utilizzata?(S/N) ' cambio_password
		case "$cambio_password" in
			s|S ) 
				read -p 'Inserisci la nuova password: ' nuova_password
				sed -i "s/^\(wpasupplicant\.profile\.1\.network\.1\.psk\s*=\s*\).*$/\1$nuova_password/" /tmp/system.cfg
				sed -i "s/^\(wpasupplicant\.profile\.1\.network\.2\.psk\s*=\s*\).*$/\1$nuova_password/" /tmp/system.cfg
				echo "[INFO] Password cambiata!"
				break
				;;
			n|N )
				echo "[INFO] Ok, proseguo..."
				break
				;;
			* )
				echo "\n Scelta non valida! \n"
				;;
		esac
	done
	sed -i "s/^\(wireless\.1\.ssid\s*=\s*\).*$/\1$new_name/" /tmp/system.cfg
	sed -i "s/^\(wpasupplicant\.profile\.1\.network\.1\.ssid\s*=\s*\).*$/\1$new_name/" /tmp/system.cfg
	sed -i "s/^\(wpasupplicant\.profile\.1\.network\.2\.ssid\s*=\s*\).*$/\1$new_name/" /tmp/system.cfg
	echo "[INFO] A breve perderai la connessione, ho modificato la configurazione..."
	echo "[INFO] Riavvio in corso..."
	save
	/usr/etc/rc.d/rc.softrestart save
}

# Ottiene le informazioni relative all'antenna dal pannello di AirControl ( Contiene gps, potenza ed altri dati utili )
ottieni_info() {
	/usr/www/status.cgi -p
}
