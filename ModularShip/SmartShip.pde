
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
}