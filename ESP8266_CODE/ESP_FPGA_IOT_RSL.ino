//Bibliotecas
#include <ESP8266WiFi.h>  // Biblioteca para el control de WiFi
#include <PubSubClient.h> //Biblioteca para conexion MQTT

//////////// pines esp
///////                  ANTENA
//   PROGRAMADOR                  GND
//      gnd        Tx_FPGA      Rx_FPGA      R++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++000 x_FTDI

//      Tx_FTDI     3V3            NC         3V3

//////////    pines FPGA
///            SENSORES

///   NC    3V3    GND    Rx_esp     Tx_esp     NC


//Bibliotecas
#include <ESP8266WiFi.h>  // Biblioteca para el control de WiFi
#include <PubSubClient.h> //Biblioteca para conexion MQTT

//////////// pines esp
///////                  ANTENA
//   PROGRAMADOR                  GND
//      gnd        Tx_FPGA      Rx_FPGA      R++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++000 x_FTDI

//      Tx_FTDI     3V3            NC         3V3

//////////    pines FPGA
///            SENSORES

///   NC    3V3    GND    Rx_esp     Tx_esp     NC



//    S1    S1  GND  3V3

// el esp debe enviar 8 bytes
// 2 bytes kp
// 2 bytes kd
// 1 byte vel
// 1 byte sincronia

//////////// parametros del controlador
float Ts=0.005;

float kp=0.0;
float kd=0.0;

float kp_d;
float kd_d;

int KP_D;
int KD_D;

char KP_D_H=0;
char KP_D_L=0;

char KD_D_H=0;
char KD_D_L=0;

///////////   configuracion de sincronizacion esp-fpga
char vel=0;
char pa=0;
char fin=247;

//  configuración de tiempo de corrida prueba
int t = 5;
int i;

int flag_1=0;

int a_i=0;

int er = 0;
//
//String kp_data,kd_data,vel_data; // Se declara la variable en la cual se generará el mensaje completo  
//String a_dato;

//Datos de WiFi
const char* ssid = "INFINITUMj2tf";  // Aquí debes poner el nombre de tu red
const char* password = "38815dc9b3";  // Aquí debes poner la contraseña de tu red

//Datos del broker MQTT
const char* mqtt_server = "192.168.1.65"; // Si estas en una red local, coloca la IP asignada, en caso contrario, coloca la IP publica
IPAddress server(192,168,1,65);

// Objetos
WiFiClient espClient; // Este objeto maneja los datos de conexion WiFi
PubSubClient client(espClient); // Este objeto maneja los datos de conexion al broker

// Variables

long timeNow, timeLast; // Variables de control de tiempo no bloqueante
int data = 0; // Contador
int wait = 5000;  // Indica la espera cada 5 segundos para envío de mensajes MQTT

// Inicialización del programa
void setup() {
  // Iniciar comunicación serial

  Serial.begin(9600);
  Serial.setTimeout(10);
  delay(10000);
 
 
  WiFi.begin(ssid, password); // Esta es la función que realiz la conexión a WiFi
 
  while (WiFi.status() != WL_CONNECTED) { // Este bucle espera a que se realice la conexión
     delay (5);
  }

  delay (1000); // Esta espera es solo una formalidad antes de iniciar la comunicación con el broker

  // Conexión con el broker MQTT
  client.setServer(server, 1883); // Conectarse a la IP del broker en el puerto indicado
  client.setCallback(callback); // Activar función de CallBack, permite recibir mensajes MQTT y ejecutar funciones a partir de ellos
  delay(1500);  // Esta espera es preventiva, espera a la conexión para no perder información
}// fin del void setup ()

// Cuerpo del programa, bucle principal
void loop() {
  
  //Verificar siempre que haya conexión al broker
  if (!client.connected()) {
    reconnect();  // En caso de que no haya conexión, ejecutar la función de reconexión, definida despues del void setup ()
  }// fin del if (!client.connected())
  client.loop(); // Esta función es muy importante, ejecuta de manera no bloqueante las funciones necesarias para la comunicación con el broker
byte mqttdata[13];


//////////////////////Adquisición de datos de la FPGA al ESP/////////////////////////////////////////////////////////
 if (Serial.available() > 0)
   {
      Serial.readBytesUntil(fin,mqttdata,13);
      if(mqttdata[1] > 127 )
      {
        er = mqttdata[1] - 256;
      }
    String json="{\"posicion\":"+String(mqttdata[0])+",\"error\":"+String(er)+",\"ui\":"+String(mqttdata[2])+",\"ud\":"+String(mqttdata[3])+",\"s1\":"+String(mqttdata[4])+",\"s2\":"+String(mqttdata[5])+",\"s3\":"+String(mqttdata[6])+",\"s4\":"+String(mqttdata[7])+",\"s5\":"+String(mqttdata[8])+",\"s6\":"+String(mqttdata[9])+",\"s7\":"+String(mqttdata[10])+",\"s8\":"+String(mqttdata[11])+"}";
    int str_len = json.length() + 1;//Se calcula la longitud del string
    char char_array[str_len];//Se crea un arreglo de caracteres de dicha longitud
    json.toCharArray(char_array, str_len);//Se convierte el string a char array
    client.publish("Seguidor/delinea/capstone",char_array); // Esta es la función que envía los datos por MQTT, especifica el tema y el valor
  }
  
  if (flag_1 == 1)
  {
 
  kp_d=(kp + kd/Ts)*32;
  kd_d=65536-(kd/Ts)*32;

  KP_D = 0xFF00&(int)kp_d;
  KP_D_H = KP_D>>8;
  KP_D_L = 0x00FF&(int)kp_d;
 
 
  KD_D = 0xFF00&(int)kd_d;
  KD_D_H = KD_D>>8;
  KD_D_L = 0x00FF&(int)kd_d;
    
  Serial.write(KP_D_H);
  Serial.write(KP_D_L);
 
 
  Serial.write(KD_D_H);
  Serial.write(KD_D_L);
 
  Serial.write(vel);
  Serial.write(fin);

    flag_1 =0;
    }

}// fin del void loop ()


