#! /bin/sh

if [ $1"x" = x ]; then
	echo "./capture.sh <freq> [duration==10] [decim==112] [gain==52]"
	echo "Example: ./capture.sh 940.4M"
	exit 1
fi
FREQ=$1

DURATION=$2
if [ $2"x" = x ]; then
	DURATION=10
fi
DECIM=$3
if [ $3"x" = x ]; then
	DECIM=112
fi

GAIN=$4
if [ $4"x" = x ]; then
	GAIN=52
fi


UHD_PROG=uhd_rx_cfile

which "$UHD_PROG" 1> /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
	echo "ERROR: uhd_rx_cfile not found. Make sure it's in your PATH!"
	exit 1
fi

FILE="capture_${FREQ}_${DECIM}.cfile"
sample_rate=`expr 64000000 / $DECIM`
samples=`expr $sample_rate '*' $DURATION`
echo "Capturing for $DURATION seconds to $FILE ($samples samples)"
$UHD_PROG -g $GAIN -f "$FREQ" --samp-rate=$sample_rate -N $samples $FILE

