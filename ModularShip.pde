
import fisica.*;

FWorld world;
Ship player;

boolean showGrid;

Module grabbedMod;
PVector newModPos;
boolean keys[] = new boolean [7];

void setup() {
  size(800, 800);
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
}

void draw() {
  background(255);
  
  PVector f = new PVector(0, 0);
  float r = 0;
  if (keys[0]) f.y += 3000;
  if (keys[1]) r += -70;
  if (keys[2]) f.y += -1000;
  if (keys[3]) r += 70;
  if (keys[4]) f.x += 1000;
  if (keys[5]) f.x += -1000;
  f.rotate(player.getRotation());
  player.addForce(f.x, f.y);
  player.addTorque(r);
  
  if (keys[6]) {
    world.add(player.fire());
  }
  
  world.step();
  player.update();
  
  if (showGrid) {
    newModPos = null;
    for (PVector p: player.grid.openPositions) {
      PVector pos = PVector.mult(p, 40);
      //pos.sub(20, 20);
      pos.rotate(player.getRotation());
      pos.add(player.getX(), player.getY());
      line(pos.x, pos.y, grabbedMod.getX(), grabbedMod.getY());
      pos.sub(grabbedMod.getX(), grabbedMod.getY());
      if (pos.mag() < 20) {
        newModPos = new PVector(p.x, p.y);
        break;
      }
    }
    
    player.drawGrid();
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
      world.remove(player);
      
      player.addModule(grabbedMod, newModPos);
      
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
  if (key == 'n') {
    Module m = new Module();
    m.setPosition(width/2, height*3/4);
    world.add(m);
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

FCompound createBullet() {
  FCircle head = new FCircle(8);
  head.setFillColor(color(#000000));
  
  FBox body = new FBox(8, 15);
  body.setPosition(0, -8); 
  
  FCompound bullet = new FCompound();
  bullet.addBody(head);
  bullet.addBody(body);
  
  bullet.setGrabbable(false);
  bullet.setBullet(true);
  bullet.setDensity(.1);
  bullet.setDamping(0);
  bullet.setAngularDamping(0);
  
  return bullet;
}