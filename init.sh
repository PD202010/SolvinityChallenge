#!/bin/bash
export script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"



#
# Pas de onderstaande instellingen aan op de omgeving
# 
export downloaddir="$HOME/Downloads"
export centos_iso_url=http://ftp.tudelft.nl/centos.org/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso
export ansible_collections_location="$HOME/.ansible/collections/ansible_collections"


#### Uitvoeren van wat basic-tests

export ansible_version=$(ansible --version | head -1 | awk '{ print $2 }')
export python_docker=$(pip3 list | greetp docker | wc -l)
export python_requests=$(pip3 list | grep requests | wc -l)
stop=false


#### Twee functies om versienummers te vergelijken
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}
testvercomp () {
    vercomp $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]
    then
        version_result="verouderd.  Verwachte versie: > '$2', Huidige versie: '$1'"
	stop=true
    else
        version_result="actueel.: '$1 $op $2'"
    fi
}



#### Hier starten de echte tests

testvercomp $ansible_version 2.9.0 '>'
echo "- Ansible versie: $version_result"

if [ -d "$ansible_collections_location/community/general" ]; then
	file_result="geinstalleerd"
else
	file_result="niet aanwezig"
	stop=true
fi
echo "- Ansible Collection: community.general is $file_result" 
echo ""

if [ $python_docker -gt 0 ]; then
	file_result="geinstalleerd"
else
	file_result="niet aanwezig"
	stop=true
fi
echo "- Python module: docker SDK is $file_result"
if [ $python_requests -gt 0 ]; then
	file_result="geinstalleerd"
else
	file_result="niet aanwezig"
	stop=true
fi
echo "- Python module: requests is $file_result"

if [ $stop == true ]; then
	echo "Init kan niet doorgaan, controleer aub. de bovenstaande punten.."
	exit
fi

echo "Checks geslaagd, iso download naar $downloaddir wordt gestart"
cd $downloaddir
curl -O $centos_iso_url
