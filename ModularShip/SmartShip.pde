
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
  
  //Sensors
  float angleToPlayer() {
    float thisR = radians((int)(degrees(getRotation())) % 360) + PI/2;
    if (thisR < -PI) thisR += PI*2;
    else if (thisR > PI) thisR -= PI*2;
    float toR = atan2(player.getY()-getY(), player.getX()-getX()) - thisR;
    if (toR < -PI) toR += PI*2;
    else if (toR > PI) toR -= PI*2;
    //println(degrees(toR)); //DEBUG
    
    return toR;
  }
  
  float distanceToPlayer() {
    PVector dist = new PVector(getX(), getY());
    dist.sub(new PVector(player.getX(), player.getY()));
    return dist.mag();
  }
  
  SmartShip removeModule(Module mod) {
    grid.removeModule(mod);
    if (mod instanceof ThrusterModule)
      thrusterSystem.removeThruster((ThrusterModule)mod);
    else if (mod instanceof WeaponModule)
      weaponSystem.removeWeapon((WeaponModule)mod);
    
    SmartShip child = new SmartShip();
    child.grid = grid;
    child.thrusterSystem = thrusterSystem;
    child.weaponSystem = weaponSystem;
    for (Module m: child.grid.modules) {
      if (!(m instanceof Ship))
        m.attachTo(child, (int)m.gridPos.x*40, (int)m.gridPos.y*40, m.gridRotation);
    }
    child.thrusterSystem.updateWASDQE();
    child.setPosition(getX(), getY());
    child.setVelocity(getVelocityX(), getVelocityY());
    child.setRotation(getRotation());
    child.setAngularVelocity(getAngularVelocity());
    child.grid.modules.set(0, child);
    child.grid.modulePositions.set(0, new PVector(0, 0));
    child.thrusterSystem.modules.set(0, child);
    
    return child;
  }
}