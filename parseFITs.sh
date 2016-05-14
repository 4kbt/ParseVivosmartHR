#!/bin/bash

bin/fitdump *.fit | grep -e heart -e timestamp | 

sed 's/(//g' | sed 's/)//g' |  

awk 'BEGIN{
	#initialize variables
	realTime = 0;
	timestamp = 0;
	timestamp16 = 0;
	hrm = 0; 
     }
     {

	if( $1 == "timestamp")
	{
		timestamp = $NF;
	}

	if( $1 == "timestamp_16" )
	{
		timestamp16 = $NF;
	}

	if( $1 == "heart_rate")
	{
		hrm = $NF;

		#Attempt to synthesize clock
		newTime = int( timestamp / 2^16 ) * 2^16 + timestamp16;

		#These blocks correct for base-16 rollover before timestamp update
		if( newTime >= realTime ){

			realTime = newTime;
		}
		else{
			realTime = newTime + 2^16;
		}
			
		#Output!
		#print int(timestamp/2^16)*2^16 "\t" timestamp16 "\t"  hrm
		print realTime "\t" hrm
	}
     }
    '
