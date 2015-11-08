
import fisica.*;

FWorldModified world;
Ship player;
Ship dummy;

boolean showGrid;

Module grabbedMod;
PVector newModPos;
float newModRot;
boolean keys[] = new boolean [7];

int frame;
float zoom;
float z;

void setup() {
  size(1200, 900);
  frameRate(30);

  Fisica.init(this);
  world = new FWorldModified();
  world.setGravity(0, 0);
  world.setEdges(0, 0, width*2, height*2);
  
  player = new Ship();
  player.setPosition(width*7/4, height);
  player.setRotation(PI/2);
  player.setGrabbable(false);
  world.add(player);
  
  dummy = new Ship();
  dummy.setPosition(width/4, height);
  dummy.setRotation(-PI/2);
  giveBasicBody(dummy);
  world.add(dummy);
  
  int size = 20;
  for (float i = size; i <= width*2-size; i += size*4) {
    for (float j = size; j <= height*2-size; j += size*4) {
      if (j < height*7/8 || j > height*9/8) {
        FCircle blob = createBlob(size);
        blob.setPosition(i, j);
        world.add(blob);
      }
    }
  }
  
  showGrid = false;
  newModRot = 0;
  
  frame = 0;
  z = 0;
  zoom = (float)Math.exp(z);
}

void draw() {
  background(240);
  frame++;
  
  pushMatrix();
  scale(zoom);
  translate(width/2/zoom, height/2/zoom);
  rotate(-player.getRotation()+PI);
  translate(-player.getX(), -player.getY());
  
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
  popMatrix();
}

void mousePressed() {
  FBody b = world.getBody(translateMouse().x, translateMouse().y);
  if ((b instanceof Module) && !(b instanceof Ship)) {
    grabbedMod = (Module)b;
    showGrid = true;
  }
}

