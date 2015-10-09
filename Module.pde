

class Module extends FCompound {
  PVector dimensions;
  
  PVector gridPos;
  float gridRotation;
  
  Module () {
    super();
    
    //Set Properties
    dimensions = new PVector(40, 40);
    setBullet(true);
    setDamping(0);
    setAngularDamping(0);
    setDensity(0.1);
    setRotation(radians(180)); //Rotate Properly
    
    //Create Body
    createBody();
  }
  
  void attachTo(Ship ship, int x, int y) {
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    a.setPosition(x, y);
    a.setRotation(0);
    b.setPosition(x, y);
    b.setRotation(0);
    ship.addBody(a);
    ship.addBody(b);
  }
  
  void createBody() {
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    addBody(a);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    addBody(b);
  }
}