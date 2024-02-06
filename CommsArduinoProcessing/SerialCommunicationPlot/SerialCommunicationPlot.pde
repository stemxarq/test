//https://carlosavila.es/midiendo-la-iluminacion-y-creando-una-grafica-con-processing/

import processing.serial.*;
 
int WINDOW_WIDTH=500;
int WINDOW_HEIGHT=300;
int LEFT_MARGIN=50;
int TOP_MARGIN= 100;
int STROKE_AUX=2;
int STROKE_DATA=4;
int MAX_VALUE=1050;
int AUX_LINES_SPACE_Y=200;
int AUX_LINES_SPACE_X=40;
int FRAMERATE=20;
//String arduinoPort = "COM6";
 
color rojo = color(180,0,0);
color verde = color(0,200,0);
color gris = color(170,170,170);
color darkGreen = #1D5A25;
color black = color(0);
color blue = #79ADFF;
 
Serial port;
int light; //valor a representar
int[] lights;
int cont=0;
 
void setup()
{
  size(600, 500);
  //port = new Serial(this, arduinoPort, 9600);
  //port.bufferUntil('\n');
  lights = new int[WINDOW_WIDTH];
  frameRate(FRAMERATE);
}
 
void draw()
{
  draw_AuxLines();
  show_LightValue();
  populateData();
  paintData();
  // Descomentar si se quiere mostrar el valor por consola
  //showDataInConsole();
}
 
// Leemos los valores enviados por Arduino
//void serialEvent(Serial port){
 void serialEvent(){
//  if (port.available() &gt; 0){
//    light = int(trim(port.readStringUntil('\n')));
//  }
light=int(random(0,100));
}

// Convertimos proporcionalmente el eje Y en funcion de las dimensiones deseadas
// para la ventana
int getY(int val){
  return (int) (val*WINDOW_HEIGHT)/MAX_VALUE;
}
 
// Se muestran las líneas auxiliares y textos
void draw_AuxLines(){
  // Damos formato al fondo y líneas auxiliares
  background(gris);
  stroke(darkGreen);
  strokeWeight(STROKE_AUX);
  fill(black);
  //PFont f = createFont("Arial",16,true);
  textSize(20);
  text("ILUMINACIÓN", (width/2)-60, (TOP_MARGIN/2)+10);
  textSize(12);
 
  // Obtenemos el nº de lineas auxiliares horizontales. Restamos 1 para que no se
  // solape con la parte superior del cuadro cuando sean divisibles exactos (2000/500).
  //Se muestra el valor de cada eje.
  for (int i=1; i<=(MAX_VALUE-1)/AUX_LINES_SPACE_Y; i++){
    line(LEFT_MARGIN, (WINDOW_HEIGHT+TOP_MARGIN)-getY(AUX_LINES_SPACE_Y*i),
        LEFT_MARGIN+WINDOW_WIDTH+(STROKE_AUX/2),
        (WINDOW_HEIGHT+TOP_MARGIN)-getY(AUX_LINES_SPACE_Y)*i);
    text(AUX_LINES_SPACE_Y*i, 15, (WINDOW_HEIGHT+TOP_MARGIN)-getY(AUX_LINES_SPACE_Y*i));
  }
 
  // Repetimos la operacion con las auxiliares verticales.
  for (int i=1; i<=(WINDOW_WIDTH-1)/AUX_LINES_SPACE_X; i++){
    line(LEFT_MARGIN+(AUX_LINES_SPACE_X*i), TOP_MARGIN,
        LEFT_MARGIN+(AUX_LINES_SPACE_X*i), TOP_MARGIN+WINDOW_HEIGHT+(STROKE_AUX/2));
    text(i*(AUX_LINES_SPACE_X/FRAMERATE)+"s",
        LEFT_MARGIN+(AUX_LINES_SPACE_X*i), TOP_MARGIN+WINDOW_HEIGHT+20);
  }
 
  // Creamos el borde externo, con las esquinas redondeadas.
  stroke(black);
  noFill();
  rect(LEFT_MARGIN-(STROKE_AUX/2), TOP_MARGIN,
      WINDOW_WIDTH+STROKE_AUX+(STROKE_DATA/2),
      WINDOW_HEIGHT+(STROKE_AUX/2)+(STROKE_DATA/2), 10);
 
  // Creamos el cuadro para el valor instantáneo
  fill(blue);
  rect(430, TOP_MARGIN/2-25, 120, 50);
 
  // Creamos los botones de ON y OFF
  fill(verde);
  rect(50, TOP_MARGIN/2-25, 50, 50);
  fill(rojo);
  rect(110, TOP_MARGIN/2-25, 50, 50);
 
  // Los textos de los botones ON y OFF
  fill(black);
  textSize(20);
  text("ON", 60, TOP_MARGIN/2+10);
  text("OFF", 118, TOP_MARGIN/2+10);
 
}
 
// Se muestra el valor de luminosidad instantánea
void show_LightValue(){
  fill(black);
  textSize(30);
  text(light, 460, TOP_MARGIN/2+12);
}
 
// Se crea un array con los datos de luminosidad, que luego se mostrará
void populateData(){
    // Almacenamos los valores de luz en el array. Si el array es más grande que
  // el ancho de la pantalla lo ponemos todo a 0.
  if (cont < WINDOW_WIDTH){
    lights[cont] = light;
    cont++;
  } else {
    emptyData();
  }
}
 
// Pone a 0 todos los valores del array
void emptyData(){
   cont = 0;
   for (int i=0; i<WINDOW_WIDTH-1; i++)
   lights[i] = 0;
}
 
// Se crea la gráfica con los datos de luminosidad del array
void paintData(){
  stroke(rojo);
  strokeWeight(STROKE_DATA);
  for (int x=1; x<cont; x++){
       line(LEFT_MARGIN+x, (WINDOW_HEIGHT+TOP_MARGIN)-getY(lights[x-1]),
           LEFT_MARGIN+x+1, (WINDOW_HEIGHT+TOP_MARGIN)-getY(lights[x]));
    }
  }
// Se muestra en consola el dato recibido por el puerto serie de Arduino.
void showDataInConsole(){
    println(light);
  } 
 
// Detecta las pulsaciones del ratón sobre los botones ON y OFF para
// activar/desactivar la toma de datos
void mouseClicked(){
    if ((mouseX>=50)&&(mouseX<=100)&&
        (mouseY>=TOP_MARGIN/2-25)&&(mouseY<=(TOP_MARGIN/2-25)+50)){
      port.write('1');
      frameRate(20);
    }
    if ((mouseX>=110)&&(mouseX<=160)&&
         (mouseY>=TOP_MARGIN/2-25)&&(mouseY<=(TOP_MARGIN/2-25)+50)){
      port.write('2');
      //emptyData();
      light=0;
   }
}
