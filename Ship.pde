
class Ship extends ThrusterModule {
  ArrayList<Thruster> thrusters;
  int gunCooldown;
  
  GridSystem grid;
  ThrusterSystem thrusterSystem;
  WeaponSystem weaponSystem;
  
  Ship () {
    super();
    
    //Setup Vars
    thrusters = new ArrayList<Thruster>();
    thrusters.add(new Thruster(new PVector(-10, 20), new PVector(0, -200)));
    thrusters.add(new Thruster(new PVector(10, 20), new PVector(0, -200)));
    thrusters.add(new Thruster(new PVector(-10, -20), new PVector(0, 200)));
    thrusters.add(new Thruster(new PVector(10, -20), new PVector(0, 200)));
    
    gunCooldown = 0;
    grid = new GridSystem(this);
    thrusterSystem = new ThrusterSystem(this);
    weaponSystem = new WeaponSystem(this);
  }
  
  void update() {
    if (gunCooldown != 0) gunCooldown--;
    weaponSystem.update();
  }
  
  void fire(FWorld world) {
    weaponSystem.fire(world);
    
    if (gunCooldown == 0 && !grid.positionUsed(0, 1)) {
      PVector vel = new PVector(0, 1);
      vel.setMag(20);
      vel.rotate(getRotation());
      PVector pos = new PVector(getX()+vel.x, getY()+vel.y);
      vel.setMag(5000);
      vel.x += getVelocityX();
      vel.y += getVelocityY();
      
      Bullet bullet = new Bullet();
      bullet.setPosition(pos.x, pos.y);
      bullet.setVelocity(vel.x, vel.y);
      bullet.setRotation(getRotation());
      vel.mult(bullet.getDensity());
      bullet.addForce(-vel.x, -vel.y);
      gunCooldown = 10;
    
      world.add(bullet);
    }
  }
  
  void addModule(Module newMod, PVector position, float rotation) {
    grid.addModule(newMod, (int)position.x, (int)position.y);
    newMod.attachTo(this, (int)position.x*40, (int)position.y*40, rotation);
    newMod.gridPos = new PVector(position.x, position.y);
    newMod.gridRotation = rotation;
    
    if (newMod instanceof ThrusterModule){
      ((ThrusterModule)newMod).setThrusterOrientation(rotation);
      ((ThrusterModule)newMod).updateThrusterPos((int)position.x*40, (int)position.y*40);
      
      thrusterSystem.addThruster((ThrusterModule)newMod);
    }
    
    if (newMod instanceof WeaponModule){
      weaponSystem.addWeapon((WeaponModule)newMod);
    }
    
    thrusterSystem.updateWASDQE();
  }
  
  void drawGrid() {
    for (PVector pos: grid.openPositions) {
      PVector transPos = PVector.mult(pos, 40);
      //transPos.rotate(getRotation());
      pushMatrix();
      fill(0, 0);
      strokeWeight(3);
      stroke(200);
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
  
  PVector getCenterOfMass() {
    PVector numerator = new PVector();
    float denominator = 1;
    
    for(Module b: grid.modules) {
      if (!b.equals(this) && !(b instanceof ThrusterModule)) {
        numerator.add(b.getCenterOfMass());
        denominator++;
      }
    }
    return PVector.div(numerator, denominator);
  }
}