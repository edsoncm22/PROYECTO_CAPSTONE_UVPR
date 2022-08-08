![CAPSTONE](IMAGENES/DESCRIPCION_GENERAL.png)
# Monitoreo remoto de variables para optimización de un control de velocidad de un vehículo.

## Universidad Veracruzana                                                                                                                                     
Facultad de Ingeniería en Electronica y Comunicaciones, Región Poza Rica - Tuxpan

## Equipo 18:
* Dr. Miguel Ángel Rojas Hernández
* Dr. Edson Eduardo Cruz Miguel
* Mtro. Omar Alenxander Barra Vázquez

## Resumen
![CAPSTONE](IMAGENES/LAMBUPDUINO.png)

El presente proyecto tiene como finalidad la implementación de un controlador para el seguimiento de trayectorias de un robot seguidor de línea y el monitoreo de variables de cada sensor involucrado para tener el histórico y realizar la toma de decisiones sobre los parámetros del controlador a través del uso del IoT. Para el control del robot se empleo una FPGA open source, para el envío de la información se utilizó un ESP8266 y como servidor se utilizó una Raspberry pi 4. Como observaciones importantes la pista se diseño con un fonde blanco y la trayectoria es una línea negra de 2.5cm de ancho aproximadamente. La pista cuenta con rectas, curvas y vueltas en forma de triángulo para observar el desempeño del controlador PD.

