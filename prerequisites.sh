
sudo apt -y update

#bluetooth
sudo apt install -y bluetooth pi-bluetooth bluez

#bleak
sudo apt install -y python3-pip
sudo pip3 install bleak

#influx
#https://pimylifeup.com/raspberry-pi-influxdb/
curl https://repos.influxdata.com/influxdata-archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/influxdb-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/influxdb-archive-keyring.gpg] https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt -y update
sudo apt install -y influxdb
sudo systemctl unmask influxdb
sudo systemctl enable influxdb
sudo systemctl start influxdb


influx -execute "CREATE DATABASE weather"
influx -database 'weather' -execute "CREATE USER weather WITH PASSWORD 'weather'"
influx -database 'weather' -execute "GRANT ALL ON weather to weather"

sudo apt install -y python3-influxdb


#grafana
#https://pimylifeup.com/raspberry-pi-grafana/
curl https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/grafana-archive-keyrings.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/grafana-archive-keyrings.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt -y update
sudo apt install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

