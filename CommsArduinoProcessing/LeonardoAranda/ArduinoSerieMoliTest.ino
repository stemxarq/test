/*El objetivo de éste código es que el Arduino habilite un canal de comunicación por medio su puerto serial. Este canal puede ser utilizado por medio del puerto USB u otros medios. A través de dicho canal, Arduino mandará un mensaje de texto conteniendo valores numéricos que representan las lecturas del sensor. Para este ejemplo, dichas lecturas son representadas por números aleatorios*/

//Variables numéricas para guardar valores de los sensores.
//Declarar una variable fuera de las llaves de otras funciones, hace que todas las funciones puedan verla.
int ritmo = 75;
int temperatura = 36;
int presion_s = 120;
int presion_d = 80;

//Variables de texto para transformar a las variables numéricas.
String r, t, ps, pd;

//Variable para construir mensaje con todas las variables de texto.
String mensaje;

//Función que realiza la conversión de las variables numéricas a texto.
//Cuidar de no declarar una función dentro de otra función, es decir, dentro de otro par de llaves.
void conversionString(){
  //La función constructora de la clase String devuelve un texto de lo que pongamos entre sus paréntesis.
  r = String(ritmo);
  t = String(temperatura);
  ps = String(presion_s);
  pd = String(presion_d);
}

void setup() {
  //Arduino habilita el puerto serial a una velocidad de 9600.
  //El punto representa que estamos accediendo a una función dentro de la clase Serial.
  Serial.begin(9600);     
}

void loop() {
  //Convertimos los valores numéricos a texto.
  conversionString();
  //Construimos un solo mensaje concatenando las variables de texto con un carácter separador.
  mensaje = String(r+"/"+t+"/"+ps+"/"+pd);
  //Enviamos dicho mensaje por el puerto serial del Arduino.
  //println agrega un 'Enter' al final del mensaje, cambiando de renglón para el siguiente.
  Serial.println(mensaje);
  //Actualizamos valor de ritmo por medio de una función definida por nosotros.
  ritmo = getRitmo();
  //Función para pausar la ejecución del código durante 1000 milisengundos.
  delay(1000);
}

//Función que devuelve un int, pero no recibe nada (no hay parámetro de entrada en los paréntesis).
int getRitmo(){
 //declaración de una variable entera. No es necesario inicializarla con un valor.
 int valor;
 //Esta variable la igualamos un número aleatorio, proporcionado por la función random. Dicho número pertenece al rango indicado por los paréntesis.
 valor = random(70,100);
 //Cuando la función sea llamada e igualada a algo, ese algo tomará lo que la variable 'valor' tenga guardado. Es decir, un número aleatorio.
 return valor;  
}
