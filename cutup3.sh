#!/bin/bash

### CUT-UP TOOLKIT
### by Bruno Cardoso · http://navalha.org
### 2008-2017. GNU/GPL. See LICENSE for license details

# Os scripts de 'CUT-UP TOOLKIT' emulam o processo de recortar-e-colar de textos ou fragmentos ou fragmentos, tal como se faria com papel e tesoura, a partir dos métodos utilizados por William S. Burroughs.

### MODO DE USAR
# 1. Torne o programa executável: chmod +x cutup3.sh
# 2. Rode o programa com um texto, por exemplo: ./cutup3.sh TEXTO-ORIGINAL.txt (é possível utilizar quantos textos quiser)
# 3. O resultado do cut-up estará em "output/cutup3_<data atual>.txt"


### cutup3.sh
# Cut-up total: separa e embaralha TODAS as palavras do texto.

echo -e "\n$(tput bold)CUT-UP TOOLKIT$(tput sgr0): $(basename $0)"
echo -e "by bcardoso · http://navalha.org"

#============================================================================#

### DEFINIÇÕES
# diretorio base dos scripts
BASEDIR=~/bin/cutups
OUTPUT=$BASEDIR/output

# arquivos de entrada, saida e temporários
ARQ=$BASEDIR/alltexts.txt
CUTUP=$OUTPUT/cutup3_$(date +%F.%s).txt # formato do nome do arquivo


#============================================================================#

### verifica os parâmetros
if [ $# -eq 0 ] ; then
	echo -e "\nPasse um arquivo texto (ou mais) como argumento.\nTODAS as palavras do texto serão recortadas, separadas e embaralhadas.\n"
	exit 1	
else
	cat $@ > $ARQ
fi


### RECORTE & COLAGEM
j=1 ; k=1
for i in $(cat $ARQ | tr " " "\n" | shuf | tr "\n" " " | tr -d "*") ; do
	echo -n "$i "
	if [ $j -eq 12 ] ; then
        echo # insere quebra de linha para facilitar a leitura
        j=0
		if [ $k -eq 12 ] ; then
			echo # idem
			k=0
		fi
		let k++
    fi
    let j++
done > $CUTUP

# remove arquivo temporário
rm $ARQ


### local do arquivo final
echo -e "\n> cut-up criado em $CUTUP\n"
