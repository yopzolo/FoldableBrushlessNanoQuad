
//#define ESC_CALIB
#define ESC_RUN

#include <Servo.h> 

int escPins[] = {
  3,9,10,11}; 

Servo *myEscs = new Servo[4];

//int escPin = 3; 
//Servo myEsc;

void setup() 
{ 
  for (int i=0;i<sizeof(escPins) / sizeof(escPins[0]);i++){
    myEscs[i].attach(escPins[i]);
  }

  #ifdef ESC_CALIB
  for (int i=0;i<sizeof(escPins) / sizeof(escPins[0]);i++){  
    myEscs[i].writeMicroseconds(2000);
  }  
  
  delay(10500);


  for (int i=0;i<sizeof(escPins) / sizeof(escPins[0]);i++){
    myEscs[i].writeMicroseconds(1000);
  }
  delay(3500);
#endif

  delay(500);

  for (int i=0;i<sizeof(escPins) / sizeof(escPins[0]);i++){
    myEscs[i].writeMicroseconds(1000);
  }
  delay(2000);

digitalWrite(13,HIGH);
} 

int escToRun[] = {
  0}; 
int speeds[] = {
  1100,1200,1400,1500};
int currentSpeedIndex = 0;

void loop() 
{ 

#ifdef ESC_RUN
  for (int i=0;i<sizeof(escToRun) / sizeof(escToRun[0]);i++){
//    myEscs[ESC_RUN].writeMicroseconds(speeds[currentSpeedIndex]);
    myEscs[escToRun[i]].writeMicroseconds(speeds[currentSpeedIndex]);
  }
#endif

  currentSpeedIndex = (currentSpeedIndex+1)%(sizeof(speeds) / sizeof(speeds[0]));

delay(5000);
} 