* En este enlace [youtube video](https://www.youtube.com/watch?v=SAdCPYdH9SM) puedes verlo en accion!

## MATERIALES
![CAPSTONE](IMAGENES/MATERIALES.png)
* FPGA ICE40UP5K, se utiliza como el cerebro del robot. Aquí, se encuentran implementados los algoritmos de control, los módulos para el correcto funcionamiento de los sensores, así como los algoritmos para procesar la señal. Se implementaros los módulos PWM (Pulse Width Modulation) para la aplicación de la señal de control a los motores. También se implementó el protocolo de comunicación UART (Universal Asyncrhonous Receiver-Transmitter) para establecer la comunicación con el ESP8266.

* ESP8266, se empleo este microcontrolador de bajo consumo, facilidad de conexión inalámbrica y espacio reducido del robot seguidor. La ESP8266 se encarga de recibir las señales desde la FPGA a través del protocolo UART y enviarlas utilizando tecnología WIFI a un servidor implementado en la Raspberry Pi.

* Sensor QTR-8RC, son un conjunto de sensores de reflectancia ampliamente utilizado como sensor de línea. Este módulo contiene ocho pares de emisor y receptor de IR (fototransistor) espaciados uniformemente a intervalos de 0,375" (9,525 mm). Para usar un sensor, primero debe cargar el nodo de salida aplicando un voltaje a su pin de SALIDA. Luego puede leer la reflectancia retirando ese voltaje aplicado externamente en el pin de SALIDA y cronometrando el tiempo que tarda el voltaje de salida en decaer debido al fototransistor integrado. Un tiempo de decaimiento más corto es una indicación de una mayor reflexión. Algunas de las ventajas de emplear este sensor son que no se requiere un convertidor de analógico a digital, la lectura paralela.

* TB6612, el controlador de motor TB6612FNG puede controlar hasta dos motores de CC a una corriente constante de 1.2A (pico de 3.2A). Acepta señales de PWM de hasta 100kHz. Los pines de control aceptan voltajes mínimos de 2.7V y máximo de 5.5V. Tiene diodos de protección internos por lo que no es necesario implementarlos externamente.

* Micromotor pololu 10:1, este motorreductor es un motor de CC con escobillas de 6 V de alta potencia en miniatura con una caja de engranajes de metal de 9.96:1. Tiene una sección transversal de 10 × 12 mm y el eje de salida tiene 9 mm de largo y 3 mm de diámetro.

* Llantas para Seguidor de linea de alto desempeño, se muestran en Figura 9. Estas llantas están diseñadas para tener una máxima adherencia,  lo que las hace perfectas para competencias de robótica. Tienen un peso de 18 gramos por llanta y 2 cm de diámetro, rin de aluminio, con orificio de tornillo para sujetarlo al motor compatible con motores Pololu con eje de 3mm.

## Diseño de la PCB
El diseño del PCB se realizaron utilizando el software EasyEDA Designer, en el presente proyecto se encuentran los archivos json. En la siguiente figura se muestra el esquemático que se utilizó para la construcción del PCB del robot seguidor de línea. Cuenta con todos los elementos descritos en la sección anterior, además de reguladores de voltaje para acondicionar los niveles requeridos por cada dispositivo. En el caso de la FPGA un regulador de 5V y 3.3V. Para la parte lógica del puente H 3.3V, los sensores a 3.3V. Y 7.4V para la parte de potencia (alimentación del puente H).

![CAPSTONE](IMAGENES/ESQUEMATICO_PCB.jpg)


## Implementación en FPGA

La implementación del sistema digital total consta de 5 partes importantes:
1. La lectura de los sensores.
2. El algoritmo de promedio ponderado.
3. El controlador PD.
4. Los módulos PWM.
5. Protocolo UART.

![CAPSTONE](IMAGENES/RTL_FPGA.png)

* El módulo para el control y adquisición del sensor QTR-8RC se implementó bajo la siguiente lógica: encender los LED IR, configurar la línea de E/S en una salida y poner en alta impedancia, esperar al menos 10 μs para que aumente la salida del sensor. Configurar la línea de E/S en una entrada (alta impedancia). Y finalmente medir el tiempo que tarda el voltaje en decaer esperando que la línea de E/S baje y apague los LED IR. De esta manera podemos determinar cuando el robot se encuentra sobre la línea negra. 

* Con el módulo anterior, se cuenta con el valor de reflectancia de cada sensor, sin embargo, se requiere de un valor para posicionar el robot sobre la línea negra, para esto se describe el algoritmo de promedio ponderado. El princi´pal inconveniente en dispositivos FPGA es la implem,entación de operaciones como cocientes, para ello se realizó una implementación de la técnica de Registrto de Aproximaciones Sucesivas, $\frac{A}{B}=X$, donde $A$ y $B$ son conocidas y $X$ es el valor que se desea encontrar. Esta expresión puede ser escrita de la forma $A-BX=0$, por lo tanto es posible variar el valor de $X$ hasta encontrar el valor de esa expresión.

* El objetivo principal es mantener al robot al centro de la línea negra. La arquitectura digital diseñada para el controlador PD se sentra en la expresión $u[nTs] = b_0 e[nT_s] + b_1 e[nT_s - Ts]$, donde $b_0 = k_p + \frac{k_d}{Ts}$ y $b_1=-\frac{k_d}{Ts}$. En la siguiente figura, se muestra los módulos descritos para este algoritmo. Tiene una entrada en punto fijo con un formato 16.0 para la señal del error y para las ganancias digitales un formato 11.5. La señal de control tiene un formato 16.0, sin embargo, se realiza un recorte a 8 bits.

![CAPSTONE](IMAGENES/CONTROL_PD.png)

* La implementación de los módulos PWM se realizaron para la aplicación de la señal de control a los motores. Estos módulos fueron construidos a partir de un contador y un comparador menor que. Esta señal es la entrada del puente H TB6612 que se encarga de realizar la amplificación de potencia y entregar un voltaje a los motores. La salida del módulo CONTROL_PD es una señal que va de -100 a 100, misma que entra a los módulos PWM. Un 100% representa la máxima entrada al motor que son 6V.

* El módulo UART se encarga de realizar la comunicación entre el ESP8266. Recibe la configuración del controlador PD y la velocidad a la que se desplaza el robot, mismas que son enviadas desde el dashboard. Este módulo también se encarga de enviar al ESP8266 los valores de cada sensor, la posición, la error y señal de control aplicada a cada motor en tiempo real.

Para la implementación del sistema total se emplearon herramientas libres, sin embargo, los módulos descritos pueden utilizarse para cualquier familia de FPGA y por consiguiente en cualquier software del fabricante.

## Implementación en ESP8266
El ESP8266 se encarga de realizar la cominicación entre la FPGA. Recibe los datos de los sensores, la posición y error del robot, así como las señales de control aplicadas a cada motor. Recibe 12 variables en formato entero de 8 bits (1 byte) de la FPGA y las manda a la base de datos a traves de WIFI. También se encarga de recibir los datos caonfigurados desde dashboard, es decir, recibe las ganancias del controlador y velocidad del robot que se genenran en la GUI (Interfaz Gráfica de Usuario) en el dashboard. Posteriormente, manipula estas variables recibidas en cadena de caracteres y las decodifica en variables de 16 bits en formato punto fijo 11.5 (ganancias $b_0$ y $b_1$ del controlador PD digital) y la velocidad en formato entero de 8 bits para enviarlas a la FPGA. De esta forma es como mantiene una función muy importante en la aplicación IoT como traductor entre el robot y las interfaces desarrolladas en Node-Red y Grafana.

## Desarrollo en Node-Red

![CAPSTONE](IMAGENES/FLOW_NODE_RED.png)

El flow se divide en 2 partes, la primer sección se creo para manipular el dashboard desde un usuario remoto, donde es posible modificar las ganancias del controlador PD y la velocidad del robot. La parte superior que se muestra en el flow, son los slide que configuran dichas variables y un botón para enviar una sola vez los parámetros. En la parte inferior se tiene la recepción de los sensores, así como la extracción de cada uno para registrarla en la base de datos creada en mysql.

![CAPSTONE](IMAGENES/DASHBOARD_FPGA.jpeg)

Todas las variables se reciben como una cadena de caracteres y son convertidas en un objeto de json que posteriormente se envía a nuestra base de datos usando los nodos de mysql.

## Mysql

Para recibir los datos desde node red es necesario instalar y configurar mysql, el proceo de instalación de node-red en obuntu pueden consultarse en la plataforma del curso.

Una vez instalado se debe crear una base de datos usando el comando

```
CREATE DATABASE seguidor;
```

Accedemos a la base de datos

```
use seguidor; 
```

Se crea una tabla con los campos de los 12 sensores utilizados en el seguidor de linea

```
CREATE TABLE capstone(position INT, error INT, Ui INT, Ud INT,s1 INT, s2 INT, s3 INT, s4 INT, s5 INT,s6 INT, s7 INT, s8 INT);
```

accedemos a la base de datos

```
select * from capstone;
```

## Grafana
La implementación en Grafana se encarga de obtener los datos recibidos del ESP8266 como posición del robot, error, señal de control aplicada al motor derecho e izquierdo desde la base generada en mysql, posteriormente graficarlos y actulizarlos cada segundo.


![CAPSTONE](IMAGENES/GRAFANA.png)

