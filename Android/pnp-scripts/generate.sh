set -x
SRC=$1
#pushd
cd $SRC
perl ../clean_csv.pl $SRC > data.csv
/home/willow/prj/scribus/ScribusGenerator-master/ScribusGeneratorCLI.py template.sla -d "	" -c data.csv -m -o . -n tmp
#popd
cd -
perl clean_sla.pl $SRC/tmp.sla > $SRC/intermediate.sla