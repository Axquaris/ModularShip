
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
    PVector newModPosition;
    if ((int)connectors.x <= 3)
      newModPosition = PVector.mult(anchors.get((int)connectors.x), 2);
    else { //Attach module to module
      newModPosition = PVector.sub(modules.get((int)(connectors.x)/4-1).anchors.get((int)(connectors.x)%4), 
                                   newMod.anchors.get((int)connectors.y));
      newModPosition.add(new PVector(modules.get((int)(connectors.x)/4-1).getX(), 
                                     modules.get((int)(connectors.x)/4-1).getY()));
    }
    
    int newModRotation = 0;
    if (connectors.x % 2 != connectors.y % 2) newModRotation += 90;
    
    newMod.setPosition(newModPosition.x, newModPosition.y);
    newMod.setRotation(radians(newModRotation));
    newMod.attachTo(this);
    
    setAnchorUsed((int)connectors.x, true);
    newMod.anchorUsed[(int)connectors.y] = true;
    modules.add(newMod);
  }
  
  void drawAnchors() {
    ArrayList<PVector> a = getAnchors();
    for (int c = 0; c < a.size(); c++) {
      //if (!anchorUsed(c)) { Gave up trying to hide used anchors
        //if (c > 3) {
        //  a.get(c).rotate(getRotation());
        //  ellipse(getX()+a.get(c).x, getY()+a.get(c).y, 5, 5);
        //}
        //else 
          ellipse(a.get(c).x, a.get(c).y, 5, 5);
      //}
    }
  }
  
  ArrayList<PVector> getAnchors() {
    ArrayList<PVector> anchorPos = super.getAnchors();
    for (Module m: modules) {
      for (PVector p: m.getAnchors()) {
        PVector pos = p;
        pos.rotate(getRotation());
        anchorPos.add(PVector.add(pos, new PVector(getX(), getY())));
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
  
  void setAnchorUsed(int c, boolean b) {
    if (c/4 == 0)
      anchorUsed[c] = b;
    else
      modules.get(c/4 - 1).anchorUsed[c % 4] = b;
  }
  
  void createBody() {
    FPoly core = new FPoly();
    core.vertex(-20, -20);
    core.vertex(-20, 10);
    core.vertex(-10, 20);
    core.vertex(10, 20);
    core.vertex(20, 10);
    core.vertex(20, -20);
    core.setFillColor(color(#000000));
    addBody(core);
  }
}