
class Ship extends FCompound {
  ArrayList<PVector> anchors;
  
  int gunCooldown;
  
  Ship () {
    super();
    
    //Create Core
    FPoly core = new FPoly();
    core.vertex(-20, -20);
    core.vertex(-20, 10);
    core.vertex(-10, 20);
    core.vertex(10, 20);
    core.vertex(20, 10);
    core.vertex(20, -20);
    core.setFillColor(color(#000000));
    addBody(core);
    
    //Set Properties
    setBullet(true);
    setDamping(0);
    setAngularDamping(0);
    setDensity(1);
    setRotation(radians(180)); //Rotate Properly
    
    //Make Anchors
    anchors = new ArrayList<PVector>();
    anchors.add(new PVector(0, 20));
    anchors.add(new PVector(20, 0));
    anchors.add(new PVector(0, -20));
    anchors.add(new PVector(-20, 0));
    
    //
    gunCooldown = 0;
  }
  
  void update() {
    if (gunCooldown != 0) gunCooldown--;
  }
  
  FCompound fire() {
    if (gunCooldown == 0) {
      PVector vel = new PVector(0, 1);
      vel.setMag(20);
      vel.rotate(getRotation());
      PVector pos = new PVector(getX()+vel.x, getY()+vel.y);
      vel.setMag(1000);
      vel.x += getVelocityX();
      vel.y += getVelocityY();
      
      FCompound bullet = createBullet();
      bullet.setPosition(pos.x, pos.y);
      bullet.setVelocity(vel.x, vel.y);
      bullet.setRotation(getRotation());
      
      vel.mult(bullet.getDensity());
      addForce(-vel.x, -vel.y);
      gunCooldown = 10;
    
      return bullet;
    }
    return null;
  }
  
  void drawAnchors() {
    for (PVector a : anchors) {
      PVector pos = new PVector(a.x, a.y);
      pos.rotate(getRotation());
      ellipse(pos.x+getX(), pos.y+getY(), 5, 5);
    }
  }
  
  ArrayList<PVector> getAnchors() {
    ArrayList<PVector> anchorPos = new ArrayList<PVector>();
    
    for (PVector a : anchors) {
      PVector b = new PVector(a.x, a.y);
      b.rotate(getRotation());
      b.add(getX(), getY());
      anchorPos.add(b);
    }
    
    return anchorPos;
  }
}