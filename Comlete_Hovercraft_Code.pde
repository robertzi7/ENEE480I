#include <Servo.h>
#include <SPI.h>  
#include <Pixy.h>

//Pololu Pins
//Could probably do without South and possibily East/West depending
//on future version of what we will be doing
/*int North = 7;
int East = 8;
int South = 11;
int West = 12;

//Disance sensors
int IRdistance1 = A0;
int IRdistance2 = A1;
int frontDistance = A2;
int hallEffect = A3;

//Pins that are connected to resistors that controls the current to the fans
int LiftFan = 5;
int ThrustFans = 3;


//Pin connecting the servos
Servo ThrustFan1Servo;
Servo ThrustFan2Servo;*/

Servo leftWheelSpeed;
int leftWheelA = 2;
int leftWheelB = 4;
Servo rightWheelSpeed;
int rightWheelA = 7;
int rightWheelB = 8;
int IRdetector = A0;
Pixy pixy;

void setup(void)
{
  leftWheelSpeed.attach(5);
  leftWheelSpeed.write(0);
  pinMode(leftWheelA, OUTPUT);
  pinMode(leftWheelB, OUTPUT);
  rightWheelSpeed.attach(6);
  rightWheelSpeed.write(0);
  pinMode(rightWheelA, OUTPUT);
  pinMode(rightWheelB, OUTPUT);
  pinMode(IRdetector, INPUT);
  
  Serial.begin(9600);
  pixy.init();
}

void loop() {
  static int i = 0;
  int j;
  uint16_t blocks;
  char buf[32]; 
  
  // grab blocks!
  blocks = pixy.getBlocks();
  
  // If there are detect blocks, print them!
  if (blocks)
  {
    panError = X_CENTER-pixy.blocks[0].x;
    tiltError = pixy.blocks[0].y-Y_CENTER;
    panLoop.update(panError);
    tiltLoop.update(tiltError);
    if(panError < -10){
      left();
    }else if(panError > 10){
      right();
    }else{
      forwards();
    }
    pixy.setServos(panLoop.m_pos, tiltLoop.m_pos);
    
    i++;
    
    // do this (print) every 50 frames because printing every
    // frame would bog down the Arduino
    if (i%50==0) 
    {
      sprintf(buf, "Detected %d:\n", blocks);
      Serial.print(buf);
      for (j=0; j<blocks; j++)
      {
        sprintf(buf, "  block %d: ", j);
        Serial.print(buf); 
        pixy.blocks[j].print();
      }
    }
  }else{
    //halt();
  }
  //Serial.print("Serial: ");
  //Serial.println(analogRead(IRdetector));
  //delay(100);
  /*halt();
  leftWheelSpeed.write(50);
  rightWheelSpeed.write(50);
  delay(1000);
  right();
  delay(3000);
  left();
  delay(3000);
  forwards();
  delay(2000);
  backwards();
  delay(2000);
  halt();
  delay(100000000);*/
}

void halt(){
  leftWheelSpeed.write(0);
  rightWheelSpeed.write(0);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, LOW);
}

void forwards(){
  leftWheelSpeed.write(100);
  rightWheelSpeed.write(100);
  digitalWrite(leftWheelA, HIGH);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, HIGH);
  digitalWrite(rightWheelB, LOW);
}

void backwards(){
  leftWheelSpeed.write(100);
  rightWheelSpeed.write(100);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, HIGH);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, HIGH);
}

void left(){
  leftWheelSpeed.write(100);
  rightWheelSpeed.write(100);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, HIGH);
  digitalWrite(rightWheelA, HIGH);
  digitalWrite(rightWheelB, LOW);
}

void right(){
  leftWheelSpeed.write(100);
  rightWheelSpeed.write(100);
  digitalWrite(leftWheelA, HIGH);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, HIGH);
}

void forwards(int speed){
  leftWheelSpeed.write(speed);
  rightWheelSpeed.write(speed);
  digitalWrite(leftWheelA, HIGH);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, HIGH);
  digitalWrite(rightWheelB, LOW);
}

void backwards(int speed){
  leftWheelSpeed.write(speed);
  rightWheelSpeed.write(speed);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, HIGH);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, HIGH);
}

void left(int speed){
  leftWheelSpeed.write(speed);
  rightWheelSpeed.write(speed);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, HIGH);
  digitalWrite(rightWheelA, HIGH);
  digitalWrite(rightWheelB, LOW);
}

void right(int speed){
  leftWheelSpeed.write(speed);
  rightWheelSpeed.write(speed);
  digitalWrite(leftWheelA, HIGH);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, HIGH);
}

void smallLeft() {
  //ThrustFan2Servo.write(160);
  //ThrustFan1Servo.write(0);
}

void smallRight() {
  //ThrustFan1Servo.write(160);
  //ThrustFan2Servo.write(0);
}

void ease() {
  //int i = 160;
  //while(i >= 0){
  //  ThrustFan2Servo.write(i);
  //  i--;
  //}
}
