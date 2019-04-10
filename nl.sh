#!/bin/bash
# for getting .nl 2 letter domains, not saved anywhere, just printed to stdout. tor is used to change IP, 100req/IP/day!
# you need curl and tor, also update torpassword variable with your controlpassword (NOT HASH!).
trap ctrl_c INT

function ctrl_c() {
        echo -e "\e[91m---> Terminating ...\e[0m"
        exit
}


if [ -n "$1" ] ; then

  ok=true
  spanje=0.1
  torpassword="antoniolukas"
  list=`echo {{a..z},{0..9}}{{a..z},{0..9}}`

else
  echo -e "\e[93m"'  /---------------------> Short nl domain finder Beta <---------------------\'
  echo -e "\e[93m"' /------------------> 2019 Anton Sijanec, github/AstiriL <-------------------\'
  echo -e "\e[93m"'/--------> Checks all short domain names for availability using WWW <-..------\'
  echo -e "\e[93m"'\---> Usage: ./nl.sh start                                                <---/'
  echo -e "\e[93m"' \---> queries netherlands TLD (.nl) web domain availability database via <--/'
  echo -e "\e[93m"'  \---------> Tor. In case of Too many requests, Tor will get a new IP. <---/'"\e[0m"
fi

if [ $ok ] ; then
echo "---> Starting... Delay: "$spanje s", TLD: nl."
  for domain in $list # do for every 2 character possibility
  do
	sleep $spanje # we don't need no sleep! tho
     VAL=`curl "https://www.sidn.nl/rest/is?domain=$domain" -s --socks5 localhost:9050`
     while [[ $VAL == *"Too many requests"* ]]
     do
       echo -e "\e[95m$domain.nl Request Limit Passed, New IP ...\e[0m"
	   printf 'AUTHENTICATE "'$torpassword'"\r\nSIGNAL NEWNYM\r\n' | nc 127.0.0.1 9051 -q 1
       sleep $spanje # no sleep baby! tho
       VAL=`curl "https://www.sidn.nl/rest/is?domain="$domain -s --socks5 localhost:9050`
     done
     if [[ $VAL == *"is beschikbaar"* ]]
     then
       echo -e "\e[92m$domain.nl FREE\e[0m\007"
       echo "$domain.nl" >> freedomains-www.nl
     else
       echo -e "\e[91m$domain.nl TAKEN\e[0m"
	   echo $VAL>lastlookup.nl
     fi
  done
  echo -e "\e[39m"
fi
