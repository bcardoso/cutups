#!/bin/bash

# CUT-UP TOOLKIT
# by Bruno Cardoso
# http://navalha.org
# Copyright (C) 2008-2012.
# GNU/GPL. See LICENSE for license details


# CUT-UP TOOLKIT
# ========================
# Os scripts que compoem este toolkit foram escritos por mim para facilitar e emular o processo de recortar-e-colar textos ou fragmentos, tal como se faria com papel e tesoura.


# Modo de Usar
# ============
# 1. Torne o programa executável: chmod +x cutup4.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup4.sh TEXTO-ORIGINAL.txt
# 3. Abra o arquivo "cutup4_<data atual>.txt" para ver o resultado.


# Este arquivo: cutup4.sh
# ======================
# Separa e embaralha somentes os parágrafos do texto (interpretados assim pela sequência \n\n).


echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0)"
echo -e "by Bruno Cardoso | bcardoso | http://navalha.org"
echo -e "GNU/GPL. See LICENSE for license details."



ARQ=alltexts.txt
CUTUP=cutup4_$(date +%F.%s).txt

#verifica os argumentos
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nTodas os PARÁGRAFOS do(s) texto(s) serão embaralhados.\n"
	exit 1	
elif [ $# -eq 1 ] ; then
	cp -f ${1} $ARQ
else
	cat $@ > $ARQ
fi

cat $ARQ | grep -v ^20[0-9][0-9]- | grep -v "bcardoso" |
tr  "\n" "+" | sed -e 's/++/\n/g;s/+$/\n/g' | shuf | sed -e 's/$/\n/g' | tr "+" "\n" > $CUTUP

rm $ARQ

echo -e "\n> cut-up criado em $CUTUP\n"
