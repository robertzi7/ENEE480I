#include <Servo.h> 

//Pololu Pins
//Could probably do without South and possibily East/West depending
//on future version of what we will be doing
int North = 7; 
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
Servo ThrustFan2Servo;
 
void setup(void) 
{
  pinMode(North, INPUT);
  pinMode(East, INPUT);
  pinMode(South, INPUT);
  pinMode(West, INPUT);
  pinMode(IRdistance1, INPUT);
  pinMode(IRdistance2, INPUT);
  pinMode(frontDistance, INPUT);
  pinMode(hallEffect, INPUT);
  pinMode(LiftFan, OUTPUT);
  pinMode(ThrustFans, OUTPUT);
  ThrustFan1Servo.attach(9);
  ThrustFan1Servo.write(0);
  ThrustFan2Servo.attach(10);
  ThrustFan2Servo.write(0);
  Serial.begin(9600); 
} 

void loop(){
  delay(2000);
  //Turn the fans on
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
    
  //Wait for hovercraft to go slightly less than the 2m
  delay(4500);
    
  //Turn the fans off
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  delay(2000); //To reflect a full stop at the 2m mark
    
    
  ThrustFan1Servo.write(180);
  delay(2000); //Wait for the thrust fan to be fully moved
    
  //Turning on both fans (because they are facing
  //different directions it should go in a circle
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
    
  //delaying in the loop until we are facing the general direction
  
  while(digitalRead(North) == 1 || digitalRead(South) == 0 || digitalRead(East) == 0 || digitalRead(West) == 0){

  }
  
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
    
  delay(2000); //So fans and hovercraft can fully stop
    
  ThrustFan1Servo.write(0); //Put both fans facing the same direction
  ThrustFan2Servo.write(0); //Put both fans facing the same direction
  delay(2000);
    
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
  
  delay(10000); //To be replaced with 'until we got the payload'




  
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  
  ThrustFan1Servo.write(180);
  ThrustFan2Servo.write(180);
  delay(3000);
  
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
  
  delay(6000); //Amount of time it will go back
  
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  
  delay(2000);
  ThrustFan1Servo.write(0);
  
  delay(2000);
  
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
  
  delay(3500); //Amount of turning time
  
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  
  delay(2000);
  
  ThrustFan2Servo.write(0);
  
  delay(2000);
  
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
  
  delay(3500);
  
  //This number will need to be changed
  //Will go forward until it reads below this number
  //while(analogRead(frontDistance) < 500){
  //}
  
  
  //smallLeft();
 //This and smallRight(); separated so I can make similar changes
//to many parts of the program at once 
  
  while(analogRead(IRdistance1) > 20 && analogRead(IRdistance2) > 20){
    if(analogRead(IRdistance1) < 550 && analogRead(IRdistance2) < 550){
      smallLeft();
    } else if (analogRead(IRdistance1) > 500 && analogRead(IRdistance2) > 500){
      smallRight();
    } else if (analogRead(IRdistance1) < 550) {
      smallLeft();
    } else if (analogRead(IRdistance1) > 500){
      smallRight();
    } else if (analogRead(IRdistance2) < 550) {
      smallRight();
    } else if (analogRead(IRdistance2) > 500){
      smallLeft();
    }
    
    while(analogRead(frontDistance) > 70 || analogRead(frontDistance) < 60){
      smallLeft();
    }
    ease();
  }
  
  
  delay(2000);
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  delay(2000);
  ThrustFan1Servo.write(0);
  ThrustFan2Servo.write(0);
  delay(2000);
  ThrustFan1Servo.write(180);
  delay(2000);
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
  delay(3500); //Change this number to make 90 degrees
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  delay(2000);
  ThrustFan1Servo.write(0);
  delay(2000);
  digitalWrite(LiftFan, HIGH);
  digitalWrite(ThrustFans, HIGH);
  delay(10000);
  //Should be out at this point
  digitalWrite(LiftFan, LOW);
  digitalWrite(ThrustFans, LOW);
  delay(10000000);
}

void smallLeft(){
  ThrustFan2Servo.write(160);
  ThrustFan1Servo.write(0);
}  

void smallRight(){
  ThrustFan1Servo.write(160);
  ThrustFan2Servo.write(0);
}

void ease(){
  int i = 160;
  while(i >= 0){
    ThrustFan2Servo.write(i);
    i--;
  }
}

