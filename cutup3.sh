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
# 1. Torne o programa executável: chmod +x cutup3.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup3.sh TEXTO-ORIGINAL.txt
# 3. Abra o arquivo "cutup3_<data atual>.txt" para ver o resultado.


# Este arquivo: cutup3.sh
# ======================
# Cut-up total: separa e embaralha TODAS as palavras do texto.


echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0)"
echo -e "by Bruno Cardoso | bcardoso | http://navalha.org"
echo -e "GNU/GPL. See LICENSE for license details."



ARQ=alltexts.txt
CUTUP=cutup3_$(date +%F.%s).txt


#verifica os argumentos
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nTODAS as palavras do texto serão recortadas, separadas e embaralhadas.\n"
	exit 1	
elif [ $# -eq 1 ] ; then
	cp -f ${1} $ARQ
else
	cat $@ > $ARQ
fi

j=1
k=1
for i in $(cat $ARQ | tr " " "\n" | shuf | tr "\n" " ") ; do
	echo -n "$i "
	if [ $j -eq 12 ] ; then
        echo
        j=0
		if [ $k -eq 12 ] ; then
			echo
			k=0
		fi
		let k++
    fi
    let j++
done > $CUTUP

rm $ARQ

echo -e "\n> cut-up criado em $CUTUP\n"
