#!/bin/bash

### CUT-UP TOOLKIT
### by Bruno Cardoso · http://navalha.org
### 2008-2017. GNU/GPL. See LICENSE for license details

# Os scripts de 'CUT-UP TOOLKIT' emulam o processo de recortar-e-colar de textos ou fragmentos ou fragmentos, tal como se faria com papel e tesoura, a partir dos métodos utilizados por William S. Burroughs.

### MODO DE USAR
# 1. Torne o programa executável: chmod +x foldin.sh
# 2. Rode o programa com os textos, p.ex.: ./foldin.sh textoA.txt textoB.txt
# 3. Abra os arquivos "foldin1_<data atual>.txt" e "foldin2_<data atual>.txt" na pasta 'output' para ver o resultado.


### foldin.sh
# Este script junta a metade vertical de um página (A1 ou A2) com a outra metade de uma outra página (B1 ou B2), fundindo ambos os textos e gerando 2 outups: A1+B2 e B1+A2

echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0): $(basename $0)"
echo -e "by bcardoso · http://navalha.org"

#============================================================================#


### DEFINIÇÕES
# diretorio base dos scripts
BASEDIR=~/bin/cutups
OUTPUT=$BASEDIR/output

# arquivos de entrada, saida e temporários
ARQ=$BASEDIR/alltexts.txt
FOLDIN1=$OUTPUT/foldin1_$(date +%F.%s).txt #A1+B2
FOLDIN2=$OUTPUT/foldin2_$(date +%F.%s).txt #B1+A2
TEMP=$BASEDIR/.temptxt # prefixo dos arquivos temporários

#palavras por linha
MAXPAL=10


#============================================================================#

### verifica os parâmetros
if [ $# -eq 0 ] ; then
	echo -e "\nPasse DOIS textos como argumento.\n\nOs textos (A e B) serão recortados na vertical e colados de forma alternada (A1+B2 e B1+A2). Os resultados serão melhores se os textos tiverem tamanhos (quantidade de palavras) semelhantes.\n"
	exit 1	
elif [ $# -eq 2 ] ; then
	cp $1 $ARQ.A
	cp $2 $ARQ.B
else
	echo -e "\nPasse DOIS textos como argumento.\n"
	exit 2
fi


### RECORTE & COLAGEM
# padronização os textos: 40 caracteres por linha
cat $ARQ.A | tr "\n" " " | tr -s " " | fold -s80 | sed -e 's/.\{40\}/&\n/g' | sed "/^[[:blank:]]*$/ d" | uniq > $ARQ.a
cat $ARQ.B | tr "\n" " " | tr -s " " | fold -s80 | sed -e 's/.\{40\}/&\n/g' | sed "/^[[:blank:]]*$/ d" | uniq > $ARQ.b

# colagem das partes em função do menor texto (ignora o restante)
MAXA=$(wc -l $ARQ.a | cut -d" " -f1)
MAXB=$(wc -l $ARQ.b | cut -d" " -f1)

if [ $MAXA -lt $MAXB ] ; then
	MAXLIN=$MAXA
else
	MAXLIN=$MAXB
fi

# recorta os textos na vertical
i=1
while [ $i -le $MAXLIN ] ; do
	sed -n ''$i'p' $ARQ.a >> $TEMP.a1
	sed -n ''$i'p' $ARQ.b >> $TEMP.b1
	let i++
	sed -n ''$i'p' $ARQ.a >> $TEMP.a2
	sed -n ''$i'p' $ARQ.b >> $TEMP.b2
	let i++
done


### cola as metades
paste --delimiters="" $TEMP.a1 $TEMP.b2 > $FOLDIN1
paste --delimiters="" $TEMP.b1 $TEMP.a2 > $FOLDIN2

echo -e "\nA1+A2 = $1 \t B1+B2 = $2\n\nA1+B2 = $FOLDIN1\nB1+A2 = $FOLDIN2\n\nfast-foward. flashback.\n"

# remove arquivos temporários
rm $ARQ* $TEMP*


### local do arquivo final
echo -e "\n> fold-ins criados em $FOLDIN1 e $FOLDIN2\n"
