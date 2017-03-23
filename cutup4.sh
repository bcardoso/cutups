#!/bin/bash

### CUT-UP TOOLKIT
### by Bruno Cardoso · http://navalha.org
### 2008-2017. GNU/GPL. See LICENSE for license details

# Os scripts de 'CUT-UP TOOLKIT' emulam o processo de recortar-e-colar de textos ou fragmentos ou fragmentos, tal como se faria com papel e tesoura, a partir dos métodos utilizados por William S. Burroughs.

### MODO DE USAR
# 1. Torne o programa executável: chmod +x cutup4.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup4.sh TEXTO-ORIGINAL.txt (é possível utilizar quantos textos quiser)
# 3. O resultado do cut-up estará em "output/cutup4_<data atual>.txt"


### cutup4.sh
# Separa e embaralha somente os parágrafos do texto (interpretados assim pela sequência \n\n).


echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0): $(basename $0)"
echo -e "by bcardoso · http://navalha.org"

#============================================================================#

### DEFINIÇÕES
# diretorio base dos scripts
BASEDIR=~/bin/cutups
OUTPUT=$BASEDIR/output

# arquivos de entrada, saida e temporários
ARQ=$BASEDIR/alltexts.txt
CUTUP=$OUTPUT/cutup4_$(date +%F.%s).txt # formato do nome do arquivo


#============================================================================#

### verifica os parâmetros
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nTodas os PARÁGRAFOS do(s) texto(s) serão embaralhados.\n"
	exit 1	
else
	cat $@ > $ARQ
fi


### RECORTE & COLAGEM
cat $ARQ | tr  "\n" "+" | sed -e 's/++/\n/g;s/+$/\n/g' | shuf | sed -e 's/$/\n/g' | tr "+" "\n" > $CUTUP


# remove arquivo temporário
rm $ARQ


### local do arquivo final
echo -e "\n> cut-up criado em $CUTUP\n"
