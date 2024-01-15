/*Este código es para escuchar, mediante Processing, lo que se envíe por puerto serial en el Arduino. Es nuestro propio monitor serial*/
// Modificado por STEMXarq

//Importación de la librería para crear puertos seriales en Processing.
//RECUERDA: Para importar librerías, Sketch -> Import Library...
import processing.serial.*;

//Instancia port a la clase Serial.
Serial port;
//Variable de texto para recibir lo que se escuche del puerto serial.
String mensaje = null;

void setup(){
/* Serial(parent, portName, baudRate, parity, dataBits, stopBits) 
   https://processing.org/reference/libraries/serial/Serial.html
  
   Inicializamos nuestra instancia de la clase Serial con tres de los parámetros anteriores.
   'this' parent, se refiere a este 'momento' en Processing (No preocuparse por esta parte).
   "COM3" es el nombre del puerto serial a escuchar. 
   /dev/cua0 (dispositivo entrada), /dev/ttyS0 (COM1) ((salida) direccion 0x3f8 IRQ 4; 
   0, 1, 2, 3... es el número del puerto serie -1.
   9600 baudios (caracteres por segundo). Sincronizar esta tasa/velocidad con Arduino.
*/

  port = new Serial(this, "COM3", 9600);

  //Definimos un tamaño de ventana de dibujo de 800x600 pixeles.
  size(800,600);
}

void draw(){
  
  //"Si hay algo en el puerto serial". En esta línea estamos accediendo a la función de escucha dentro de la clase Serial, por medio de nuestra copia personalizada 'port'.
  if(port.available()>0){
    //Igualamos a nuestra variable de texto a lo que nos devuelva la función readStringUntil. 
    //Dicha función lee todo lo que haya en el puerto serial hasta que encuentre un 'Enter', representado por el caracter especial '\n'.
    //Cabe destacar que este 'Enter' es el mismo que el Arduino escribe al final de cada línea por usar Serial.println
    mensaje = port.readStringUntil('\n');
  }
  
  //Si el mensaje recibido por serial no está vacío.
  if(mensaje!=null){
    //Separamos el mensaje por medio del separador que concatenamos en Arduino, el caracter ','.
    //la función split nos devuelve 4 piezas separadas, las cuales son piezas de texto. La función int() las convierte en números. Ahora tenemos 4 números.
    //Esto cuatro números los guardamos todos al mismo tiempo en una sola variable tipo arreglo, la cual identificamos por los corchetes cuadrados.
    //Las variables tipo arreglo, son variables que guardan varios valores del mismo tipo, al mismo tiempo.
    int[] datosVuelo = int(split(mensaje,','));
    //Accedemos a los valores guardados en el arreglo, por medio de índices. En programación, el primer índice siempre es el cero.
    //En Arduino, definimos nuestro mensaje como i+","+T+","+h+","+lat..., así que el índice cero, hace referencia al valor índice, y el índice uno hace referencia a la temperatura. 
    println(values[0] + " " + values[1]);
    //Dibujamos un cuadrado de 100x100, con la posición en x definida por el valor de ritmo, y la posición en y definida por la temperatura.
    //rect(a, b, c, d) donde c=ancho y d=alto
    //Multiplicamos los datosVuelo por 2 para notar mejor la diferencia de posiciones.
    rect(datosVuelo[0]*2, datosVuelo[1]*2, 100, 100);
  }
}
