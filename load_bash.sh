#! /usr/bin/env bash

hasPorts=$(grep "^alias ports" ~/.bashrc | wc -l)
if [[ $hasPorts == 0 ]]; then
        echo "alias ports='sudo netstat -tplun'" >> ~/.bashrc
fi

hasLL=$(grep "^alias ll" ~/.bashrc | wc -l)
if [[ $hasLL == 0 ]]; then
        echo "alias ll='ls -lahF'"  >> ~/.bashrc
fi

hasBanIP=$(grep "^banIP()" ~/.bashrc | wc -l)
if [[ $hasBanIP == 0 ]]; then
        echo "banIP() { sudo iptables -I INPUT -s \$1 -j DROP; }"  >> ~/.bashrc
fi
