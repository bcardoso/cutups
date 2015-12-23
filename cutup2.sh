#!/bin/bash

# CUT-UP TOOLKIT
# by Bruno Cardoso
# http://navalha.org
# Copyright (C) 2008-2015.
# GNU/GPL. See LICENSE for license details


# CUT-UP TOOLKIT
# ========================
# Os scripts que compoem este toolkit foram escritos por mim para facilitar e emular o processo de recortar-e-colar textos ou fragmentos, tal como se faria com papel e tesoura.


# Modo de Usar
# ============
# 1. Torne o programa executável: chmod +x cutup2.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup2.sh TEXTO-ORIGINAL.txt
# 3. Abra o arquivo "cutup2_<data atual>.txt" para ver o resultado.


# Este arquivo: cutup2.sh
# ======================
# Cut-up simples: arruma o texto para que fique com 10 palavras por linha e depois embaralha todas as linhas.


echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0)"
echo -e "by Bruno Cardoso | bcardoso | http://navalha.org"
echo -e "GNU/GPL. See LICENSE for license details."



ARQ=alltexts.txt
CUTUP=cutup2_$(date +%F.%s).txt
TEMP=.temp_texto.txt

MAXPAL=5 #palavras por linha


#verifica os argumentos
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nO texto será cortado em diversas linhas (de $MAXPAL palavras) e depois embaralhado.\n"
	exit 1
else
	cat $@ > $ARQ
fi


########## ARRUMA ##########
j=1
k=1
for i in $(cat $ARQ) ; do
	echo -n "$i "
	if [ $j -eq $MAXPAL ] ; then
		echo
		j=0
		if [ $k -eq 12 ] ; then
			echo
			k=0
		fi
		let k++
	fi
	let j++
done | shuf > $CUTUP

rm $ARQ

echo -e "\n> cut-up criado em $CUTUP\n"
