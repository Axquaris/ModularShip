
class SmartShip extends Ship {
  
  NeuralNetwork brain;
  int brainType;
  final static int NOBRAIN = 0;
  final static int TURRET = 1;
  
  SmartShip(int brainType) {
    super();
    
    this.brainType = brainType;
    switch (brainType) {
      case NOBRAIN:
        break;
      case TURRET:
        brain = new NeuralNetwork(2, 1);
        brain.input[0] = new Buffer();
        brain.input[1] = new Buffer();
        
        NeuralLayer layer1 = new NeuralLayer(2);
        
        Neuron n1 = new Neuron(1);
        n1.addInput(brain.input[0], 1);
        layer1.addNeuron(n1);
        
        Neuron n2 = new Neuron(1);
        n2.addInput(brain.input[1], 1);
        layer1.addNeuron(n2);
        
        brain.addLayer(layer1);
        break;
      default: break;
    }
    
  }
  
  SmartShip() {
    this(NOBRAIN);
  }
  
  void update() {
    super.update();
    
    switch (brainType) {
      case NOBRAIN:
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
        if (abs(toRot) < PI/8 && toDist < 1000) fire();
        break;
      case TURRET:
        //Send brain sensory inputs
        brain.input[0].output = angleToPlayer()/TWO_PI;
        brain.input[1].output = 1/pow(distanceToPlayer()/100, 2)/10;
        
        //Activate brain
        brain.process();
        
        //Do actions
        if(brain.output.neurons[0].output < -brain.output.neurons[1].output)
          thrusterSystem.fireThrusters("A");
        else if(brain.output.neurons[0].output > brain.output.neurons[1].output)
          thrusterSystem.fireThrusters("D");
        else
          fire();
        break;
      default: break;
    }
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
    
    SmartShip child = new SmartShip(brainType);
    child.setPosition(getX(), getY());
    child.setVelocity(getVelocityX(), getVelocityY());
    child.setRotation(getRotation());
    child.setAngularVelocity(getAngularVelocity());
    child.brain = brain;
    
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