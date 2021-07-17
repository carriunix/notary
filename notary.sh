#!/bin/sh
#
# notary dot sh
# Script to create certificates.
# stardate 1711.22
# carriunix (carriunix@gmail.com)
#
#
# Copyright 2021 Marcus Carrião (carriunix@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the 
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to 
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
envio() {
# Gerar zip dos certificados e enviar por email/Generate zip file and send by email
  echo "Enviando para inscrito n. $ID"
  cd $diretorio/"ID_"$ID
  zip -r /tmp/certificados_$ID.zip ./*
  mutt -s "Escola de Fisica: certificados" $email < $DIR/email_$modelo.txt -a /tmp/certificados_$ID.zip
  cd $DIR
}
tipo1() {
  name=`cat $arquivo | awk -F "\t" '{print $2}' | head -n $i | tail -n 1`;
  email=`cat $arquivo | awk -F "\t" '{print $3}' | head -n $i | tail -n 1`;
  hours=`cat $arquivo | awk -F "\t" '{print $4}' | head -n $i | tail -n 1`;
  title=`cat $arquivo | awk -F "\t" '{print $5}' | head -n $i | tail -n 1`;
  authors=`cat $arquivo | awk -F "\t" '{print $6}' | head -n $i | tail -n 1`;
  model=`cat $arquivo | awk -F "\t" '{print $7}' | head -n $i | tail -n 1`
  category=`cat $arquivo | awk -F "\t" '{print $8}' | head -n $i | tail -n 1`;
  course1=`cat $arquivo | awk -F "\t" '{print $9}' | head -n $i | tail -n 1`;
  c1hours=`cat $arquivo | awk -F "\t" '{print $10}' | head -n $i | tail -n 1`;
  course2=`cat $arquivo | awk -F "\t" '{print $11}' | head -n $i | tail -n 1`;
  c2hours=`cat $arquivo | awk -F "\t" '{print $12}' | head -n $i | tail -n 1`;
# Gerar certificado de participação/Generate participants certificate
  sed -e "s/varNOME/$name/g" -e  "s/varHORAS/$hours/g" < "model_participacao.tex" > /tmp/"participacao_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"participacao_"$ID".tex" 1>/dev/null;
  wait;
  rm "participacao_"$ID".aux" "participacao_"$ID".log";
  mv "participacao_"$ID".pdf" $diretorio/"ID_"$ID/"participacao_"$ID".pdf";
# Gerar certificado do minicurso 1/Generate workshop 1 certificate
  if [ ! -z "$course1" ]; then
  sed -e "s/varNOME/$name/g" -e "s/varCURSO/$course1/g" -e  "s/varHORAS/$c1hours/g" < "model_minicurso.tex" > /tmp/"minicurso1_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"minicurso1_"$ID".tex" 1>/dev/null;
  wait;
  rm "minicurso1_"$ID".aux" "minicurso1_"$ID".log";
  mv "minicurso1_"$ID".pdf" $diretorio/"ID_"$ID/"minicurso1_"$ID".pdf";
  fi;
# Gerar certificado do minicurso 2/Generate workshop 2 certificate
  if [ ! -z "$course2" ]; then
  sed -e "s/varNOME/$name/g" -e "s/varCURSO/$course2/g" -e "s/varHORAS/$c2hours/g" < "model_minicurso.tex" > /tmp/"minicurso2_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"minicurso2_"$ID".tex" 1>/dev/null;
  wait;
  rm "minicurso2_"$ID".aux" "minicurso2_"$ID".log";
  mv "minicurso2_"$ID".pdf" $diretorio/"ID_"$ID/"minicurso2_"$ID".pdf";
  fi;
# Gerar certificado de apresentação de trabalho/Generate presentation certificate
  if [ ! -z "$title" ]; then
  sed -e "s/varAUTORES/$authors/g" -e "s/varTITULO/$title/g" -e "s/varMODALIDADE/$model/g" < "model_apresentacao.tex" > /tmp/"apresentacao_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"apresentacao_"$ID".tex" 1>/dev/null;
  wait;
  rm "apresentacao_"$ID".aux" "apresentacao_"$ID".log";
  mv "apresentacao_"$ID".pdf" $diretorio/"ID_"$ID/"apresentacao_"$ID".pdf";
  fi;
# Gerar certificado de premiação de trabalho/Generate prize certificate
  if [ ! -z "$category" ]; then
  sed -e "s/varAUTORES/$authors/g" -e "s/varTITULO/$title/g" -e "s/varCATEGORIA/$category/g" < "model_premiacao.tex" > /tmp/"premiacao_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"premiacao_"$ID".tex" 1>/dev/null;
  wait;
  rm "premiacao_"$ID".aux" "premiacao_"$ID".log";
  mv "premiacao_"$ID".pdf" $diretorio/"ID_"$ID/"premiacao_"$ID".pdf";
  fi
  modelo="participante"
  envio
}
tipo2() { 
# Gerar certificado de palestrante/Generate speaker certificate
  name=`cat $arquivo | awk -F "\t" '{print $2}' | head -n $i | tail -n 1`;
  email=`cat $arquivo | awk -F "\t" '{print $3}' | head -n $i | tail -n 1`;
  title=`cat $arquivo | awk -F "\t" '{print $5}' | head -n $i | tail -n 1`;
  sed -e "s/varNOME/$name/g" -e  "s/varTITULO/$title/g" < "model_palestrante.tex" > /tmp/"palestrante_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"palestrante_"$ID".tex" 1>/dev/null;
  wait;
  rm "palestrante_"$ID".aux" "palestrante_"$ID".log";
  mv "palestrante_"$ID".pdf" $diretorio/"ID_"$ID/"palestrante_"$ID".pdf"
  modelo="palestrante"
  envio
}
tipo3() {
# Gerar certificado instrutor de minicurso/Generate workshop instructor certificate
  name=`cat $arquivo | awk -F "\t" '{print $2}' | head -n $i | tail -n 1`;
  email=`cat $arquivo | awk -F "\t" '{print $3}' | head -n $i | tail -n 1`;
  course1=`cat $arquivo | awk -F "\t" '{print $9}' | head -n $i | tail -n 1`;
  c1hours=`cat $arquivo | awk -F "\t" '{print $10}' | head -n $i | tail -n 1`;
  sed -e "s/varNOME/$name/g" -e  "s/varCURSO/$course1/g" -e "s/varHORAS/$c1hours/g" < "model_instrutor.tex" > /tmp/"instrutor_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"instrutor_"$ID".tex" 1>/dev/null;
  wait;
  rm "instrutor_"$ID".aux" "instrutor_"$ID".log";
  mv "instrutor_"$ID".pdf" $diretorio/"ID_"$ID/"instrutor_"$ID".pdf"
  modelo="instrutor"
  envio
}
tipo4() { 
# Gerar certificado de monitor/Generate monitor certificate
  name=`cat $arquivo | awk -F "\t" '{print $2}' | head -n $i | tail -n 1`;
  email=`cat $arquivo | awk -F "\t" '{print $3}' | head -n $i | tail -n 1`;
  hours=`cat $arquivo | awk -F "\t" '{print $4}' | head -n $i | tail -n 1`;
  sed -e "s/varNOME/$name/g" -e  "s/varHORAS/$hours/g" < "model_monitor.tex" > /tmp/"monitor_"$ID".tex";
  pdflatex -interaction=batchmode /tmp/"monitor_"$ID".tex" 1>/dev/null;
  wait;
  rm "monitor_"$ID".aux" "monitor_"$ID".log";
  mv "monitor_"$ID".pdf" $diretorio/"ID_"$ID/"monitor_"$ID".pdf"
  modelo="monitor"
  envio
}
echo " "
echo "Que tipo de certificados você gostaria de gerar?"
echo " "
echo "[1] Participantes"
echo "[2] Palestrantes"
echo "[3] Instrutores de minicurso"
echo "[4] Monitores"
echo " "
read -s -n 1 option
case $option in
  1) arquivo="list_participantes.txt"; diretorio="cert_participantes";;
  2) arquivo="list_palestrantes.txt"; diretorio="cert_palestrantes";;
  3) arquivo="list_instrutores.txt"; diretorio="cert_instrutores";;
  4) arquivo="list_monitores.txt"; diretorio="cert_monitores";;
  *) echo "Ops, opção inválida"; exit;; 
esac
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
if [ ! -d "$diretorio" ]; then
mkdir "$diretorio"
fi
linhas=`grep -c . "$arquivo"`
for (( i=1; i <= $linhas; ++i ))
do
  ID=`cat $arquivo | awk -F "\t" '{print $1}' | head -n $i | tail -n 1`
  if [ ! -d "$diretorio/ID_$ID" ]; then
    mkdir "$diretorio/ID_$ID"
  fi
  case $option in
    1) tipo1;;
    2) tipo2;;
    3) tipo3;;
    4) tipo4;;
  esac

done
