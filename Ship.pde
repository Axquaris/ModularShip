
class Ship extends Module {
  ArrayList<Module> modules;
  int gunCooldown;
  
  Ship () {
    super();
    
    //Setup Vars
    modules = new ArrayList<Module>();
    gunCooldown = 0;
  }
  
  void update() {
    if (gunCooldown != 0) gunCooldown--;
  }
  
  FCompound fire() {
    if (gunCooldown == 0 && !anchorUsed[0]) {
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
    //PVector anchor2 = newMod.anchors.get((int)connectors.y); //NewMod anchor
    PVector newModPosition = PVector.mult(anchor1, 2);
    int newModRotation = 0;
    
    if (connectors.x % 2 != connectors.y % 2) newModRotation += 90;
    else if (connectors.x == connectors.y) newModRotation += 180;
    /*if ((connectors.x == 0 && connectors.y == 3) ||
        (connectors.x == 1 && connectors.y == 0) ||
        (connectors.x == 2 && connectors.y == 1) ||
        (connectors.x == 3 && connectors.y == 2)
    ) newModRotation += 90;*/
      
    newMod.setPosition(newModPosition.x, newModPosition.y);
    newMod.setRotation(radians(newModRotation));
    newMod.attachTo(this);
    
    anchorUsed[(int)connectors.x] = true;
    newMod.anchorUsed[(int)connectors.y] = true;
    modules.add(newMod);
  }
  
  void drawAnchors() {
    super.drawAnchors();
    for (Module m: modules) {
      m.drawAnchors(getX(), getY(), getRotation());
    }
  }
  
  ArrayList<PVector> getAnchors() {
    ArrayList<PVector> anchorPos = super.getAnchors();
    for (Module m: modules) {
      for (PVector p: m.getAnchors()) {
        anchorPos.add(p);
      }
    }
    
    return anchorPos;
  }
  
  boolean anchorUsed(int c) {
    if (c/4 == 0)
      return anchorUsed[c];
    else
      return modules.get(c/4 - 1).anchorUsed(c % 4);
  }
  
  void createBody(FCompound target) {
    FPoly core = new FPoly();
    core.vertex(-20, -20);
    core.vertex(-20, 10);
    core.vertex(-10, 20);
    core.vertex(10, 20);
    core.vertex(20, 10);
    core.vertex(20, -20);
    core.setFillColor(color(#000000));
    target.addBody(core);
  }
}