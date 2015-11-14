
class SmartShip extends Ship {
  
  SmartShip() {
    super();
  }
  
  void update() {
    super.update();
    float toRot = angleToPlayer();
    float toDist = distanceToPlayer();
    if (frame % 1 == 0) {
      if (toRot > 0)
        thrusterSystem.fireThrusters("D");
      else if (toRot < 0)
        thrusterSystem.fireThrusters("A");
    }
    if (toDist > 500 && abs(toRot) < PI/8)
      thrusterSystem.fireThrusters("W");
    if (abs(toRot) < PI/8 && toDist < 1000) fire(world);
  }
  
  /*
    SENSORS
      These functions return information about how the ship sees something around it
      Includes: angle to player, distance to player
  */
  float angleToPlayer() {
    PVector sPos = sensePosition(player.getX(), player.getY());
    float toRot = atan2(sPos.x, sPos.y);
    
    //Returns PI to -PI
    return -toRot;
  }
  
  float distanceToPlayer() {
    PVector sPos = sensePosition(player.getX(), player.getY());
    return sPos.mag();
  }
  
  /*
    INTERPRETERS
      These functions take in data and return how the ship senses it,
        they also serve as submethods for the SENSOR methods
      Includes: x, y or PVector to position
  */
  PVector sensePosition(PVector coords) {
    coords.add(-getX(), -getY());
    coords.rotate(-getRotation());
    return coords;
  }

  PVector sensePosition(float x, float y) {
    return sensePosition(new PVector(x, y));
  }
  
  //Small modification of Ship class's removeModule()
  SmartShip removeModule(Module mod) {
    grid.removeModule(mod);
    if (mod instanceof ThrusterModule)
      thrusterSystem.removeThruster((ThrusterModule)mod);
    else if (mod instanceof WeaponModule)
      weaponSystem.removeWeapon((WeaponModule)mod);
    
    SmartShip child = new SmartShip();
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
}