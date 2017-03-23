#!/bin/bash

### CUT-UP TOOLKIT
### by Bruno Cardoso · http://navalha.org
### 2008-2017. GNU/GPL. See LICENSE for license details

# Os scripts de 'CUT-UP TOOLKIT' emulam o processo de recortar-e-colar de textos ou fragmentos ou fragmentos, tal como se faria com papel e tesoura, a partir dos métodos utilizados por William S. Burroughs.

### MODO DE USAR
# 1. Torne o programa executável: chmod +x cutup3.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup2.sh TEXTO-ORIGINAL.txt (é possível utilizar quantos textos quiser)
# 3. O resultado do cut-up estará em "output/cutup2_<data atual>.txt"


### cutup2.sh
# Cut-up simples: formata o texto em $MAXPAL palavras por linha e então embaralha todas as linhas.

echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0): $(basename $0)"
echo -e "by bcardoso · http://navalha.org"

#============================================================================#

### DEFINIÇÕES
# diretorio base dos scripts
BASEDIR=~/bin/cutups
OUTPUT=$BASEDIR/output

# arquivos de entrada, saida e temporários
ARQ=$BASEDIR/alltexts.txt
CUTUP=$OUTPUT/cutup2_$(date +%F.%s).txt # formato do nome do arquivo

# número de palavras por linha
MAXPAL=7 #palavras por linha


#============================================================================#

### verifica os parâmetros
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nO texto será cortado em diversas linhas (de $MAXPAL palavras) e depois embaralhado.\n"
	exit 1
else
	cat $@ > $ARQ
fi


### RECORTE & COLAGEM
j=1 ; k=1
for i in $(cat $ARQ | tr -d "*") ; do
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

# remove arquivo temporário
rm $ARQ


### local do arquivo final
echo -e "\n> cut-up criado em $CUTUP\n"
