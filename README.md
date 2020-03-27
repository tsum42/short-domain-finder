# short-domain-finder
Because, as you probably know, 2 letter domains (xy.ab) can be a real treasure. They can be easily sold for a couple thousand euros. I recommend you to wait a year or two holding it and then sell it, Internet is growing and short domain will get way more valuable.

a script bundle used to find short (2 character) domain names by bruteforcing known availibility check websites without captchas and by querying whois databases.

requirements and installation:
```
sudo apt update
sudp apt upgrade
sudo apt install whois curl tor torsocks
```
edit /etc/tor/torrc and enable ControlPort on 127.0.0.1:9051 and SocksPort on 127.0.0.1:9050, use
```
tor --hash-password yourtorpassword
```
to generate a Control Hash Password to be placed in torrc. Also update that password in scripts that use it.
```
sudo apt clean
cd
git clone https://github.com/sijanec/short-domain-finder.git
cd short-domain-finder
chmod +x *.sh
chmod +x *.py
chmod +x *.php
```
