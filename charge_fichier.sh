#!/bin/ksh
#----------------------------------------------------------------------
#
# script :
#
# Auteur : CHRISTIAN
#


SCHEMA_SCRIPT_PATH='pwd'
SCHEMA_LOG_PATH=/user1/xxx/log
SCHEMA_CTL_PATH=/user1/xxx/loader
SCHEMA_DAT_PATH=/user1/xxx/data

FICHIER_CTL=${SCHEMA_CTL_PATH}/fichier_controle.ctl
FICHIER_DATA=${SCHEMA_DAT_PATH}/name_data.tmp
FICHIER_LOG1=${SCHEMA_LOG_PATH}/fichier_detail.log
FICHIER_BAD=${SCHEMA_LOG_PATH}/fichier_detail.bad

USER_NAME=SCHEMA1
PASSWORD_NAME=SCHEMA2


echo "###################################################################" | tee -a $FICHIER_LOG1
echo "#-- Debut du traitement de chargement des données || CLIENT"  | tee -a $FICHIER_LOG1
echo "#" | tee -a $FICHIER_LOG1

rm $SCHEMA_LOG_PATH/exist_dat.test          >>$FICHIER_LOG1
ls ${FICHIER_DATA}            >$SCHEMA_LOG_PATH/exist_dat.test

if [ $? -eq 0 ]; then

   echo "#-- Chargement  VUC || CLIENT" | tee -a $FICHIER_LOG1
   echo "#" | tee -a $FICHIER_LOG1
 
   sqlldr userid=$USER_NAME/$PASSWORD_NAME control=${FICHIER_CTL} data=${FICHIER_DATA} bad=${FICHIER_BAD} log=${FICHIER_LOG1}  errors=1000000 rows=100000  bindsize=1000000
   err=$?
   if [ $err != 0 ]; then
      echo "# Des erreurs ($err) ont ete constatees dans le chargement" | tee -a $FICHIER_LOG1
      echo "#"
      nb_err=nb_err+1
   fi  
fi

echo "#-- Fin du traitement de chargement des donnees || CLIENT" | tee -a $FICHIER_LOG1
echo "#" | tee -a $FICHIER_LOG1
echo "###################################################################" | tee -a $FICHIER_LOG1
echo | tee -a $FICHIER_LOG1
