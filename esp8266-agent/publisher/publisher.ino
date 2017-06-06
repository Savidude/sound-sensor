#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
#include <PubSubClient.h>

// Replace with your network credentials and mqtt settings
const char* ssid = "";
const char* password = "";
const char* mdnsName = "nodemcu";
const char* mqttServer = "";
const char* mqttUser = "";
const char* mqttPassword = "";
const char* mqttPubTopic = "micData";

WiFiClient espClient;
PubSubClient client(espClient);
MDNSResponder mdns;

void setup() {
  //Connecting nodemcu to WiFi  
  WiFi.begin(ssid, password);
  Serial.begin(115200); 
  Serial.println("Setting up");
  delay(5000);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.print("Connected to ");  Serial.println(ssid);
  Serial.print("IP address: ");   Serial.println(WiFi.localIP());

  client.setServer(mqttServer, 1883);
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP8266Client", mqttUser, mqttPassword)) {
      Serial.println("connected");
//      client.publish(mqttPubTopic, "Connected");  //publishing its status
//      client.subscribe(mqttSubTopic);             //subscribing to topic
    }
    else {
      Serial.print("Failed, state="); Serial.print(client.state());
      Serial.println(" will try again in 5 seconds...");
      delay(5000);
    }
  }
}

void loop() {
  if (!client.connected())
    reconnect();
  client.loop();
}
