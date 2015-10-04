
import fisica.*;

FWorld world;
Ship player;

boolean showAnchors;
PVector lastConnectable;

Module grabbedMod;
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
  showAnchors = false;
}

void draw() {
  background(255);
  
  PVector f = new PVector(0, 0);
  float r = 0;
  if (keys[0]) f.y += 2000;
  if (keys[1]) r += -30;
  if (keys[2]) f.y += -800;
  if (keys[3]) r += 30;
  if (keys[4]) f.x += 800;
  if (keys[5]) f.x += -800;
  f.rotate(player.getRotation());
  player.addForce(f.x, f.y);
  player.addTorque(r);
  
  if (keys[6]) {
    world.add(player.fire());
  }
  
  world.step();
  player.update();
  world.draw(this);
  
  if (showAnchors) {
    ArrayList<PVector> grabbedAnchors = grabbedMod.getAnchors();
    ArrayList<PVector> playerAnchors = player.getAnchors();
    float closestPairDist = 9999;
    int a = 0;
    int b = 0;
    
    for (int i = 0; i < playerAnchors.size(); i++) {
      for (int j = 0; j < grabbedAnchors.size(); j++) {
        PVector distance = PVector.sub(playerAnchors.get(i), grabbedAnchors.get(j));
        if (distance.mag() < closestPairDist) {
          closestPairDist = distance.mag();
          a = i;
          b = j;
        }
      }
    }
    
    if ( closestPairDist < 40) {
      line( playerAnchors.get(a).x, playerAnchors.get(a).y, 
           grabbedAnchors.get(b).x, grabbedAnchors.get(b).y );
      lastConnectable = new PVector(a, b);
    }
    player.drawAnchors();
    grabbedMod.drawAnchors();
  }
}

void mousePressed() {
  FBody b = world.getBody(mouseX, mouseY);
  if ((b instanceof Module)) {
    grabbedMod = (Module)b;
    showAnchors = true;
  }
}

void mouseReleased() {
  if (showAnchors) {
    showAnchors = false;
    
    //Link
    FDistanceJoint link = new FDistanceJoint(player, grabbedMod);
    link.setLength(0);
    link.setAnchor1(player.anchors.get((int)lastConnectable.x).x,
                    player.anchors.get((int)lastConnectable.x).y);
    link.setAnchor2(grabbedMod.anchors.get((int)lastConnectable.y).x,
                    grabbedMod.anchors.get((int)lastConnectable.y).y);
    world.add(link);
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
  bullet.setDensity(.25);
  bullet.setDamping(0);
  bullet.setAngularDamping(0);
  
  return bullet;
}