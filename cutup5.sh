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
# 1. Torne o programa executável: chmod +x cutup5.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup5.sh TEXTO-ORIGINAL.txt
# 3. Abra o arquivo "cutup5_<data atual>.txt" para ver o resultado.


# Este arquivo: cutup5.sh
# ======================
# Separa todas as FRASES do texto, com base em sinais de pontuação, e as embaralha.


echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0)"
echo -e "by Bruno Cardoso | bcardoso | http://navalha.org"
echo -e "GNU/GPL. See LICENSE for license details."


ARQ=alltexts.txt
CUTUP=cutup5_$(date +%F.%s).txt
TEMP=.temp_texto.txt


#verifica os argumentos
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nTodas as FRASES serão cortadas e depois embaralhado.\n"
	exit 1
elif [ $# -eq 1 ] ; then
	cp -f ${1} $ARQ
else
	cat $@ > $ARQ
fi


#insere quebra de linha após cada sinal de pontuação (.,;?!:-()[] e ou) para separar as frases & embaralha
cat $ARQ |
sed -e 's/\./\.\n/g;s/,/,\n/g;s/;/;\n/g;s/?/?\n/g;s/\!/\!\n/g;s/:/:\n/g;s/ -/\n/g;s/- /\n/g;s/(/\n/g;s/)/\n/g;s/\[/\n/g;s/\]/\n/g;s/ e / e\n/g;s/ ou / ou\n/g' | grep -v ^"\(;\|,\|.\)"$ | shuf | sed -e 'N;s/\n/ /' | tr -s " " | sed -e 's/^ //' > $CUTUP

rm $ARQ

echo -e "\n> cut-up criado em $CUTUP\n"
