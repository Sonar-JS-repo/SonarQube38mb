# Sonar Scanner

- Sonarqube Scanner or a sonar-scanner performs the code analysis, generates the results and sends the results to SonarQube. It is a generic, CLI scanner, and you must provide configurations that list the locations of your source file, test files, SonarQube host and URL with domain name.

## Install SonarQube on Ubuntu 22.04 LTS

```bash
  sysctl -w vm.max_map_count=524288
  sysctl -w fs.file-max=131072
  ulimit -n 131072
  ulimit -u 8192
```

To Increase the vm.max_map_count kernal ,file discriptor and ulimit permanently . Open the below config file and Insert the below value as shown below,

```bash
  sudo nano /etc/security/limits.conf
```

/etc/security/limits.conf

```bash
  sonarqube - nofile 65536
  sonarqube - nproc 4096
```

Before installing, Lets update and upgrade System Packages

```bash
  sudo apt-get update
  sudo apt-get upgrade
```

Install wget and unzip package

```bash
  sudo apt-get install wget unzip -y
```

Install OpenJDK and JRE 11 using following command,

```bash
  sudo apt-get install openjdk-17-jdk -y
  sudo apt-get install openjdk-17-jre -y
```

To set default JDK or switch to OpenJDK enter below command,

```bash
  sudo update-alternatives --config java
  java -version
```

Add and download the PostgreSQL Repo

```bash
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

  wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
```

Install the PostgreSQL database Server by using following command,

```bash
  sudo apt-get -y install postgresql postgresql-contrib
```

Start PostgreSQL Database server

```bash
  sudo systemctl start postgresql
```

Enable it to start automatically at boot time.

```bash
  sudo systemctl enable postgresql
  sudo systemctl status postgresql
```

Change the password for the default PostgreSQL user.

```bash
  sudo passwd postgres
```

Switch to the postgres user.

```bash
  su - postgres
```

Create a new user by typing:

```bash
  createuser sonar
```

Switch to the PostgreSQL shell.

```bash
  psql
```

Set a password for the newly created user for SonarQube database.

```bash
  ALTER USER sonar WITH ENCRYPTED password 'sonar';
```

Create a new database for PostgreSQL database by running:

```bash
  CREATE DATABASE sonarqube OWNER sonar;
```

grant all privileges to sonar user on sonarqube Database.

```bash
  grant all privileges on DATABASE sonarqube to sonar;
```

Exit from the psql shell:

```bash
 \q
```

Switch back to the sudo user by running the exit command.

```bash
exit
```

Download sonaqube installer files archive To download latest version of visit SonarQube download page.

```bash
 cd /tmp
```

```bash
 sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
```

Unzip the archeve setup to **/opt** directory

```bash
 sudo unzip sonarqube-9.9.0.65466.zip -d /opt
```

Move extracted setup to **/opt/sonarqube** directory

```bash
 sudo mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
```

Create a group as sonar

```bash
  sudo groupadd sonar
```

Now add the user with directory access

```bash
 sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar
 sudo chown sonar:sonar /opt/sonarqube -R
```

Open the SonarQube configuration file using your favorite text editor.

```bash
 sudo nano /opt/sonarqube/conf/sonar.properties
```

Find the following lines.

```bash
 #sonar.jdbc.username=
 #sonar.jdbc.password=
```

Uncomment and Type the PostgreSQL Database username and password which we have created in above steps and add the postgres connection string.

- **/opt/sonarqube/conf/sonar.properties**

```bash
  sonar.jdbc.username=sonar
  sonar.jdbc.password=sonar
  sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
```

Edit the sonar script file and set **RUN_AS_USER**

```bash
  sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh
```

**/opt/sonarqube/bin/linux-x86-64/sonar.sh**

```bash
  RUN_AS_USER=sonar
```

Now to start SonarQube we need to do following: Switch to sonar user

```bash
 sudo su sonar
 bash
```

Move to the script directory

```bash
 cd /opt/sonarqube/bin/linux-x86-64/
```

Run the script to start SonarQube

```bash
 ./sonar.sh start
```

**Output**

```bash
  /usr/bin/java
  Starting SonarQube...
  SonarQube is already running.
```

To check if sonaqube is running enter below command,

```bash
  ./sonar.sh status
  ./sonar.sh stop
```

To check sonarqube logs, navigate to /opt/sonarqube/logs/sonar.log directory

```bash
 tail /opt/sonarqube/logs/sonar.log
```

Create a systemd service file for SonarQube to run as System Startup.

```bash
 sudo nano /etc/systemd/system/sonar.service
```

Add the below lines, **/etc/systemd/system/sonar.service**

```bash
 [Unit]
 Description=SonarQube service
 After=syslog.target network.target

 [Service]
 Type=forking

 ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
 ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

 User=sonar
 Group=sonar
 Restart=always

 LimitNOFILE=65536
 LimitNPROC=4096

 [Install]
 WantedBy=multi-user.target
```

Save and close the file. Now stop the sonarqube script earlier we started to run using as daemon. Start the Sonarqube daemon by running:

```bash
 sudo systemctl start sonar
```

Enable the SonarQube service to automatically at boot time System Startup.

```bash
 sudo systemctl enable sonar
```

check if the sonarqube service is running,

```bash
 sudo systemctl status sonar
```

To access the SonarQube using browser type server IP followed by port 9000.

```bash
http://server_IP:9000 OR http://localhost:9000
```

# Integration Sonarqube in Jenkins for Maven

```bash
cd /tmp

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip

unzip sonar-scanner-cli-4.8.0.2856-linux.zip

sudo mv sonar-scanner-cli-4.8.0.2856-linux /opt/sonar-scanner

sudo nano /opt/sonar-scanner/conf/sonar-scanner.properties

#----- Default SonarQube server
sonar.host.url=http://192.168.1.5:9000
#----- Default source code encoding
sonar.sourceEncoding=UTF-8

nano /etc/profile.d/sonar-scanner.sh
```

