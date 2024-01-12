/*Este código es para escuchar, mediante Processing, lo que se envíe por puerto serial en el Arduino. Es nuestro propio monitor serial*/

//Importación de la librería para crear puertos seriales en Processing.
//Para importar librerías, Sketch -> Import Library...
import processing.serial.*;

//Variable para guardar una instancia (copia) específica de la clase Serial.
Serial port;
//Variable de texto para recibir lo que se escuche del puerto serial.
String mensaje = null;

void setup(){
  //Inicializamos nuestra copia de la clase Serial con tres parámetros.
  //'this' se refiere a este 'momento' en Processing (No preocuparse por esta parte).
  //"COM3" es el nombre del puerto serial a escuchar. Para escuchar al Arduino, hay que fijarse en el nombre del puerto por el cual el Arduino es programado.
  //9600 símbolos por segundo. Hay que sincronizar esta tasa/velocidad con la que está usando el Arduino.
  port = new Serial(this, "COM3", 9600);
  //Definimos un tamaño de ventana de dibujo de 600x600 pixeles.
  size(600,600);
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
    //Separamos el mensaje por medio del separador que concatenamos en Arduino, el caracter diagonal.
    //la función split nos devuelve 4 piezas separadas, las cuales son piezas de texto. La función int() las convierte en números. Ahora tenemos 4 números.
    //Esto cuatro números los guardamos todos al mismo tiempo en una sola variable tipo arreglo, la cual identificamos por los corchetes cuadrados.
    //Las variables tipo arreglo, son variables que guardan varios valores del mismo tipo, al mismo tiempo.
    int[] values = int(split(mensaje,'/'));
    //Accedemos a los valores guardados en el arreglo, por medio de índices. En programación, el primer índice siempre es el cero.
    //En Arduino, definimos nuestro mensaje como r+"/"+t+"/"+ps+"/"+pd, así que el índice cero, hace referencia al valor de ritmo, y el índice uno hace referencia a la temperatura. 
    println(values[0] + " " + values[1]);
    //Dibujamos un cuadrado de 100x100, con la posición en x definida por el valor de ritmo, y la posición en y definida por la temperatura.
    //Multiplicamos los valores por 2 para notar mejor la diferencia de posiciones.
    rect(values[0]*2, values[1]*2, 100, 100);
  }
}