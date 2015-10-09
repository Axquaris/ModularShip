
class Ship extends Module {
  ArrayList<Module> modules;
  int gunCooldown;
  
  ShipGrid grid;
  
  Ship () {
    super();
    
    //Setup Vars
    modules = new ArrayList<Module>();
    gunCooldown = 0;
    grid = new ShipGrid(this);
  }
  
  void update() {
    if (gunCooldown != 0) gunCooldown--;
  }
  
  FCompound fire() {
    if (gunCooldown == 0 && !grid.positionUsed(0, 1)) {
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
  
  void addModule(Module newMod, PVector position) {
    grid.addModule(newMod, (int)position.x, (int)position.y);
    newMod.attachTo(this, (int)position.x*40, (int)position.y*40);
  }
  
  void drawGrid() {
    for (PVector pos: grid.openPositions) {
      PVector transPos = PVector.mult(pos, 40);
      //transPos.rotate(getRotation());
      pushMatrix();
      fill(0, 0);
      translate(getX(), getY());
      rotate(getRotation());
      rect(transPos.x-20, transPos.y-20, 40, 40);
      popMatrix();
    }
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