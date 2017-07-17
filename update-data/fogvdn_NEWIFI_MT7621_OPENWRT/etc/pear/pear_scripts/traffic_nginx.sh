#! /usr/bin/awk -f
#  
#  
#
#

BEGIN {
	"date +%Y" | getline YEAR
	"date +%m" | getline MONTH
	"date +%d" | getline DAY
	"date +%H" | getline HOUR
	"date +%M" | getline MINUTE
	"date +%S" | getline SECOND

	if(MINUTE > 5) {
		MINUTE=MINUTE-5;
		if (MINUTE < 10) { MINUTE="0"MINUTE; }
	} else {
		MINUTE=MINUTE+55;
		if (HOUR > 1) {
			HOUR=HOUR-1;
			if (HOUR < 10) { HOUR="0"HOUR; }
		} else { HOUR=HOUR+23; }
	}
	start_time=(YEAR"-"MONTH"-"DAY"T"HOUR":"MINUTE":"SECOND)
	###printf "start_time: %s\n",start_time
	printf "traffic "
}
	
{
	if($3 >= start_time && (($7 == "200") || ($7 == "206"))){
		sum[$5] += $8;
	}
}

END {
	for (i in sum) {
		#if (substr(i, 1, 5) == "https") {

			printf "%s %s ",substr(i,1,30),sum[i]
		#}
	}

	#print "{\"host\":\""i"\",\"traffic\":\""sum[i]"\"}";
}
