
import fisica.*;

FWorld world;
Ship player;

boolean showGrid;

Module grabbedMod;
PVector newModPos;
float newModRot;
boolean keys[] = new boolean [7];

int frame;

void setup() {
  size(800, 800);
  frameRate(30);
  smooth();

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 0);
  world.setEdges();
  
  player = new Ship();
  player.setPosition(width/2, height*7/8);
  world.add(player);
  
  int size = 20;
  for (float i = size; i <= width-size; i += size*1.5) {
    for (float j = size; j <= height/2-size; j += size*1.5) {
      FCircle blob = createBlob(size);
      blob.setPosition(i, j);
      world.add(blob);
    }
  }
  
  Module m = new Module();
  m.setPosition(width/2, height*3/4);
  world.add(m);
  
  //
  showGrid = false;
  newModRot = 0;
  
  frame = 0;
}

void draw() {
  background(240);
  frame++;
  
  String f = "";
  if (keys[0]) f += "W";
  if (keys[1]) f += "A";
  if (keys[2]) f += "S";
  if (keys[3]) f += "D";
  if (keys[4]) f += "Q";
  if (keys[5]) f += "E";
  if (!f.equals("")) {
    player.thrusterSystem.fireThrusters(f);
  }
  if (keys[6]) {
    player.fire(world);
  }
  
  world.step();
  player.update();
  
  if (showGrid) {
    float closestPos = 9999;
    
    for (PVector p: player.grid.openPositions) {
      PVector pos = PVector.mult(p, 40);
      pos.rotate(player.getRotation());
      pos.add(player.getX(), player.getY());
      pos.sub(grabbedMod.getX(), grabbedMod.getY());
      
      if (closestPos > pos.mag()) {
        newModPos = new PVector(p.x, p.y);
        closestPos = pos.mag();
      }
    }
    
    player.drawGrid();
    
    if(newModPos != null) {
      boolean thrusterCondition = (!(grabbedMod instanceof ThrusterModule) 
          || (grabbedMod instanceof ThrusterModule) 
          && player.grid.thrusterAttachable((int)newModPos.x, (int)newModPos.y ,(int)newModRot));//Makes sure that if the mod is a thruster it can be attached
      boolean weaponCondition = (!(grabbedMod instanceof WeaponModule) 
          || (grabbedMod instanceof WeaponModule) 
          && player.grid.thrusterAttachable((int)newModPos.x, (int)newModPos.y ,(int)newModRot));//Makes sure that if the mod is a thruster it can be attached
          
      if (closestPos >= 40 || !thrusterCondition || !weaponCondition) {
        grabbedMod.drawGhost(player, newModPos, radians(newModRot), 100);
        newModPos = null;
      }
      else if (thrusterCondition && weaponCondition)
        grabbedMod.drawGhost(player, newModPos, radians(newModRot), 0);
    }
  }
  
  world.draw(this);
}

void mousePressed() {
  FBody b = world.getBody(mouseX, mouseY);
  if ((b instanceof Module) && !(b instanceof Ship)) {
    grabbedMod = (Module)b;
    showGrid = true;
  }
}

void mouseReleased() {
  if (showGrid) {
    showGrid = false;
    
    if (newModPos != null) {
      PVector oldPos = new PVector(player.getX(), player.getY());
      float oldRot = player.getRotation();
      PVector oldVel = new PVector(player.getVelocityX(), player.getVelocityY());
      float oldAngVel = player.getAngularVelocity();
      
      world.remove(grabbedMod);
      world.remove(player); //<>//
      
      player.addModule(grabbedMod, newModPos, radians(newModRot));
      
      world.add(player);
      
      player.setPosition(oldPos.x, oldPos.y);
      player.setRotation(oldRot);
      player.setVelocity(oldVel.x, oldVel.y);
      player.setAngularVelocity(oldAngVel);
    }
  }
}

void keyPressed() {
  if (key == 'w') keys[0] = true; //W
  if (key == 'a') keys[1] = true; //A
  if (key == 's') keys[2] = true; //S
  if (key == 'd') keys[3] = true; //D
  if (key == 'q') keys[4] = true; //Q
  if (key == 'e') keys[5] = true; //E
  if (key == ' ') keys[6] = true; //SPACEBAR
  if (key == 'n') { //Module
    Module m = new Module();
    m.setPosition(width/4, height*3/4);
    world.add(m);
  }
  if (key == 'm') { //Thruster
    ThrusterModule m = new ThrusterModule();
    m.setPosition(width/2, height*3/4);
    world.add(m);
  }
  if (key == ',') { //Gun
    WeaponModule m = new WeaponModule();
    m.setPosition(width*3/4, height*3/4);
    world.add(m);
  }
  if (key == 'r') {
    newModRot += 90;
    if (newModRot >= 360) newModRot = 0;
  }
}

void keyReleased() {
  if (key == 'w') keys[0] = false; //W
  if (key == 'a') keys[1] = false; //A
  if (key == 's') keys[2] = false; //S
  if (key == 'd') keys[3] = false; //D
  if (key == 'q') keys[4] = false; //Q
  if (key == 'e') keys[5] = false; //E
  if (key == ' ') keys[6] = false; //SPACEBAR
}

FCircle createBlob(int size) {
  FCircle blob = new FCircle(size);
  blob.setGrabbable(false);
  blob.setDensity(0.01);
  blob.setDamping(0);
  blob.setAngularDamping(0);
  
  return blob;
}

void contactStarted(FContact contact) {
   if ((contact.getBody1() instanceof Bullet) || (contact.getBody2() instanceof Bullet)) {
     fill(170, 0, 0);
     ellipse(contact.getX(), contact.getY(), 20, 20);
   }
 }

 void contactPersisted(FContact contact) {
   if ((contact.getBody1() instanceof Bullet) || (contact.getBody2() instanceof Bullet)) {
     fill(170, 170, 0);
     ellipse(contact.getX(), contact.getY(), 15, 15);
   }
 }
 
 void contactEnded(FContact contact) {
   if (contact.getBody1() instanceof Bullet) {
     fill(170, 85, 0);
     ellipse(contact.getX(), contact.getY(), 10, 10);
     
     Bullet b = (Bullet)contact.getBody1();
     PVector v = new PVector(b.getVelocityX(), b.getVelocityY());
     if (v.mag() <= 500)
       world.remove(b);
   }
   else if (contact.getBody2() instanceof Bullet) {
     fill(170, 85, 0);
     ellipse(contact.getX(), contact.getY(), 10, 10);
     
     Bullet b = (Bullet)contact.getBody2();
     PVector v = new PVector(b.getVelocityX(), b.getVelocityY());
     if (v.mag() <= 500)
       world.remove(b);
   }
 }