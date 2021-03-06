
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
    
    hp = 200;
  }
  
  void update() {
    if (gunCooldown != 0) gunCooldown--;
    weaponSystem.update();
  }
  
  void fire() {
    weaponSystem.fire();
    
    if (gunCooldown == 0 && !grid.positionUsed(0, 1)) {
      PVector force = new PVector(0, 1);
      force.setMag(40);
      force.rotate(getRotation());
      PVector pos = new PVector(getX()+force.x, getY()+force.y);
      force.setMag(5000);
      
      Bullet bullet = new Bullet();
      bullet.setPosition(pos.x, pos.y);
      bullet.setRotation(getRotation());
      
      bullet.setVelocity(getVelocityX(), getVelocityY());
      bullet.addForce(force.x, force.y);
      addForce(-force.x, -force.y);
      
      gunCooldown = 10;
      world.add(bullet);
    }
  }
  
  void addModule(Module newMod, PVector position, float rotation) {
    resetForces(); //Prevent weird block adding recoil
    
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
  
  Ship removeModule(Module mod) {
    grid.removeModule(mod);
    if (mod instanceof ThrusterModule)
      thrusterSystem.removeThruster((ThrusterModule)mod);
    else if (mod instanceof WeaponModule)
      weaponSystem.removeWeapon((WeaponModule)mod);
    
    Ship child = new Ship();
    child.setPosition(getX(), getY());
    child.setVelocity(getVelocityX(), getVelocityY());
    child.setRotation(getRotation());
    child.setAngularVelocity(getAngularVelocity());
    
    child.grid = grid;
    child.thrusterSystem = thrusterSystem;
    child.weaponSystem = weaponSystem;
    for (Module m: child.grid.modules) {
      if (!(m instanceof Ship))
        m.attachTo(child, (int)m.gridPos.x*40, (int)m.gridPos.y*40, m.gridRotation);
    }
    child.thrusterSystem.updateWASDQE();
    
    child.grid.modules.set(0, child);
    child.grid.modulePositions.set(0, new PVector(0, 0));
    child.thrusterSystem.modules.set(0, child);
    child.weaponSystem.ship = child;
    
    return child;
  }
  
  void drawGrid() {
    for (PVector pos: grid.openPositions) {
      PVector transPos = PVector.mult(pos, 40);
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