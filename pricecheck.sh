#!/bin/bash
#setLink=$1
setPrice=$1
status="OK"

function showHelp (){
	echo "name.sh link price"
}

function checkPrice (){
	if [ -z $1 ]; then
		echo "ERROR 1;ERROR 1"
	else
		if [ $1 -lt $setPrice ]; then
			echo "YAY;$1;"
		else
			echo "NOO;$1;"
		fi
	fi
}

function runCheckXtreem (){
#	priceOnPage = $(curl -s https://xtreem.pl/procesory/1243-amd-ryzen-5-3600-36-42ghz-100-100000031box-730143309936.html|grep -i "productPrice =" | awk -F'=' "{ print $2 }"| tr -d ';')
	priceOnPage=$(curl -s https://xtreem.pl/procesory/1243-amd-ryzen-5-3600-36-42ghz-100-100000031box-730143309936.html|grep -i "productPrice =" | awk -F= '{ print $2 }'| tr -d ';'|tr -d ' ')
	checkPrice $priceOnPage
}

function runCheckXkom (){
	priceOnPage=$(curl -s https://www.x-kom.pl/p/500085-procesor-amd-ryzen-amd-ryzen-5-3600.html|grep -i '<meta property="product:price:amount"'|awk -F'"' '{print $4}'|awk -F'.' '{print $1}')
	checkPrice $priceOnPage
 }

 function runCheckProline (){
	priceOnPage=$(curl -s https://proline.pl/procesor-amd-ryzen-5-3600-am4-p1367204|grep -i '<td class="toRight"><b class="cena_b">'|awk -F'>' '{print $33}'|awk -F',' '{print $1}')
 	checkPrice $priceOnPage
 }

 function runCheckCeneo (){
	 prices=$(curl -s https://www.ceneo.pl/83359603#tab=click|grep -A3 -iE 'cell-price'|grep -i 'value'|grep -vi 'Aggregate'|awk -F'>' '{print $4}'|awk -F'<' '{print $1}')
	 for i in $prices; do
		 checkPrice $i
	 done
 }
if [ -z $1 ]; then
	showHelp
	exit 1 
fi


echo -n $(date +%Y-%m-%d)";"$(date +%H:%M)";"

status=$(runCheckXtreem)
echo -n $status

status=$(runCheckXkom)
echo -n $status

status=$(runCheckProline)
echo -n $status

status=$(runCheckCeneo)
echo -n $status

echo ";"
