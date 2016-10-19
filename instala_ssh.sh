#!/bin/bash

#Setando variável para capturar o tipo de usuário
usuario=`id -u`
#Editando Tamanho da Barra de Menu
HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=40
BACKTITLE="Bem-vindo a Script Instala SSH - Prof - Tumelero"
TITLE="Instala SSH"
MENU="Escolha uma das opcoes:"
#criando uma regra de repetição "faça enquanto" 
while true
do
	OPTIONS=(1 "Instalar SSH"
       		 2 "Conectar na maquina do colega"
        	3 "Sair")
#Criando menu para as opçoes em Dialog
	CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" --stdout\
                )

	clear
#Criando Case para as opções a serem escolhidas
	case $CHOICE in
        	1)
#Case criado para saber se o usuario é padrão ou root
			if [ $usuario -eq 0 ]
			then
				
				apt-get update 2>&1 | tee -a /tmp/temp.txt
				nome=$( dialog --stdout --inputbox 'Digite o nome do SSH Server que voce quer instalar:' 10 60 )
				if [ -n "$nome" ]
				then
				#Instalando SSH
				#Trocando a porta para 10000
				#Reiniciando o serviço
					apg-get -y install $nome 2>&1 | tee -a /tmp/temp.txt
					sed -i "s/Port 22/Port 10000/g" /etc/ssh/sshd_config 2>&1 >> /tmp/temp.txt
					service sshd restart 2>&1 | tee -a /tmp/temp.txt
				else
					dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o IP..." 10 60
				fi
			else
				sudo apt-get update 2>&1 | tee -a /tmp/temp.txt
				nome=$( dialog --stdout --inputbox 'Digite o nome do SSH Server que voce quer instala:' 10 60 )
				if [ -n "$nome" ]
				then
				#Instalando SSH
				#Trocando a porta para 10000
				#Reiniciando o serviço
					sudo apt-get -y install $nome 2>&1 | tee -a /tmp/temp.txt
					sudo sed -i "s/Port 22/Port 10000/g" /etc/ssh/sshd_config 2>&1 >> /tmp/temp.txt
					sudo service sshd restart 2>&1 | tee -a /tmp/temp.txt
				else
					dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o nome do pacote..." 10 60	
				fi
			fi
			clear
			dialog --title 'Saida dos comandos' --textbox /tmp/temp.txt 20 60
			rm -f /tmp/temp/txt
            		;;
        	2)
		#pegando nomo da maquina do colega
			nome=$( dialog --stdout --inputbox 'Digite o nome do usuario da maquina do colega:' 10 60 )
			if [ -n "$nome" ]
			then
			#pegando ip da maquina do colega
				ip=$( dialog --stdout --inputbox 'Digite o IP da maquina do colega:' 10 60 )
				if [ -n "$ip" ]
				then
					ssh $nome@$ip
				else
					dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o IP..." 10 60
				fi
			else
				dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o nome..." 10 60
			fi
            		;;
        	3)
			break
            		;;
        	*)
			break
            		;;
	esac
done

exit 0
