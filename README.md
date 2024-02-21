# otus-linux
Vagrantfile - для стенда урока 9 - Network

# Дано
Vagrantfile с начальным  построением сети
inetRouter
centralRouter
centralServer

тестировалось на virtualbox

# Планируемая архитектура
построить следующую архитектуру

Сеть office1
- 192.168.2.0/26      - dev
- 192.168.2.64/26    - test servers
- 192.168.2.128/26  - managers
- 192.168.2.192/26  - office hardware

Сеть office2
- 192.168.1.0/25      - dev
- 192.168.1.128/26  - test servers
- 192.168.1.192/26  - office hardware


Сеть central
- 192.168.0.0/28    - directors
- 192.168.0.32/28  - office hardware
- 192.168.0.64/26  - wifi

Схема сети - см. Pic_1

Итого должны получится следующие сервера
- inetRouter
- centralRouter
- office1Router
- office2Router
- centralServer
- office1Server
- office2Server

# Задание состоит из 2-х частей: теоретической и практической.

# Теоретическая часть
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети
- проверить нет ли ошибок при разбиении

# Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

# РЕШЕНИЕ

## Теоретическая часть

1. Свободные сети:

192.168.0.16/28
192.168.0.48/28
192.168.0.128/25
192.168.255.4/30
192.168.255.8/29
192.168.255.16/28
192.168.255.32/27
192.168.255.64/26
192.168.255.128/25

2. Посчитать сколько узлов в каждой подсети, включая свободные:
# Name	                 Network	        Netmask           Hosts
Directors	        192.168.0.0/28	        255.255.255.240	  14
	                192.168.0.16/28         255.255.255.240   14
Office hardware 	192.168.0.32/28	        255.255.255.240	  14
	                192.168.0.48/28	        255.255.255.240	  14
Wifi(mgt network)	192.168.0.64/26  	255.255.255.192	  62
	                192.168.0.128/25	255.255.255.128	  126
Dev	                192.168.2.0/26	        255.255.255.192	  62
Test	                192.168.2.64/26	        255.255.255.192	  62
Managers            	192.168.2.128/26	255.255.255.192	  62
Office hardware	        192.168.2.192/26	255.255.255.192	  62
Dev	                192.168.1.0/25	        255.255.255.128	  126
Test	                192.168.1.128/26	255.255.255.192	  62
Office           	192.168.1.192/26	255.255.255.192	  62
Inet — central	        192.168.255.0/30	255.255.255.252	  2
	                192.168.255.4/30	255.255.255.252	  2
	                192.168.255.8/29	255.255.255.248   6
                	192.168.255.16/28	255.255.255.240	  14
                   	192.168.255.32/27	255.255.255.224	  30
                 	192.168.255.64/26	255.255.255.192	  62
                       	192.168.255.128/25	255.255.255.128	  126


3. Указать broadcast адрес для каждой подсети

# Name	           Network	        Broadcast
Directors	   192.168.0.0/28	192.168.0.15
	           192.168.0.16/28	192.168.0.31
Office hardware    192.168.0.32/28	192.168.0.47
	           192.168.0.48/28	192.168.0.63
Wifi(mgt network)  192.168.0.64/26	192.168.0.127
	           192.168.0.128/25	192.168.0.255
Dev	           192.168.2.0/26	192.168.2.63
Test	           192.168.2.64/26	192.168.2.127
Managers	   192.168.2.128/26	192.168.2.191
Office hardware	   192.168.2.192/26	192.168.2.255
Dev	           192.168.1.0/25	192.168.1.127
Test	           192.168.1.128/26	192.168.1.191
Office	           192.168.1.192/26	192.168.1.255
Inet — central	   192.168.255.0/30	192.168.255.3
	           192.168.255.4/30	192.168.255.7
	           192.168.255.8/29	192.168.255.15
                   192.168.255.16/28	192.168.255.32
	           192.168.255.32/27	192.168.255.63
	           192.168.255.64/26	192.168.255.127
	           192.168.255.128/25	192.168.255.255


4. Ошибок при разбиении нет.



#№ Практическая часть

Развернут стенд с помощью Vagrant согласно структуре сети Pic_2.

# Проверка выхода в Интернет:
# vagrant@centralServer:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.0.1)  0.631 ms  0.605 ms  0.811 ms
 2  192.168.255.1 (192.168.255.1)  1.706 ms  1.694 ms  1.682 ms
 3  10.0.2.2 (10.0.2.2)  1.964 ms  1.847 ms  1.703 ms
 4  * * *
 5  * * *
 6  185.140.151.138 (185.140.151.138)  4.794 ms  3.147 ms 185.140.151.144 (185.140.151.144)  3.259 ms
 7  * * *
 8  72.14.209.89 (72.14.209.89)  25.969 ms  25.934 ms  26.192 ms
 9  * * *
