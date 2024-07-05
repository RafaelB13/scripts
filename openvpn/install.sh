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


sleep 2
echo "--> Show Password OpenVPN AS <--"
sleep 2
echo
docker logs openvpn-as | grep "Auto-generated pass"
