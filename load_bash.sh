#! /usr/bin/env bash

if (( $( grep "^alias ports" ~/.bashrc | wc -l ) ==0 )); then
        echo "alias ports='sudo netstat -tplun'" >> ~/.bashrc
        echo "Loaded ports"
fi

if (( $( grep "^alias ll" ~/.bashrc | wc -l ) == 0 )); then
        echo "alias ll='ls -lahF'"  >> ~/.bashrc
        echo "Loaded ll"
fi

if (( $( grep "^alias please" ~/.bashrc | wc -l ) == 0 )); then
        echo "alias please='sudo \$(fc -nl -1)'"  >> ~/.bashrc
        echo "Loaded please"
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
    echo "Loaded saveIPTABLES"
fi

if (( $( grep "^loadIPTABLES()" ~/.bashrc | wc -l ) == 0 )); then
    echo "loadIPTABLES() {
        if [ -f /etc/iptables/rules.v4 ]; then
            sudo iptables-restore < /etc/iptables/rules.v4
            echo \"Loaded /etc/iptables/rules.v4\"
        else
            echo \"/etc/iptables/rules.v4\"
        fi }" >> ~/.bashrc
    echo "Loaded loadIPTABLES"
fi

if (( $( grep "^banIP()" ~/.bashrc | wc -l ) == 0 )); then
        echo "banIP() {
            sudo iptables -I INPUT -s \$1 -j DROP;
            saveIPTABLES; }"  >> ~/.bashrc
        echo "Loaded saveIPTABLES"
fi

if (( $( grep "^forwardPORT()" ~/.bashrc | wc -l ) == 0 )); then
        echo "forwardPORT() {
            sudo iptables -t nat -A OUTPUT -p tcp --dport \$1 -j DNAT --to-destination \$2:\$3 ;
            saveIPTABLES; }"  >> ~/.bashrc
        echo "Loaded forwardPORT"
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
    echo "Loaded bridgePORT"
fi

if (( $( grep "^upload()" ~/.bashrc | wc -l ) == 0 )); then
    echo "upload() {
    CODE=\$(curl -I http://simongrondin.name/files/\$1 | head -n 1)
    if (( \$( echo \$CODE | grep 200 | wc -l ) == 1 )); then
        echo \$CODE;
        echo \"Already exists\"
        return 1;
    fi
    scp -P 22022 \$1 hyssar@govpop.com:/var/www/simongrondin/files/\$1;
    echo \"http://simongrondin.name/files/\"\$1; }" >> ~/.bashrc
    echo "Loaded upload"
fi

if (( $( grep "^moshSERVER()" ~/.bashrc | wc -l ) == 0 )); then
    echo "moshSERVER() {
        mosh --ssh=\"ssh -p 22022\" hyssar@govpop.com
    }" >> ~/.bashrc
fi

if (( $( grep "^oclean()" ~/.bashrc | wc -l ) == 0 )); then
    echo "oclean() {
        rm *.cmi *.cmx *.o
    }" >> ~/.bashrc
fi

if (( $( grep "^mtime()" ~/.bashrc | wc -l ) == 0 )); then
    echo "mtime() {
        NBRUNS=\$1
        shift
        time for (( i=0; i<\$NBRUNS; i++ )) do
            \"\$@\"
        done
    }" >> ~/.bashrc
fi

if (( $( grep "^reverseMouse()" ~/.bashrc | wc -l ) == 0 )); then
    echo "reverseMouse() {
        if (( \$( grep \"1 2 3 5 4 7 6 8 9 10 11 12\" ~/.Xmodmap | wc -l ) == 1 )); then
            echo \"pointer = 1 2 3 4 5 6 7 8 9 10 11 12\" > ~/.Xmodmap
        else
            echo \"pointer = 1 2 3 5 4 7 6 8 9 10 11 12\" > ~/.Xmodmap
        fi
        xmodmap ~/.Xmodmap
    }" >> ~/.bashrc
fi

if (( $( grep "^psx()" ~/.bashrc | wc -l ) == 0 )); then
    echo "psx() {
        ps aux | grep \$1 | cut -c1-150;
    }" >> ~/.bashrc
fi