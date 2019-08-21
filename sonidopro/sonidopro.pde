

//Barrett Anderies
//Jan. 21, 2013
//This a simple graphing program. It currently plots your mouse's x- and y-coordinates. It can plot up to three things at once (but could easily be modified to support more). To change input data, scroll
//down to the "DATA HANDLING" area and modify what newDataPoint1, newDataPoint2 and newDataPoint3 are being set to. You will have to write the code to retrieve data from outside sources (besides the mouse).

//I have included the serial library and have left the serial port initialization code in the startup loop (it's commented out) in anticipation of using this program to plot sensor data from a serial connection. 

//For help with serial, see the serial page on the Processing website: http://processing.org/reference/libraries/serial/index.html.

//I didn't put hash marks on the axes for various reasons, mostly to keep this code as simple as possible, but also because hash marks are meaningless until you scale your data to them. So I thought it'd be better
//to let the user add hash marks after experimenting with scaling his or her data. If you would like to add hash marks, I would suggest putting the code for them right after the code that draws
//the x- and y-axes (right before the "DATA HANDLING" area).

//In case you came across this program somewhere other than my website, you can go to the original post to for more information or to ask questions: http://barrettsprojects.wordpress.com/2013/01/22/graphing-with-processing/



import controlP5.*;
import processing.serial.*;//include the serial library 
import processing.sound.*;
Pulse pulse;

Serial myPort;                                                     //create an instance of type Serial called myPort
int width = 800;                                                   //use this variable to controll screen widtt
int height = 600;                                                  //use this variable to controll screen height 

int[] data1 = new int[width];                                      //data1, data2 and data3 store the graph information, and must be as long has the width of the screen (pixels)
int[] data2 = new int[width];                    
int[] data3 = new int[width];
int newDataPoint1 = 0;                                             //newDataPoint1, newDataPoint2 and newDataPoint3 are esentially buffers for incoming data
int newDataPoint2 = 0;
int newDataPoint3 = 0;




//textbox 
ControlP5 button1,button2,text1;
PImage img,img2;
int menu =0;
void setup()                                                       //the setup routine (runs once at startup)
{
  background(29, 33, 44); 
  img2 = loadImage(dataPath("bubbles.png"));
  img = loadImage(dataPath("algasicons.png"));
  pulse = new Pulse(this);
  
  
  
  rectMode(CENTER);

  size(800,600);
  frameRate(100);                                                  //set the refresh rate of the program. This also controls how quickly the graph moves.
  smooth();                                                        //smooth out lines and other graphics. If you don't like the fuzzy lines, replace "smooth()" with "noSmooth()"
  //println(Serial.list());                                        //this will print a list of avaiable serial ports
  //myPort = new Serial(this, Serial.list()[4], 9600);  
  button1 = new ControlP5(this);
  button2 = new ControlP5(this);
      button1.addButton("buttonA")
       .setPosition(175,400)
       .setColorValue(color(55, 203, 133))
         .setSize(125, 50);
         
     button2.addButton("buttonB")
       .setPosition(550,400)
       .setColorValue(color(55, 203, 133))
         .setSize(125, 50);
 
  
  
  //uncomment this if you'd like to use a serial port to get data (you will have to write code to fetch data)exec(dataPath("WINSCOPE.EXE"));
}

void draw()                                                        //the main routine (runs continuously until the program is ended)
{ 
  switch (menu){
    case 0:
      image(img, 300,200,150,150);
      image(img2, 240,7,300,400);

      
    break;
    case 1:
      button2.hide();
      text1 = new ControlP5(this);
      PFont font = createFont("arial", 20);
      text1.addTextfield("textInput_1")
      .setPosition(20, 100)
      .setSize(200, 40)
        .setFont(font)
          .setFocus(true)
            .setColor(color(255, 0, 0))
              .setInputFilter(ControlP5.INTEGER)
              .setText("0");
  
      if(text1.get(Textfield.class, "textInput_1").getText().equals(""))
      {
        pulse.freq(0);
      }else
      {
        newDataPoint3 = 350 - (Integer.parseInt(text1.get(Textfield.class, "textInput_1").getText()))/60;
        pulse.freq(Integer.parseInt(text1.get(Textfield.class, "textInput_1").getText()));
      }
  
  background(255,255,255);                                         //set the background to white. There are RGB color selectors online if you'd like to find a better looking color
  stroke(0,0,0);                                                   //set the stroke (line) color to black
  strokeWeight(2);                                                 //set the stroke width (weight) for the axes
  line(0,350,width,350);                                 //draw the x-axis line            
  line(width/4,0,width/4,height);                                  //draw the y-axis line
  
  
  //****DATA HANDLING****//                                        //the following 3 variables are buffers for incoming informaion, set these variables to the data you would like to display
  //*********************//  
  newDataPoint1 = 0;                                          
  newDataPoint2 = 0;          
                                                 //because the third data buffer is set to a constant (0), you'll notice a blue line at the top of the window.
  //*********************//
  //*********************//
  
  for(int i = 0; i < width-1; i++)                                 //each interation of draw, shift data points one pixel to the left to simulate a continuously moving graph
  {
    data1[i] = data1[i+1];
    data2[i] = data2[i+1];
    data3[i] = data3[i+1];
  }
  
  data1[width-1] = newDataPoint1;                                 //introduce the bufffered data into the rightmost data slot
  data2[width-1] = newDataPoint2;
  data3[width-1] = newDataPoint3;
  
  strokeWeight(2);                                                //set the stroke width (weight) for the actual graph
  
  for(int i = width-1; i > 0; i--)                                
  {
    stroke(255,0,0);
    line(i,data1[i-1], i+1, data1[i]);
    stroke(0,255,0);
    line(i,data2[i-1], i+1, data2[i]);
    stroke(0,0,255);
    line(i,data3[i-1], i+1, data3[i]); 
  }
  pulse.play();
    break;
  
  
  
  }
  
} 
public void buttonA(int value){
  menu =1;
  button1.hide();
  button2.hide();
}
