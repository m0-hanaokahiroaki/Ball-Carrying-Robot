float rotX, rotY;
float diff=1.0;
float wall=180, wall_height=300;
float scalePer=1.0;
float floorW=600, floorH=15;
float ballR=30;
int ballN=20;
int count=0;//# of balls of op=1
int ballnum;//the iterator of balls of op=1

class Arm{
  float angle;
  float W, L, H;
  
  Arm(float tempAngle, float tempW, float tempL, float tempH){
    angle=tempAngle;
    W=tempW;
    L=tempL;
    H=tempH;
  }
  
}

class Ball{
  float x, y, z;
  float vx, vy, vz;
  int op=0;//0:on red floor，1:on arm，2:on blue floor
  
  Ball(){
    x=random(-floorW/2-30, -30.0);
    y=random(10, 50);
    z=random(-floorW/2, floorW/2);
    
    vx=(random(2)*2-1)*random(1.0, 3.0);
    vy=(random(2)*2-1)*random(1.0, 3.0);
    vz=(random(2)*2-1)*random(1.0, 3.0);
  }
  
  void move(){
    if(op==0){//on red floor
      if(x<(-floorW-30+ballR)||x>(-30-ballR))vx*=-1;
      if(y<-(90-ballR))vy=max(-vy, -5.0);
      if(abs(z)>(floorW/2-ballR))vz*=-1;
    }
    if(op==2){//on blue floor
      if(x>(floorW+30-ballR)||x<(30+ballR))vx*=-1;
      if(y<-(90-ballR))vy=max(-vy, -6.0);
      if(abs(z)>(floorW/2-ballR))vz*=-1;
    }
    vy-=0.2;
    
    x+=vx;
    y+=vy;
    z+=vz;
    if(y<=-90)y=random(10, 50);
    
    noStroke();
    fill(120);
    pushMatrix();
    translate(x, y, z);
    //rotateX(radians(180));
    sphere(ballR);
    popMatrix();
  }
}

Arm arm1;
Arm arm2;
Arm arm3;

Ball[] balls=new Ball[ballN];

void setup(){
    size(1800, 1200, P3D);
    
    arm1=new Arm(0, 30, 180, 30);
    arm2=new Arm(30, 30, 180, 30);
    arm3=new Arm(30, 30, 180, 30);

    for(int i=0; i<ballN; i++){
      balls[i]=new Ball();
    }
}

float armBorder(float angle2, float angle3){
  return 1.0+cos(radians(angle2))+cos(radians(angle2+angle3));
}

void draw(){
   background(255);
   smooth();
   lights();
   noStroke();

   if(keyPressed){
     if(key=='a')arm1.angle+=diff;
     if(key=='A')arm1.angle-=diff;
     if(key=='s'&&arm2.angle<120&&armBorder(arm2.angle+diff, arm3.angle)>0.1&&(arm2.angle+arm3.angle+1)<215)arm2.angle+=diff;
     if(key=='S'&&arm2.angle>-120&&armBorder(arm2.angle-diff, arm3.angle)>0.1&&(arm2.angle+arm3.angle-1)>-215)arm2.angle-=diff;
     if(key=='d'&&arm3.angle<120&&armBorder(arm2.angle, arm3.angle+diff)>0.1&&(arm2.angle+arm3.angle+1)<215)arm3.angle+=diff;
     if(key=='D'&&arm3.angle>-120&&armBorder(arm2.angle, arm3.angle-diff)>0.1&&(arm2.angle+arm3.angle-1)>-215)arm3.angle-=diff;
     if(arm1.angle==360)arm1.angle=0;
     if(arm1.angle==-1)arm1.angle=359;
     
     if(key=='q'){
       arm1.L+=diff;
       arm2.L+=diff;
       arm3.L+=diff;
     }
     if(key=='Q'){
       arm1.L-=diff;
       arm2.L-=diff;
       arm3.L-=diff;
     }
     
   }
   
   translate(width/2, height/2);
   rotateX(rotX);
   rotateY(-rotY);
   
   rotateX(radians(180));
   
   pushMatrix();
   //arm1
   rotateY(radians(arm1.angle));
   //translate(0, 0, arm1.H);
   fill(175);
   box(arm1.W, arm1.L, arm1.H);
   
   //arm2
   translate(0, arm1.L/2, 0);
   sphere(25);
   rotateZ(radians(arm2.angle));
   translate(0, arm1.L/2, 0);
   fill(175);
   box(arm2.W, arm2.L, arm2.H);
   
   //arm3
   translate(0, arm2.L/2, 0);
   sphere(25);
   rotateZ(radians(arm3.angle));
   translate(0, arm2.L/2, 0);
   fill(175);
   box(arm3.W, arm3.L, arm3.H);
   
   //catcher
   translate(0, arm3.L/2, 0);
   fill(200);
   box(50, 5, 50);
   
   //ball(op=1)
   if(count==1){
     translate(0, 25, 0);
     fill(120);
     sphere(ballR);
   }
   
   popMatrix();
   
   pushMatrix();
   translate(0, -arm2.L/2-5, 0);
   fill(0);
   box(12000, 5, 12000);   
   translate(0, 5, 0);
   fill(175);
   box(60, 20, 60);
   translate(floorW/2+30, -5, 0);
   fill(0, 120, 250);
   box(floorW, floorH, floorW);
   translate(-floorW-60, 0, 0);
   fill(255, 0, 0);
   box(floorW, floorH, floorW);
   popMatrix();
   
   float t1=radians(arm1.angle), t2=radians(arm2.angle), t3=radians(arm3.angle);
   float armX=-(cos(t1)*sin(t2)+cos(t1)*sin(t2+t3))*arm2.L, armY=(1+cos(t2)+cos(t2+t3))*arm2.L-10, armZ=(sin(t1)*sin(t2)+sin(t1)*sin(t2+t3))*arm2.L;//xyz-coordinate of the arm tip
   for(int i=0; i<ballN; i++){
     if(balls[i].op==1){
       balls[i].x=-cos(t1)*sin(t2)*arm2.L-cos(t1)*sin(t2+t3)*(arm3.L);
       balls[i].y=arm1.L+cos(t2)*arm2.L+cos(t2+t3)*(arm3.L);
       balls[i].z=sin(t1)*sin(t2)*arm2.L+sin(t1)*sin(t2+t3)*(arm3.L);
     }
     
     if(count==0){
       if(dist(armX, armY, armZ, balls[i].x, balls[i].y, balls[i].z)<(ballR+50)){
         if(keyPressed&&key==' '){
           balls[i].op=1;
           balls[i].vx=0;
           balls[i].vy=0;
           balls[i].vz=0;
           count+=1;
         }
       }
     }
     else if(balls[i].op==1){
       if(keyPressed&&key==' '){
         if(balls[i].x>0&&balls[i].x<(floorW-ballR)&&abs(balls[i].z)<(floorW/2-ballR)){
           balls[i].op=2;
           balls[i].vx=(2*random(2)-1)*random(1.0, 3.0);
           balls[i].vz=(2*random(2)-1)*random(1.0, 3.0);
           count-=1;
         }
       }
     }
     
     if(balls[i].op!=1)balls[i].move();
   }
   
   rotateX(radians(180));
   
}

void mouseDragged(){
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}