10  108.170.227.78 (108.170.227.78)  45.566 ms 172.253.69.158 (172.253.69.158)  45.263 ms 108.170.250.33 (108.170.250.33)  46.649 ms
11  108.170.250.130 (108.170.250.130)  48.211 ms 108.170.250.66 (108.170.250.66)  48.459 ms *
12  142.251.238.84 (142.251.238.84)  105.229 ms 142.250.238.214 (142.250.238.214)  38.792 ms 172.253.66.116 (172.253.66.116)  55.797 ms
13  74.125.253.94 (74.125.253.94)  38.005 ms 142.250.235.62 (142.250.235.62)  39.192 ms 72.14.232.190 (72.14.232.190)  43.700 ms
14  142.250.210.45 (142.250.210.45)  38.740 ms 142.250.56.215 (142.250.56.215)  39.015 ms 172.253.51.239 (172.253.51.239)  38.626 ms
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  dns.google (8.8.8.8)  38.203 ms  39.670 ms *
vagrant@centralServer:~$ 

# vagrant@office1Server:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.2.129)  0.647 ms  0.742 ms  0.698 ms
 2  192.168.255.9 (192.168.255.9)  1.288 ms  1.211 ms  1.176 ms
 3  192.168.255.1 (192.168.255.1)  1.629 ms  1.614 ms  1.595 ms
 4  10.0.2.2 (10.0.2.2)  1.754 ms  1.923 ms  2.105 ms
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  72.14.209.89 (72.14.209.89)  26.599 ms  26.587 ms  26.575 ms
10  * * *
11  108.170.250.129 (108.170.250.129)  27.646 ms  27.626 ms 108.170.250.33 (108.170.250.33)  23.889 ms
12  * 108.170.250.34 (108.170.250.34)  24.808 ms 108.170.250.99 (108.170.250.99)  23.885 ms
13  72.14.234.54 (72.14.234.54)  40.341 ms 142.250.238.214 (142.250.238.214)  39.051 ms *
14  172.253.65.82 (172.253.65.82)  38.837 ms 72.14.235.69 (72.14.235.69)  40.582 ms 74.125.253.109 (74.125.253.109)  54.175 ms
15  216.239.49.115 (216.239.49.115)  38.499 ms 142.250.210.103 (142.250.210.103)  62.948 ms 216.239.46.243 (216.239.46.243)  42.359 ms
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  dns.google (8.8.8.8)  40.847 ms  38.377 ms  38.846 ms
vagrant@office1Server:~$ 

# vagrant@office2Server:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.1.1)  0.536 ms  0.418 ms  0.403 ms
 2  192.168.255.5 (192.168.255.5)  0.983 ms  0.970 ms  0.957 ms
 3  192.168.255.1 (192.168.255.1)  1.487 ms  1.452 ms  1.435 ms
 4  10.0.2.2 (10.0.2.2)  1.798 ms  1.702 ms  1.687 ms
 5  * * *
 6  * * *
 7  * * *
 8  * * 185.140.148.155 (185.140.148.155)  29.679 ms
 9  72.14.209.89 (72.14.209.89)  23.659 ms  23.626 ms  23.612 ms
10  * * *
11  72.14.233.94 (72.14.233.94)  24.520 ms 108.170.227.74 (108.170.227.74)  23.455 ms 108.170.250.129 (108.170.250.129)  23.202 ms
12  108.170.250.51 (108.170.250.51)  23.613 ms 108.170.250.99 (108.170.250.99)  23.592 ms 108.170.250.66 (108.170.250.66)  24.709 ms
13  142.251.238.82 (142.251.238.82)  40.802 ms 142.250.238.138 (142.250.238.138)  38.841 ms *
14  142.250.235.74 (142.250.235.74)  40.270 ms 142.250.235.62 (142.250.235.62)  44.269 ms 72.14.235.69 (72.14.235.69)  41.326 ms
15  209.85.246.111 (209.85.246.111)  39.483 ms 216.239.42.21 (216.239.42.21)  39.927 ms 172.253.51.245 (172.253.51.245)  40.477 ms
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  dns.google (8.8.8.8)  38.331 ms  40.152 ms  39.903 ms
vagrant@office2Server:~$ 


