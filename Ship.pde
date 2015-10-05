
class Ship extends FCompound {
  PVector dimensions;
  ArrayList<PVector> anchors;
  boolean[] anchorUsed;
  ArrayList<Module> modules;
  
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
    dimensions = new PVector(40, 40);
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
    modules = new ArrayList<Module>();
    anchorUsed = new boolean[4];
    for (int c = 0; c < anchorUsed.length; c++) anchorUsed[c] = false;
    
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
      vel.setMag(5000);
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
  
  void addModule(Module newMod, PVector connectors) {
    PVector anchor1 = anchors.get((int)connectors.x); //Ship anchor
    PVector anchor2 = newMod.anchors.get((int)connectors.y); //NewMod anchor
    PVector newModPosition = PVector.mult(anchor1, 2);
    int newModRotation = 0;
    
    if (connectors.x % 2 != connectors.y % 2) newModRotation = 90;
      
    newMod.setPosition(newModPosition.x, newModPosition.y);
    newMod.setRotation(radians(newModRotation));
    newMod.attachTo(this);
    
    modules.add(newMod);
    anchorUsed[(int)connectors.x] = true;
  }
  
  void drawAnchors() {
    for (int c = 0; c < anchors.size(); c++) {
      if (!anchorUsed[c]) {
        PVector pos = new PVector(anchors.get(c).x, anchors.get(c).y);
        pos.rotate(getRotation());
        ellipse(pos.x+getX(), pos.y+getY(), 5, 5);
      }
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