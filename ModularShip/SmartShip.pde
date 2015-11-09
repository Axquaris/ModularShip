
class SmartShip extends Ship {
  
  //Angle Sensor Vars
  //int hysteresis;
  //float lastToR;
  
  SmartShip() {
    super();
    
    //Angle Sensor Vars
    //hysteresis = 0;
    //lastToR = 0;
  }
  
  void update() {
    super.update();
    float toR = angleToPlayer();
    if (frame % 3 == 0) {
      if (toR > 0)
        thrusterSystem.fireThrusters("D");
      else if (toR < 0)
        thrusterSystem.fireThrusters("A");
    }
    //if (abs(toR) < PI/8) fire(world); //DEBUGGING
  }
  
  //Sensors
  float angleToPlayer() {
    float thisR = radians((int)(degrees(getRotation())) % 360) + PI/2;
    if (thisR < -PI) thisR += PI*2;
    else if (thisR > PI) thisR -= PI*2;
    float toR = atan2(player.getY()-getY(), player.getX()-getX()) - thisR;
    println(degrees(toR));
    
    return toR;
  }
}