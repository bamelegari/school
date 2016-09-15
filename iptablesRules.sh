#!/bin/bash

iptables -F
ip6tables -F
iptables -X
ip6tables -X
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables --append INPUT  -p udp -d 0.0.0.0/0 --dport 68 -s 10.20.20.1/32 --sport 67 --jump ACCEPT
iptables --append OUTPUT -p udp -s 0.0.0.0/0 --sport 68 -d 10.20.20.1/32 --dport 67 --jump ACCEPT
iptables --append OUTPUT -p udp -s 0.0.0.0/0 -d 10.20.20.1/32 --dport 53 --jump ACCEPT
iptables --append INPUT -p udp -d 0.0.0.0/0 -s 10.20.20.1/32 --sport 53 --jump ACCEPT
iptables --append OUTPUT -p tcp -s 0.0.0.0/0 -d 0.0.0.0/0 --dport 22 --jump ACCEPT
iptables --append OUTPUT -p tcp -s 0.0.0.0/0 -d 0.0.0.0/0 --dport 80 --jump ACCEPT
iptables --append OUTPUT -p tcp -s 0.0.0.0/0 -d 0.0.0.0/0 --dport 443 --jump ACCEPT
iptables -P FORWARD DROP
ip6tables -P FORWARD DROP
iptables -P OUTPUT DROP
ip6tables -P OUTPUT DROP
iptables -P INPUT DROP
ip6tables -P INPUT DROP
iptables -N LOG_OUT
ip6tables -N LOG_OUT
iptables -N LOG_IN
ip6tables -N LOG_IN
iptables -A OUTPUT -j LOG_OUT
ip6tables -A OUTPUT -j LOG_OUT
iptables -A INPUT -j LOG_IN
ip6tables -A INPUT -j LOG_IN
iptables -A LOG_OUT -m limit --limit 2/min -j LOG --log-prefix "iptables-out: " --log-level 4
ip6tables -A LOG_OUT -m limit --limit 2/min -j LOG --log-prefix "ip6tables-out: " --log-level 4
iptables -A LOG_IN -m limit --limit 2/min -j LOG --log-prefix "iptables-in: " --log-level 4
ip6tables -A LOG_IN -m limit --limit 2/min -j LOG --log-prefix "ip6tables-in: " --log-level 4
iptables -A LOG_OUT -j DROP
ip6tables -A LOG_OUT -j DROP
iptables -A LOG_IN -j DROP
ip6tables -A LOG_IN -j DROP
