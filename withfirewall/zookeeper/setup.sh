#!/usr/bin/env bash
hn="$(hostname).cloudapp.net"
srv=(backend-5.cloudapp.net backend-6.cloudapp.net backend-7.cloudapp.net)

if [ "$#" -gt 0 ]; then
    printf "\e[31mERROR:\e[0m This script does not accept any arguments"
    exit 1
fi

for (( i = 0; i < ${#srv[@]}; i++ )); do
    if [ "${srv[$i]}" = "${hn}" ]; then
        # clean
        rm -f ./docker-compose.yml
        rm -f ./data/myid

        # new configuration
        cp ./docker-compose.yml.template ./docker-compose.yml
        printf "    hostname: $hn\n" >> ./docker-compose.yml
        echo $(expr $i + 1) > ./data/myid
        exit 0
    fi
done

printf "\e[31mERROR:\e[0m Not a ZooKeeper choosed server. This docker can be installed olny on:\n"

for (( i = 0; i < ${#srv[@]}; i++ )); do
    echo "- ${srv[$i]}"
done

exit 1
