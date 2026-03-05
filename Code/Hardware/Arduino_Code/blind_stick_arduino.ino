#define TRIG_UP 2
#define ECHO_UP 3
#define TRIG_LEFT 4
#define ECHO_LEFT 5
#define TRIG_RIGHT 6
#define ECHO_RIGHT 7
#define TRIG_DOWN 8
#define ECHO_DOWN 9

#define BUZZER 10
#define VIBRATION 12
#define MOISTURE A0
#define BUTTON 11

long getDistance(int trig,int echo)
{
digitalWrite(trig,LOW);
delayMicroseconds(2);

digitalWrite(trig,HIGH);
delayMicroseconds(10);

digitalWrite(trig,LOW);

long duration = pulseIn(echo,HIGH,20000);

if(duration==0) return 999;

return duration*0.034/2;
}

void setup()
{
Serial.begin(9600);

pinMode(TRIG_UP,OUTPUT);
pinMode(ECHO_UP,INPUT);

pinMode(TRIG_LEFT,OUTPUT);
pinMode(ECHO_LEFT,INPUT);

pinMode(TRIG_RIGHT,OUTPUT);
pinMode(ECHO_RIGHT,INPUT);

pinMode(TRIG_DOWN,OUTPUT);
pinMode(ECHO_DOWN,INPUT);

pinMode(BUZZER,OUTPUT);
pinMode(VIBRATION,OUTPUT);

pinMode(BUTTON,INPUT_PULLUP);
}

void loop()
{

int dUp = getDistance(TRIG_UP,ECHO_UP);
int dLeft = getDistance(TRIG_LEFT,ECHO_LEFT);
int dRight = getDistance(TRIG_RIGHT,ECHO_RIGHT);
int dDown = getDistance(TRIG_DOWN,ECHO_DOWN);

int moisture = analogRead(MOISTURE);

bool alert=false;

if(dUp < 100){
Serial.println("Obstacle Up");
alert=true;
}

if(dLeft < 100){
Serial.println("Obstacle Left");
alert=true;
}

if(dRight < 100){
Serial.println("Obstacle Right");
alert=true;
}

if(dDown < 75){
Serial.println("Ground Obstacle");
alert=true;
}

if(moisture < 990){
Serial.println("Wet Surface Detected");
alert=true;
}

if(digitalRead(BUTTON)==LOW){
Serial.println("SOS");
}

digitalWrite(BUZZER,alert);
digitalWrite(VIBRATION,alert);

delay(200);
}
