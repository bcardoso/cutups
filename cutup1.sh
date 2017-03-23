#!/bin/bash

### CUT-UP TOOLKIT
### by Bruno Cardoso · http://navalha.org
### 2008-2017. GNU/GPL. See LICENSE for license details

# Os scripts de 'CUT-UP TOOLKIT' emulam o processo de recortar-e-colar de textos ou fragmentos ou fragmentos, tal como se faria com papel e tesoura, a partir dos métodos utilizados por William S. Burroughs.

### MODO DE USAR
# 1. Torne o programa executável: chmod +x cutup1.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup1.sh TEXTO-ORIGINAL.txt (é possível utilizar quantos textos quiser)
# 3. O resultado do cut-up estará em "output/cutup1_<data atual>.txt"


### cutup1.sh
# Este cut-up separa o texto em quatro quadrantes (40x12) por página (80x24) e os embaralha. Ex:
#      1 2  ->   2 4
#      3 4  ->   1 3

echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0): $(basename $0)"
echo -e "by bcardoso · http://navalha.org"

#============================================================================#

### DEFINIÇÕES
# diretorio base dos scripts
BASEDIR=~/bin/cutups
OUTPUT=$BASEDIR/output

# arquivos de entrada, saida e temporários
ARQ=$BASEDIR/alltexts.txt
CUTUP=$OUTPUT/cutup1_$(date +%F.%s).txt # formato do nome do arquivo
TEMP=$BASEDIR/.temptxt # prefixo dos arquivos temporários

# dimensoes de cada quadrante do texto
# MAXLIN = numero de linhas (de 40 caracteres cada)
MAXLIN=12


#============================================================================#

### verifica os parâmetros
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\n\nO texto será divido em quadrantes (de $MAXLIN linhas x 40 caracteres) e depois embaralhado. Se o texto for menor que o esperado (1920 caracteres ~uma lauda), ele não será recortado na horizontal.\n"
	exit 1
else
	cat $@ > $ARQ
fi


### forma padrão: 40 caracteres por linha
cat $ARQ | tr "\n" " " | tr -s " " | fold -s80 | sed -e 's/.\{40\}/&\n/g' | sed "/^[[:blank:]]*$/ d" | uniq > $TEMP.linhas


### RECORTE
# corta o texto na vertical: divide em esquerda 'ladoa'; e direita 'ladob'
i=1
while [ $i -le $(cat $TEMP.linhas | wc -l) ] ; do
	sed -n ''$i'p' $TEMP.linhas >> $TEMP.ladoa #metade esquerda (1-3)
	let i++
	sed -n ''$i'p' $TEMP.linhas >> $TEMP.ladob #metade direita (2-4)
	let i++
done

# corta o texto na horizontal ($MAXLIN)
split -l $MAXLIN -d -a 10 $TEMP.ladoa ladoa #corta metade esquerda em duas (1, 3)
split -l $MAXLIN -d -a 10 $TEMP.ladob ladob #corta metade direita em duas (2, 4)


### COLAGEM
# cola os quadrantes na nova ordem (2+4; 1+3) para formar uma pagina
i=1 ; j=0 ; k=1
while [ $i -le $(echo $(ls ladoa* | wc -l)/2 | bc) ] ; do
	paste --delimiters="" ladob$(printf "%010d\n" $j) ladob$(printf "%010d\n" $k) >> $TEMP.$i
	paste --delimiters="" ladoa$(printf "%010d\n" $j) ladoa$(printf "%010d\n" $k) >> $TEMP.$i
	(( j = j + 2 ))
	(( k = k + 2 ))
	let i++
done

# embaralha a ordem das páginas coladas no passo anterior
for parte in $(seq $(( $i - 1 )) | shuf) ; do
	cat $TEMP.$parte
	echo
done >> $TEMP

# cola os pedaços restantes (2+1)
if [ -f ladoa*$j ] ; then
	if [ -f ladob*$j ] ; then
		paste --delimiters="" ladob*$j ladoa*$j >> $TEMP
	else
		# se o quadrante que restou é muito grande, divide em 2 e inverte
		LIN=$(wc -l ladoa*$j | cut -d" " -f1)
		if [ $LIN -gt 6 ] ; then
			split -l $(echo $LIN/2 | bc) ladoa*$j
			paste --delimiters="" xab xaa >> $TEMP
		else
			cat ladoa*$j >> $TEMP
		fi
	fi
fi


### LIMPA OS RESTOS
# remove espaços duplos & renomeia arquivo final
cat $TEMP | tr -s ' ' > $CUTUP

# remove arquivos temporários
rm $ARQ lado* $TEMP*


### local do arquivo final
echo -e "\n> cut-up criado em $CUTUP\n"
