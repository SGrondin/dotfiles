#! /usr/bin/env bash

if (( $( grep "^alias ports" ~/.bashrc | wc -l ) ==0 )); then
        echo "alias ports='sudo netstat -tplun'" >> ~/.bashrc
fi

if (( $( grep "^alias ll" ~/.bashrc | wc -l ) == 0 )); then
        echo "alias ll='ls -lahF'"  >> ~/.bashrc
fi


if (( $( grep "^saveIPTABLES()" ~/.bashrc | wc -l ) == 0 )); then
    echo "saveIPTABLES() {
        if (( \$( sudo dpkg --list | grep iptables-persistent | wc -l ) == 0 )); then
            echo \"Installing iptables-persistent...\"
            sleep 2
            sudo apt-get install iptables iptables-persistent
        fi
        echo \"Saving iptables configuration to /etc/iptables/rules.v4\"
        sleep 1
        sudo iptables-save | sudo tee /etc/iptables/rules.v4; }" >> ~/.bashrc
fi

if (( $( grep "^loadIPTABLES()" ~/.bashrc | wc -l ) == 0 )); then
    echo "loadIPTABLES() {
        if [ -f /etc/iptables/rules.v4 ]; then
            sudo iptables-restore < /etc/iptables/rules.v4
            echo \"Loaded /etc/iptables/rules.v4\"
        else
            echo \"/etc/iptables/rules.v4\"
        fi }" >> ~/.bashrc
fi

if (( $( grep "^banIP()" ~/.bashrc | wc -l ) == 0 )); then
        echo "banIP() {
            sudo iptables -I INPUT -s \$1 -j DROP;
            saveIPTABLES; }"  >> ~/.bashrc
fi

if (( $( grep "^forwardPORT()" ~/.bashrc | wc -l ) == 0 )); then
        echo "forwardPORT() {
            sudo iptables -t nat -A OUTPUT -p tcp --dport \$1 -j DNAT --to-destination \$2:\$3 ;
            saveIPTABLES; }"  >> ~/.bashrc
fi

if (( $( grep "^bridgePORT()" ~/.bashrc | wc -l ) == 0 )); then
    echo "bridgePORT() {
    if (( \$(sudo sysctl net.ipv4.ip_forward | grep \"= \?0\" | wc -l) == 0 )); then
        sudo sysctl net.ipv4.ip_forward=1
    fi
    if (( \$( grep \"^#net.ipv4.ip_forward=1\" /etc/sysctl.conf | wc -l ) == 0 )); then
        echo \"Enabling net.ipv4.ip_forward in /etc/sysctl.conf\"
        sleep 1
        sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

        if (( \$( grep \"^net.ipv4.ip_forward=1\" /etc/sysctl.conf | wc -l ) == 0 )); then
            echo \"net.ipv4.ip_forward=1\" | sudo tee -a /etc/sysctl.conf
        fi
    fi

    sudo iptables -t nat -A PREROUTING -p tcp --dport \$1 -j DNAT --to-destination \$2:\$3 ;
    if (( \$( grep MASQUERADE /etc/iptables/rules.v4 | grep POSTROUTING | wc -l ) == 0 )); then
        sudo iptables -t nat -A POSTROUTING -j MASQUERADE
    fi

    saveIPTABLES; }" >> ~/.bashrc
fi

