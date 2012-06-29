#!/bin/bash

# CUT-UP/BRICOLEUR TOOLKIT
# by Bruno Cardoso
# http://navalha.org
# Copyright (C) 2008-2012.
# GNU/GPL. See LICENSE for license details


# CUT-UP/BRICOLEUR TOOLKIT
# ========================
# Os scripts que compoem este toolkit foram escritos por mim para facilitar e emular o processo de recortar-e-colar textos ou fragmentos, tal como se faria com papel e tesoura.


# Modo de Usar
# ============
# 1. Torne o programa executável: chmod +x cutup1.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup1.sh TEXTO-ORIGINAL.txt
# 3. Abra o arquivo "cutup1_<data atual>.txt" para ver o resultado.


# Este aquivo: CUTUP1.SH
# ======================
# Este cut-up separa o texto em quatro quadrantes por página e os embaralha.
# Exemplo:
#            1 2  ->   2 4
#            3 4  ->   1 3


echo -e "\n$(tput bold)CUT-UP/BRICOLEUR TOOLKIT$(tput sgr0)"
echo -e "by Bruno Cardoso | bcardoso | http://navalha.org"
echo -e "GNU/GPL. See LICENSE for license details."


ARQ=alltexts.txt
CUTUP=cutup1_$(date +%F.%s).txt
TEMP=.temp.txt

#dimensoes de cada quadrante
MAXLIN=12 #numero de linhas (de 40 caracteres)


#verifica os argumentos
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\n\nO texto será divido em quadrantes (de $MAXLIN linhas x 40 caracteres) e depois embaralhado. Se o texto for menor que o esperado (1920 caracteres ~uma lauda), ele não será recortado na horizontal.\n"
	exit 1
elif [ $# -eq 1 ] ; then
	cp -f ${1} $ARQ
else
	cat $@ > $ARQ
fi


########## ARRUMA LINHAS ##########

#padroniza os textos (40 caracteres por linha)
cat $ARQ | tr "\n" " " | tr -s " " | fold -s80 | sed -e 's/.\{40\}/&\n/g' | sed "/^[[:blank:]]*$/ d" | uniq > $TEMP.linhas


#corta o texto na vertical (i.e., divide em esquerda, ladoa; e direita, ladob)
i=1
while [ $i -le $(cat $TEMP.linhas | wc -l) ] ; do
	sed -n ''$i'p' $TEMP.linhas >> $TEMP.ladoa #metade esquerda
	let i++
	sed -n ''$i'p' $TEMP.linhas >> $TEMP.ladob #metade direita
	let i++
done


#corta o texto na horizontal ($MAXLIN)
split -l $MAXLIN -d -a 10 $TEMP.ladoa ladoa #corta metade esquerda em duas
split -l $MAXLIN -d -a 10 $TEMP.ladob ladob #corta metade direita em duas


#cola os quadrantes na nova ordem (2+4; 1+3)
i=1
j=0
k=1
#o printf corrige um bug anterior, pois gera correntamente os leading zeros
while [ $i -le $(echo $(ls ladoa* | wc -l)/2 | bc) ] ; do
	paste --delimiters="" ladob$(printf "%010d\n" $j) ladob$(printf "%010d\n" $k) >> $TEMP.$i
	paste --delimiters="" ladoa$(printf "%010d\n" $j) ladoa$(printf "%010d\n" $k) >> $TEMP.$i
	(( j = j + 2 ))
	(( k = k + 2 ))
	let i++
done


#embaralha as páginas (= quadrantes colados) de cut-ups
for parte in $(seq $(( $i - 1 )) | shuf) ; do
	cat $TEMP.$parte
	echo
done >> $TEMP


#cola o que restou (2+1)
if [ -f ladoa*$j ] ; then
	if [ -f ladob*$j ] ; then
		paste --delimiters="" ladob*$j ladoa*$j >> $TEMP
	else
		#se o quadrante que restou é muito grande, divide em 2 e inverte
		LIN=$(wc -l ladoa*$j | cut -d" " -f1)
		if [ $LIN -gt 6 ] ; then
			split -l $(echo $LIN/2 | bc) ladoa*$j
			paste --delimiters="" xab xaa >> $TEMP
		else
			cat ladoa*$j >> $TEMP
		fi
	fi
fi


#remove espaços duplos & renomeia
cat $TEMP | tr -s ' ' > $CUTUP

#remove arquivos temporários
rm $ARQ lado* $TEMP*

echo -e "\n> cut-up criado em $CUTUP\n"