// Esta función permite tomar acciones en caso de que se reciba un mensaje correspondiente a un tema al cual se hará una suscripción
void callback(char* topic, byte* message, unsigned int length) {

  
  String kp_data,kd_data,vel_data; // Se declara la variable en la cual se generará el mensaje completo  
  String a_dato;

  // Concatenar los mensajes recibidos para conformarlos como una varialbe String
 
 
  for (int i = 0; i < length; i++) 
  
  {  // Se imprime y concatena el mensaje
       
      //messageTemp+= (char)message[i];
      a_dato=(char)message[i];

      if (a_dato == ",")
      {
        a_i=a_i+1;
        }
       
      if(a_dato != "," && a_i==0)
        {
          kp_data+=a_dato;
          }
         
       if(a_dato != "," && a_i==1)
        {
          kd_data+=a_dato;
        }
   

       if (a_dato != "," && a_i==2)
        {
          vel_data+=a_dato;
          }
  }
  a_i=0;
  flag_1 = 1;
  kp=kp_data.toFloat();
  kd=kd_data.toFloat();
  vel=vel_data.toInt();

 
}// fin del void callback


// Función para reconectarse
void reconnect() {
  // Bucle hasta lograr conexión
  while (!client.connected()) { // Pregunta si hay conexión

    // Intentar reconexión
    if (client.connect("ESP32CAMClient")) { //Pregunta por el resultado del intento de conexión

      client.subscribe("seguidor/linea/kp"); // Esta función realiza la suscripción al tema
    }// fin del  if (client.connect("ESP32CAMClient"))
    else {  //en caso de que la conexión no se logre

      // Espera de 5 segundos bloqueante
      delay(5000);
    }// fin del else
  }// fin del bucle while (!client.connected())
}// fin de void reconnect(
//    S1    S1  GND  3V3

// el esp debe enviar 8 bytes
// 2 bytes kp
// 2 bytes kd
// 1 byte vel
// 1 byte sincronia

//////////// parametros del controlador
float Ts=0.005;

float kp=0.0;
float kd=0.0;

float kp_d;
float kd_d;

int KP_D;
int KD_D;

char KP_D_H=0;
char KP_D_L=0;

char KD_D_H=0;
char KD_D_L=0;

///////////   configuracion de sincronizacion esp-fpga
char vel=0;
char pa=0;
char fin=247;

//  configuración de tiempo de corrida prueba
int t = 5;
int i;

int flag_1=0;

int a_i=0;

int er = 0;
//
//String kp_data,kd_data,vel_data; // Se declara la variable en la cual se generará el mensaje completo  
//String a_dato;

//Datos de WiFi
const char* ssid = "INFINITUMj2tf";  // Aquí debes poner el nombre de tu red
const char* password = "38815dc9b3";  // Aquí debes poner la contraseña de tu red

//Datos del broker MQTT
const char* mqtt_server = "192.168.1.65"; // Si estas en una red local, coloca la IP asignada, en caso contrario, coloca la IP publica
IPAddress server(192,168,1,65);

// Objetos
WiFiClient espClient; // Este objeto maneja los datos de conexion WiFi
PubSubClient client(espClient); // Este objeto maneja los datos de conexion al broker

// Variables

long timeNow, timeLast; // Variables de control de tiempo no bloqueante
int data = 0; // Contador
int wait = 5000;  // Indica la espera cada 5 segundos para envío de mensajes MQTT

