# Домашнее задание к занятию "Zabbix 1" - Зеленкин С.С.
 
### Задание 1
Установите Zabbix Server с веб-интерфейсом.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите PostgreSQL. Для установки достаточна та версия, что есть в системном репозитороии Debian 11.
3. Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
4. Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.

#### Требования к результатам 
1. Прикрепите в файл README.md скриншот авторизации в админке.
2. Приложите в файл README.md текст использованных команд в GitHub.

### Решение 1

Предварительно создал .tf для автоматизации запуска ВМ в Яндекс.Облаке
Позднее можно и заббикс перевести на автоматическую развертку, но пока вручную...

![Скриншот-1](https://github.com/zelenkins/zabbix_hw/blob/main/img/z1.png)

#### Команды запуска
```bash
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_6.0+debian11_all.deb
sudo dpkg -i zabbix-release_latest_6.0+debian11_all.deb
sudo apt update
sudo apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2
```

---

### Задание 2 

Установите Zabbix Agent на два хоста.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите Zabbix Agent на 2 вирт.машины, одной из них может быть ваш Zabbix Server.
3. Добавьте Zabbix Server в список разрешенных серверов ваших Zabbix Agentов.
4. Добавьте Zabbix Agentов в раздел Configuration > Hosts вашего Zabbix Servera.
5. Проверьте, что в разделе Latest Data начали появляться данные с добавленных агентов.

#### Требования к результатам
1. Приложите в файл README.md скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу
2. Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером
3. Приложите в файл README.md скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные.
4. Приложите в файл README.md текст использованных команд в GitHub


### Решение 2
##### Configuration > Hosts
![Скриншот-2](https://github.com/zelenkins/zabbix_hw/blob/main/img/z2.png)

##### Скриншот лога zabbix agent
Здесь возник вопрос. Я четко вижу, что сервер работает с агентом, метрики приходят, агент активен (скрины ниже по заданию). Но в логах есть "Active check configuration update started to fail". Конфигурация менялась - только добавление ip сервера. Почему так?
![Скриншот-3](https://github.com/zelenkins/zabbix_hw/blob/main/img/z3.png)

##### Скриншот раздела Monitoring > Latest data
![Скриншот-4](https://github.com/zelenkins/zabbix_hw/blob/main/img/z4.png)
![Скриншот-5](https://github.com/zelenkins/zabbix_hw/blob/main/img/z5.png)

##### Команды 
```bash
sudo wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_6.0+debian11_all.deb
sudo dpkg -i zabbix-release_latest_6.0+debian11_all.deb
sudo apt update
sudo apt install zabbix-agent
systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent
```