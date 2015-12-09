//
// begin license header
//
// This file is part of Pixy CMUcam5 or "Pixy" for short
//
// All Pixy source code is provided under the terms of the
// GNU General Public License v2 (http://www.gnu.org/licenses/gpl-2.0.html).
// Those wishing to use Pixy source code, software and/or
// technologies under different licensing terms should contact us at
// cmucam@cs.cmu.edu. Such licensing terms are available for
// all portions of the Pixy codebase presented here.
//
// end license header
//
// This sketch is a simple tracking demo that uses the pan/tilt unit.  For
// more information, go here:
//
// http://cmucam.org/projects/cmucam5/wiki/Run_the_Pantilt_Demo
//

#include <SPI.h>  
#include <Pixy.h>
#include <Servo.h>
Servo leftWheelSpeed;
int leftWheelA = 2;
int leftWheelB = 4;
Servo rightWheelSpeed;
int rightWheelA = 7;
int rightWheelB = 8;
int IRdetector = A0;
int first = 1;
int start = 1;
Pixy pixy;

#define X_CENTER        ((PIXY_MAX_X-PIXY_MIN_X)/2)       
#define Y_CENTER        ((PIXY_MAX_Y-PIXY_MIN_Y)/2)

class ServoLoop
{
public:
  ServoLoop(int32_t pgain, int32_t dgain);

  void update(int32_t error);
   
  int32_t m_pos;
  int32_t m_prevError;
  int32_t m_pgain;
  int32_t m_dgain;
};


ServoLoop panLoop(300, 500);
ServoLoop tiltLoop(500, 100);

ServoLoop::ServoLoop(int32_t pgain, int32_t dgain)
{
  m_pos = PIXY_RCS_CENTER_POS;
  m_pgain = pgain;
  m_dgain = dgain;
  m_prevError = 0x80000000L;
}

void ServoLoop::update(int32_t error)
{
  long int vel;
  char buf[32];
  if (m_prevError!=0x80000000)
  {  
    vel = (error*m_pgain + (error - m_prevError)*m_dgain)>>10;
    //sprintf(buf, "%ld\n", vel);
    //Serial.print(buf);
    m_pos += vel;
    if (m_pos>PIXY_RCS_MAX_POS) 
      m_pos = PIXY_RCS_MAX_POS; 
    else if (m_pos<PIXY_RCS_MIN_POS) 
      m_pos = PIXY_RCS_MIN_POS;
  }
  m_prevError = error;
}

int setUP = 2;

void setup()
{
  leftWheelSpeed.attach(5);
  leftWheelSpeed.write(100);
  pinMode(leftWheelA, OUTPUT);
  pinMode(leftWheelB, OUTPUT);
  rightWheelSpeed.attach(6);
  rightWheelSpeed.write(100);
  pinMode(rightWheelA, OUTPUT);
  pinMode(rightWheelB, OUTPUT);
  pinMode(IRdetector, INPUT);
  Serial.begin(9600);
  Serial.print("Starting...\n");
  first = 1;
  start = 1;
  pixy.init();
  delay(1000);
  pixy.setServos(500, 100);
  delay(1000);
}

void loop()
{ 
  if(setUP > 0){
      setUP--;
      setup();
      first = 2;
  }
  pixy.setServos(panLoop.m_pos, 100);
  static int i = 0;
  int j = 0;
  int iter = 0;
  uint16_t blocks;
  char buf[32]; 
  int32_t panError, tiltError;
  
  blocks = pixy.getBlocks();
  if (blocks) {
    Serial.println("Found.");
    if((pixy.blocks[0].width)*(pixy.blocks[0].height) >= 3000){
      halt();
      delay(10000);
    }else{
      panError = X_CENTER-pixy.blocks[0].x;
      tiltError = 0;
      panLoop.update(panError);
      tiltLoop.update(tiltError);
      pixy.setServos(panLoop.m_pos, 100);
      i = 1;
      while(i % 5 > 0){
        if(panLoop.m_pos > PIXY_RCS_CENTER_POS+30){
          left();
        }else if(panLoop.m_pos < PIXY_RCS_CENTER_POS-30){
          right();
        }else{
          forwards();
        }
        i++;
      }
    }
  }else{
    Serial.println("Search.");
    i = 0;
    while(blocks == 0){
      pixy.setServos(PIXY_RCS_MAX_POS*i/8, 100);
      delay(2000);
      blocks = pixy.getBlocks();
      i++;
    }
    if(blocks == 0){
      forwards();
      delay(2000);
      right();
      i = 0;
      j = 0;
      while(i < 70000 && j == 0){
        blocks = pixy.getBlocks();
        if(blocks > 0){
          j++;
        }
        delay(100);
        i++;
      }
    }
  }
}

void forwards(){
  leftWheelSpeed.write(150);
  rightWheelSpeed.write(150);
  digitalWrite(leftWheelA, HIGH);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, HIGH);
  digitalWrite(rightWheelB, LOW);
}

void backwards(){
  leftWheelSpeed.write(150);
  rightWheelSpeed.write(150);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, HIGH);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, HIGH);
}

void right(){
  leftWheelSpeed.write(150);
  rightWheelSpeed.write(150);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, HIGH);
  digitalWrite(rightWheelA, HIGH);
  digitalWrite(rightWheelB, LOW);
}

void left(){
  leftWheelSpeed.write(150);
  rightWheelSpeed.write(150);
  digitalWrite(leftWheelA, HIGH);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, HIGH);
}

void halt(){
  leftWheelSpeed.write(0);
  rightWheelSpeed.write(0);
  digitalWrite(leftWheelA, LOW);
  digitalWrite(leftWheelB, LOW);
  digitalWrite(rightWheelA, LOW);
  digitalWrite(rightWheelB, LOW);
}