// Inicialización del programa
void setup() {
  // Iniciar comunicación serial

  Serial.begin(9600);
  Serial.setTimeout(10);
  delay(10000);
 
 
  WiFi.begin(ssid, password); // Esta es la función que realiz la conexión a WiFi
 
  while (WiFi.status() != WL_CONNECTED) { // Este bucle espera a que se realice la conexión
     delay (5);
  }

  delay (1000); // Esta espera es solo una formalidad antes de iniciar la comunicación con el broker

  // Conexión con el broker MQTT
  client.setServer(server, 1883); // Conectarse a la IP del broker en el puerto indicado
  client.setCallback(callback); // Activar función de CallBack, permite recibir mensajes MQTT y ejecutar funciones a partir de ellos
  delay(1500);  // Esta espera es preventiva, espera a la conexión para no perder información
}// fin del void setup ()

// Cuerpo del programa, bucle principal
void loop() {
  
  //Verificar siempre que haya conexión al broker
  if (!client.connected()) {
    reconnect();  // En caso de que no haya conexión, ejecutar la función de reconexión, definida despues del void setup ()
  }// fin del if (!client.connected())
  client.loop(); // Esta función es muy importante, ejecuta de manera no bloqueante las funciones necesarias para la comunicación con el broker
byte mqttdata[13];


//////////////////////Adquisición de datos de la FPGA al ESP/////////////////////////////////////////////////////////
 if (Serial.available() > 0)
   {
      Serial.readBytesUntil(fin,mqttdata,13);
      if(mqttdata[1] > 127 )
      {
        er = mqttdata[1] - 256;
      }
    String json="{\"posicion\":"+String(mqttdata[0])+",\"error\":"+String(er)+",\"ui\":"+String(mqttdata[2])+",\"ud\":"+String(mqttdata[3])+",\"s1\":"+String(mqttdata[4])+",\"s2\":"+String(mqttdata[5])+",\"s3\":"+String(mqttdata[6])+",\"s4\":"+String(mqttdata[7])+",\"s5\":"+String(mqttdata[8])+",\"s6\":"+String(mqttdata[9])+",\"s7\":"+String(mqttdata[10])+",\"s8\":"+String(mqttdata[11])+"}";
    int str_len = json.length() + 1;//Se calcula la longitud del string
    char char_array[str_len];//Se crea un arreglo de caracteres de dicha longitud
    json.toCharArray(char_array, str_len);//Se convierte el string a char array
    client.publish("Seguidor/delinea/capstone",char_array); // Esta es la función que envía los datos por MQTT, especifica el tema y el valor
  }
  
  if (flag_1 == 1)
  {
 
  kp_d=(kp + kd/Ts)*32;
  kd_d=65536-(kd/Ts)*32;

  KP_D = 0xFF00&(int)kp_d;
  KP_D_H = KP_D>>8;
  KP_D_L = 0x00FF&(int)kp_d;
 
 
  KD_D = 0xFF00&(int)kd_d;
  KD_D_H = KD_D>>8;
  KD_D_L = 0x00FF&(int)kd_d;
    
  Serial.write(KP_D_H);
  Serial.write(KP_D_L);
 
 
  Serial.write(KD_D_H);
  Serial.write(KD_D_L);
 
  Serial.write(vel);
  Serial.write(fin);

    flag_1 =0;
    }

}// fin del void loop ()


// Esta función permite tomar acciones en caso de que se reciba un mensaje correspondiente a un tema al cual se hará una suscripción
void callback(char* topic, byte* message, unsigned int length) {

  
  String kp_data,kd_data,vel_data; // Se declara la variable en la cual se generará el mensaje completo  
  String a_dato;

  // Concatenar los mensajes recibidos para conformarlos como una varialbe String
 
 
  for (int i = 0; i < length; i++) 
  
  {  // Se imprime y concatena el mensaje
       
      //messageTemp+= (char)message[i];
      a_dato=(char)message[i];

      if (a_dato == ",")
      {
        a_i=a_i+1;
        }
       
      if(a_dato != "," && a_i==0)
        {
          kp_data+=a_dato;
          }
         
       if(a_dato != "," && a_i==1)
        {
          kd_data+=a_dato;
        }
   

       if (a_dato != "," && a_i==2)
        {
          vel_data+=a_dato;
          }
  }
  a_i=0;
  flag_1 = 1;
  kp=kp_data.toFloat();
  kd=kd_data.toFloat();
  vel=vel_data.toInt();

 
}// fin del void callback


// Función para reconectarse
void reconnect() {
  // Bucle hasta lograr conexión
  while (!client.connected()) { // Pregunta si hay conexión

    // Intentar reconexión
    if (client.connect("ESP32CAMClient")) { //Pregunta por el resultado del intento de conexión

      client.subscribe("seguidor/linea/kp"); // Esta función realiza la suscripción al tema
    }// fin del  if (client.connect("ESP32CAMClient"))
    else {  //en caso de que la conexión no se logre

      // Espera de 5 segundos bloqueante
      delay(5000);
    }// fin del else
  }// fin del bucle while (!client.connected())
}// fin de void reconnect(
