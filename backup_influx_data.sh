influxd backup -portable ./influx_backup/metadata
influxd backup -portable -database weather ./influx_backup/data/weather
rsync -avz influx_backup abstractdog@abstractdog.com:.