void mouseReleased() {
  if (showGrid) {
    showGrid = false;
     //<>//
    if (newModPos != null) {
      PVector oldPos = new PVector(player.getX(), player.getY());
      float oldRot = player.getRotation();
      PVector oldVel = new PVector(player.getVelocityX(), player.getVelocityY());
      float oldAngVel = player.getAngularVelocity();
      
      world.remove(grabbedMod);
      world.remove(player);
      
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
  if (key == 'w' || key == 'W') keys[0] = true; //W
  if (key == 'a' || key == 'A') keys[1] = true; //A
  if (key == 's' || key == 'S') keys[2] = true; //S
  if (key == 'd' || key == 'D') keys[3] = true; //D
  if (key == 'q' || key == 'Q') keys[4] = true; //Q
  if (key == 'e' || key == 'E') keys[5] = true; //E
  if (key == ' ') keys[6] = true; //SPACEBAR
  if (key == 'n' || key == 'N') { //Module
    Module m = new Module();
    m.setPosition(width*31/16, height*7/8);
    world.add(m);
  }
  if (key == 'm' || key == 'M') { //Thruster
    ThrusterModule m = new ThrusterModule();
    m.setPosition(width*31/16, height);
    world.add(m);
  }
  if (key == ',') { //Gun
    WeaponModule m = new WeaponModule();
    m.setPosition(width*31/16, height*9/8);
    world.add(m);
  }
  if (key == 'r' || key == 'R') {
    newModRot += 90;
    if (newModRot >= 360) newModRot = 0;
  }
  if ((key == 'b' || key == 'B') && player.grid.modules.size() == 1) {
    world.remove(player);
    giveBasicBody(player);
    world.add(player);
  }
  if (key == '=' || key == '+') {
    if (z < 1.5)
      z+=.1;
    zoom = (float)Math.exp(z);
  }
  if (key == '-' || key == '_') {
    if (z > -1.5)
      z-=.1;
    zoom = (float)Math.exp(z);
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') keys[0] = false; //W
  if (key == 'a' || key == 'A') keys[1] = false; //A
  if (key == 's' || key == 'S') keys[2] = false; //S
  if (key == 'd' || key == 'D') keys[3] = false; //D
  if (key == 'q' || key == 'Q') keys[4] = false; //Q
  if (key == 'e' || key == 'E') keys[5] = false; //E
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
    
    doDamage(contact);
  }
  //Bouncing!!!
  else if (contact.getBody1() instanceof FCircle) {
    if (abs(contact.getBody1().getX()-width) > width*96/100)
      contact.getBody1().setVelocity(-contact.getBody1().getVelocityX(), contact.getBody1().getVelocityY());
    if (abs(contact.getBody1().getY()-height) > height*96/100)
      contact.getBody1().setVelocity(contact.getBody1().getVelocityX(), -contact.getBody1().getVelocityY());
  }
  else if (contact.getBody2() instanceof FCircle) {
    if (abs(contact.getBody2().getX()-width) > width*96/100)
      contact.getBody2().setVelocity(-contact.getBody2().getVelocityX(), contact.getBody2().getVelocityY());
    if (abs(contact.getBody2().getY()-height) > height*96/100)
      contact.getBody2().setVelocity(contact.getBody2().getVelocityX(), -contact.getBody2().getVelocityY());
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
 
void doDamage(FContact contact) {
  Module hitMod;
  Bullet bullet;
  
  if ((contact.getBody1() instanceof Bullet) && (contact.getBody2() instanceof Module)) {
    hitMod = (Module)contact.getBody2();
    bullet = (Bullet)contact.getBody1();
  }
  else if ((contact.getBody2() instanceof Bullet) && (contact.getBody1() instanceof Module)) {
    hitMod = (Module)contact.getBody1();
    bullet = (Bullet)contact.getBody2();
  }
  else return;
  
  if (hitMod instanceof Ship) {
    try { //Module finding is not perfect so try-catch prevent crashes
      hitMod = dummy.grid.findModuleAt(contact.getX(), contact.getY());
      hitMod.hp -= (new PVector(bullet.getVelocityX(), bullet.getVelocityY()).mag() * bullet.getMass());
      
      if (hitMod.hp <= 0) {
        world.remove(dummy);
        
        if (!dummy.equals(hitMod)) {
          dummy = dummy.removeModule(hitMod);
          if (dummy.grid.modules.get(0) instanceof Ship)
            world.add(dummy);
          fill(50);
          ellipse(contact.getX(), contact.getY(), 30, 30);
        }
        else {
          fill(50);
          ellipse(dummy.getX(), dummy.getY(), 60, 60);
        } 
      }
    } catch(Exception e) {}
  }
  else{
    hitMod.hp -= (new PVector(bullet.getVelocityX(), bullet.getVelocityY()).mag() * bullet.getMass());
    if (hitMod.hp <= 0) {
      world.remove(hitMod);
      
      fill(50);
      ellipse(contact.getX(), contact.getY(), 30, 30);
    }
  } 
}

void giveBasicBody(Ship s) {
  s.addModule(new Module(), new PVector(1, 0), 0);
  s.addModule(new Module(), new PVector(-1, 0), 0);
  s.addModule(new Module(), new PVector(0, -1), 0);
  s.addModule(new Module(), new PVector(0, -2), 0);
  
  s.addModule(new ThrusterModule(), new PVector(1, 1), PI);
  s.addModule(new ThrusterModule(), new PVector(-1, 1), PI);
  s.addModule(new ThrusterModule(), new PVector(-2, 0), -PI/2);
  s.addModule(new ThrusterModule(), new PVector(-1, -2), -PI/2);
  s.addModule(new ThrusterModule(), new PVector(2, 0), PI/2);
  s.addModule(new ThrusterModule(), new PVector(1, -2), PI/2);
  s.addModule(new ThrusterModule(), new PVector(-1, -1), 0);
  s.addModule(new ThrusterModule(), new PVector(1, -1), 0);
  s.addModule(new ThrusterModule(), new PVector(0, -3), 0);
  
  s.addModule(new WeaponModule(), new PVector(0, 1), PI);
}

PVector translateMouse() {
  PVector mousePos = new PVector(mouseX/zoom, mouseY/zoom);
  mousePos.add(-width/2/zoom, -height/2/zoom);
  mousePos.rotate(player.getRotation()+PI);
  mousePos.add(player.getX(), player.getY());
  return mousePos;
}