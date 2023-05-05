import asyncio
from bleak import BleakClient
from influxdb import InfluxDBClient

ARDUINO_MAC_ADDRESS = "E0:02:72:87:21:0E"
MODEL_NBR_UUID = "00002a00-0000-1000-8000-00805f9b34fb"
TEMPERATURE_ATTR_UUID = "00002a6e-0000-1000-8000-00805f9b34fb"
HUMIDITY_ATTR_UUID = "00002a6f-0000-1000-8000-00805f9b34fb"

async def main(address):
    async with BleakClient(address) as client:
        model_number = await client.read_gatt_char(MODEL_NBR_UUID)
        print("Model Number: {0}".format("".join(map(chr, model_number))))
        temperature = await client.read_gatt_char(TEMPERATURE_ATTR_UUID)
        print("Temperature: {0}°C".format(int.from_bytes(temperature, byteorder='little', signed=False) / 100))
        humidity = await client.read_gatt_char(HUMIDITY_ATTR_UUID)
        print("Humidity: {0}%".format(int.from_bytes(humidity, byteorder='little', signed=False) / 100))

        weather_data = [
          {
            "measurement" : "weather_measurement",
            "fields" : {
              "temperature": float(int.from_bytes(temperature, byteorder='little', signed=False) / 100),
              "humidity": float(int.from_bytes(humidity, byteorder='little', signed=False) / 100),
           }
          }
        ]
        client = InfluxDBClient('localhost', 8086, 'weather', 'weather', 'weather')
        try:
          client.write_points(weather_data)
        except Exception as e:
          print(e)

asyncio.run(main(ARDUINO_MAC_ADDRESS))
