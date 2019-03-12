#!/bin/bash
if [[ $5 == true ]]; then
whoisdatadir="whoisdata"
mkdir -p $whoisdatadir
fi

trap ctrl_c INT

function ctrl_c() {
        echo -e "\e[91m---> Terminating ...\e[0m"
        exit
}

#LOOK FOR WHOIS COMMAND
if ! whois_loc="$(type -p "whois")" || [ -z "$whois_loc" ]; then
  echo "\e[31m---> Whois is missing, trying to install it with APT.
  \e[31m---> You need sudo and APT.\e[0m"
  sudo apt-get install whois
fi

if [ -n "$1" ] ; then
        # .si domain: slovenia cctld, arnes registry, 100 queries per hour or ban
        # .no domain: norwegian, uninett norid registry, 3000 queries per day wait till midnight
        # .de domain: germany, no data of registry, 1000 queries per day or ban
        # .it domain: italy, no data of registry, no data of requests per time amount
        tlds=(si no de it ru)
        availables=('No entries found' 'No whois information found' 'Status: free' 'Status:             AVAILABLE', 'No entries found for the selected source')
        denieds=('Query denied' 'limit exceeded' '55000000002' 'denied', 'You have exceeded allowed connection rate') ## idk about .it
        sleeps=(36 29 87 87 2) # delay between requests in seconds to prevent ban
        # add your domains, you get the point
        spanje=${sleeps[0]} # max sleep of sleeps will be the sleep (-;

if [[ $1 == 'all' ]]; then
        for n in "${sleeps[@]}" ; do
                ((n > spanje)) && spanje=$n
        done
        # everything is already set!
else

                for i in "${!tlds[@]}"; do
                        if [[ "${tlds[$i]}" = "$1" ]]; then
                                index=$i;
                        fi
                done



     if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] ; then
        if [ -z $index ] ; then
                echo -e "\e[91m$---> Terminating: no whois response values stored for this domain. Input them as arguments.\e[0m"
                exit
        fi
     fi
        if [ -n "$2" ] ; then
                availables=($2)
        else
                availables=(${availables[$index]})
        fi

        if [ -n "$3" ] ; then
                denieds=($3)
        else
                denieds=(${denieds[${index}]})
        fi

        if [ -n "$4" ] ; then
                spanje=$4
        else
                spanje=${sleeps[$index]}
        fi
        tlds=($1)
fi

  ok=true
  if [ -n "$7" ] ; then
    list=`cat $7`
  else
    list=`echo {{a..z},{0..9}}{{a..z},{0..9}}`
  fi
else
  echo -e "\e[93m"'  /----------------------> Short domain finder Beta <-----------------------\'
  echo -e "\e[93m"' /------------------> 2019 Anton Sijanec, github/AstiriL <-------------------\'
  echo -e "\e[93m"'/--------> Checks all short domain names for availability using WhoIs <-------\'
  echo -e "\e[93m"'\---> Usage: ./shortdomains.sh <TLD|all> [notfound-str] [querydenied-str] <---/'
  echo -e "\e[93m"' \---> [delayseconds-int] [save-whois-bool] [show-whois-bool] [list-path] <--/'
  echo -e "\e[93m"'  \---------> Sends out a sound alert when a free domain is found <---------/'"\e[0m"
fi


if [ $ok ] ; then
        tldcount=${#tlds[@]}
echo "---> Starting... Delay: "$spanje", TLDs: "$tldcount"."
  for domain in $list # do for every 2 character possibility
  do
         sleep $spanje
        for (( i=0; i<$tldcount; i++ )); # do for every tld
        do
     VAL=`whois $domain.${tlds[$i]}`
     while [[ $VAL == *${denieds[$i]}* ]]
     do
       echo -e "\e[95m$domain.${tlds[$i]} DENIED\e[0m"
       sleep $spanje
       VAL=`whois $domain.${tlds[$i]}`
     done
         if [[ $5 == true ]]; then
                echo $VAL > "$whoisdatadir/$domain.${tlds[$i]}"
         fi
         if [[ $6 == true ]]; then
                echo $VAL
         fi
     if [[ $VAL == *${availables[$i]}* ]]
     then
       echo -e "\e[92m$domain.${tlds[$i]} FREE\e[0m\007"
       echo "$domain.${tlds[$i]}" >> freedomains.${tlds[$i]}
     else
       echo -e "\e[91m$domain.${tlds[$i]} TAKEN\e[0m"
     fi
         done
  done
  echo -e "\e[39m"
fi
