import paho.mqtt.client as mqtt
import configparser
import json
import RPi.GPIO as GPIO

config = configparser.ConfigParser()
config.read('config.ini')

broker = config['MQTT']
# Define Variables
MQTT_BROKER = broker['broker']
MQTT_PORT = broker['port']
MQTT_KEEPALIVE_INTERVAL = 45
MQTT_TOPIC = "micData"

print("MQTT BROKER: ", MQTT_BROKER)
print ("MQTT PORT: ", MQTT_PORT)

#source: https://circuitdigest.com/microcontroller-projects/raspberry-pi-servo-motor-control
GPIO.setwarnings(False)          # do not show any warnings
GPIO.setmode (GPIO.BOARD)            # programming the GPIO by BCM pin numbers. (like PIN29 as‘GPIO5’)
GPIO.setup(7,GPIO.OUT)            # initialize GPIO19 as an output
p = GPIO.PWM(7,50)              # GPIO19 as PWM output, with 50Hz frequency
p.start(7.5)                   # generate PWM signal with 7.5% duty cycle
#servo position to 0º =  p.ChangeDutyCycle(2.5)
#servo position to 180º =  p.ChangeDutyCycle(12.5)

motor_angle = 0
# Define on_connect event Handler
def on_connect(mosq, obj, rc):
    #Subscribe to a the Topic
    mqttc.subscribe(MQTT_TOPIC, 0)

# Define on_subscribe event Handler
def on_subscribe(mosq, obj, mid, granted_qos):
    print ("Subscribed to MQTT Topic")

# Define on_message event Handler
def on_message(mqttc, userdata, message):
    msg = (str(message.payload.decode("utf-8")))
    print(msg)
    data = json.loads(msg)
    for item in data["mics"]:
        if item["state"] == 1:
            motor_angle = item["angle"]
            print("Motor angle: ", motor_angle)
    duty_cycle_value = 2.5 + (10 / 180) * motor_angle
    print("Duty cycle value: ", duty_cycle_value)
    p.ChangeDutyCycle(duty_cycle_value)

# Initiate MQTT Client
mqttc = mqtt.Client()

# Register Event Handlers
mqttc.on_message = on_message
mqttc.on_connect = on_connect
mqttc.on_subscribe = on_subscribe

# Connect with MQTT Broker
mqttc.connect(MQTT_BROKER)

# Continue the network loop
mqttc.loop_forever()