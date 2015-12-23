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
# 1. Torne o programa executável: chmod +x foldin.sh
# 2. Rode o programa com os texto, p.ex.: ./foldin.sh textoAAA.txt textoBBB.txt
# 3. Abra os arquivos "foldin1_<data atual>.txt" e "foldin2_<data atual>.txt" para ver o resultado.


# Este arquivo: foldin.sh
# ======================
# Outra técnica de cut-up utilizada por William Burroughs: junta-se a metade vertical de um página (A1 ou A2) com a outra metade de uma outra página (B1 ou B2), fundindo ambos os textos e gerando 2 outups: A1+B2 e B1+A2


echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0)"
echo -e "by Bruno Cardoso | bcardoso | http://navalha.org"
echo -e "GNU/GPL. See LICENSE for license details."


ARQ=text.txt
FOLDIN1=foldin1_$(date +%F.%s).txt #A1+B2
FOLDIN2=foldin2_$(date +%F.%s).txt #B1+A2
TEMP=.temp_texto.txt

#palavras por linha
MAXPAL=10

#verifica os argumentos
if [ $# -eq 0 ] ; then
	echo -e "\nPasse DOIS textos como argumento.\n\nOs textos (A e B) serão recortados na vertical e colados de forma alternada (A1+B2 e B1+A2). Os resultados serão melhores se os textos tiverem tamanhos (quantidade de palavras) semelhantes.\n"
	exit 1	
elif [ $# -eq 2 ] ; then
	cp $1 $ARQ.aa
	cp $2 $ARQ.bb
else
	echo -e "\nPasse DOIS textos como argumento.\n"
	exit 2
fi


########## THE MAGIC GOES BELOW ##########

#padroniza os textos (40 caracteres por linha)
cat $ARQ.aa | tr "\n" " " | tr -s " " | fold -s80 | sed -e 's/.\{40\}/&\n/g' | sed "/^[[:blank:]]*$/ d" | uniq > $ARQ.a
cat $ARQ.bb | tr "\n" " " | tr -s " " | fold -s80 | sed -e 's/.\{40\}/&\n/g' | sed "/^[[:blank:]]*$/ d" | uniq > $ARQ.b


#colagem das partes em função do menor texto (ignora o restante)
MAXA=$(wc -l $ARQ.a | cut -d" " -f1)
MAXB=$(wc -l $ARQ.b | cut -d" " -f1)

if [ $MAXA -lt $MAXB ] ; then
	MAXLIN=$MAXA
else
	MAXLIN=$MAXB
fi


#recorta os textos na vertical
i=1
while [ $i -le $MAXLIN ] ; do
	sed -n ''$i'p' $ARQ.a >> $TEMP.a1
	sed -n ''$i'p' $ARQ.b >> $TEMP.b1
	let i++
	sed -n ''$i'p' $ARQ.a >> $TEMP.a2
	sed -n ''$i'p' $ARQ.b >> $TEMP.b2
	let i++
done


#cola as partes
paste --delimiters="" $TEMP.a1 $TEMP.b2 > $FOLDIN1
paste --delimiters="" $TEMP.b1 $TEMP.a2 > $FOLDIN2

echo -e "\nA1+A2 = $1 \t B1+B2 = $2\n\nA1+B2 = $FOLDIN1\nB1+A2 = $FOLDIN2\n\nfast-foward. flashback.\n"

rm $ARQ* $TEMP*

echo -e "\n> fold-ins criados em $FOLDIN1 e $FOLDIN2\n"
