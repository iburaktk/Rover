#define LRen 3
#define LLen 4
#define LRpwm 5
#define LLpwm 6
#define RRen 7
#define RLen 8
#define RRpwm 9
#define RLpwm 10

int pwmL, yonL, pwmR, yonR, i, j;
char buffer[12];
char currentChar;

void setup() {
  pinMode(LRen,OUTPUT);
  pinMode(LLen,OUTPUT);
  pinMode(LRpwm,OUTPUT);
  pinMode(LLpwm,OUTPUT);
  pinMode(RRen,OUTPUT);
  pinMode(RLen,OUTPUT);
  pinMode(RRpwm,OUTPUT);
  pinMode(RLpwm,OUTPUT);
  
  digitalWrite(LRen,HIGH); // Both pins need to be HIGH
  digitalWrite(LLen,HIGH);
  digitalWrite(RRen,HIGH);
  digitalWrite(RLen,HIGH);

  Serial.begin(57600);
  while (!Serial) {}
  Serial.print("Ready\n");
}

void loop() {
  if (Serial.available())
  {
    i=0;
    j=2;
    while (1)
    {
      currentChar = Serial.read();
      if (currentChar == -1)
        continue;
      buffer[i++] = currentChar;
      if (currentChar == '\n')
        break;
    }
    yonL = buffer[0] - 48;
    pwmL = 0;
    for (i=j;i<12;i++)
    {
      if (buffer[i] == ',')
      {
        j=i+1;
        break;
      }
      pwmL *= 10;
      pwmL += (buffer[i] - 48);
    }
    yonR = buffer[j] - 48;
    pwmR = 0;
    for (i=j+2;i<12;i++)
    {
      if (buffer[i] == '\n')
      {
        break;
      }
      pwmR *= 10;
      pwmR += (buffer[i] - 48);
    }
    
    if (yonL == 1)
    {
      analogWrite(LRpwm,pwmL);
      analogWrite(LLpwm,0);
    }
    else
    {
      analogWrite(LRpwm,0);
      analogWrite(LLpwm,pwmL);
    }
    if (yonR == 1)
    {
      analogWrite(RRpwm,pwmR);
      analogWrite(RLpwm,0);
    }
    else
    {
      analogWrite(RRpwm,0);
      analogWrite(RLpwm,pwmR);
    }
    Serial.print("Ready\n");
  }
}
