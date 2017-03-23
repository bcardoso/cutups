#!/bin/bash

### CUT-UP TOOLKIT
### by Bruno Cardoso · http://navalha.org
### 2008-2017. GNU/GPL. See LICENSE for license details

# Os scripts de 'CUT-UP TOOLKIT' emulam o processo de recortar-e-colar de textos ou fragmentos ou fragmentos, tal como se faria com papel e tesoura, a partir dos métodos utilizados por William S. Burroughs.

### MODO DE USAR
# 1. Torne o programa executável: chmod +x cutup5.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup5.sh TEXTO-ORIGINAL.txt (é possível utilizar quantos textos quiser)
# 3. O resultado do cut-up estará em "output/cutup5_<data atual>.txt"


### cutup5.sh
# Separa todas as FRASES do texto, com base em sinais de pontuação, e as embaralha.

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


#============================================================================#

### verifica os parâmetros
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nTodas as FRASES serão cortadas e depois embaralhado.\n"
	exit 1
else
	cat $@ > $ARQ
fi


### RECORTE & COLAGEM
# substitui sinais de pontuação (.,;?!:-()[] e ou) por quebras de linha e embaralha
cat $ARQ |
sed -e 's/\./\.\n/g;s/,/,\n/g;s/;/;\n/g;s/?/?\n/g;s/\!/\!\n/g;s/:/:\n/g;s/ -/\n/g;s/- /\n/g;s/(/\n/g;s/)/\n/g;s/\[/\n/g;s/\]/\n/g;s/ e / e\n/g;s/ ou / ou\n/g' | grep -v ^"\(;\|,\|.\)"$ | shuf | sed -e 'N;s/\n/ /' | tr -s " " | sed -e 's/^ //' > $CUTUP

# remove arquivo temporário
rm $ARQ


### local do arquivo final
echo -e "\n> cut-up criado em $CUTUP\n"
