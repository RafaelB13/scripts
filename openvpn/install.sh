echo "----> Install OpenVPN Application Server"

echo
echo "--> Docker Install <--"
sleep 2
echo
apt install docker.io -y

sleep 2
echo "--> Pull image OpenVPN AS <--"
sleep 2
echo
docker pull openvpn/openvpn-as


sleep 2
echo "--> Create container OpenVPN AS <--"
sleep 2
echo
docker run -d \
  --name=openvpn-as --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v /root:/openvpn \
  openvpn/openvpn-as


GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

echo "--> Show Password OpenVPN AS <--"
sleep 2

total=60

echo "--> Wait OpenVPN SA Installation <--"
echo
for ((i=1; i<=total; i++)); do
    percentage=$((i * 100 / total))
    
    echo -ne "\r${GREEN}Process... ["
    for ((j=0; j<i; j++)); do
        echo -n "#"
    done
    for ((j=i; j<total; j++)); do
        echo -n " "
    done
    echo -ne "] ${RED}$percentage%${NC}"
    
    sleep 1
done
echo -e "\n${NC}"

URL="https://$(hostname -I | awk '{print $1}'):943/admin"
USERNAME=openvpn
PASSWORD=$(docker logs openvpn-as 2>/dev/null | grep "Auto-generated pass" | tail -n 1 | sed -n 's/.*Auto-generated pass = "\([^"]*\)".*/\1/p')

echo 
echo "============================ INFOS ============================"
echo -e "URL: ${GREEN}$URL${NC}"
echo -e "USERNAME: ${GREEN}$USERNAME${NC}"
echo -e "PASSWORD: ${GREEN}$PASSWORD${NC}"

output_file=$(pwd)/openvpn-infos.txt
echo -e "\n============================ INFOS ============================" >> "$output_file"
echo -e "URL: ${GREEN}$URL${NC}" >> "$output_file"
echo -e "USERNAME: ${GREEN}$USERNAME${NC}" >> "$output_file"
echo -e "PASSWORD: ${GREEN}$PASSWORD${NC}" >> "$output_file"
echo
echo -n "To show informations again, type: "
echo -ne "${GREEN}cat $output_file${NC}"
echo

