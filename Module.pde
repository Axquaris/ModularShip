
class Module extends FCompound {
  PVector dimensions;
  
  PVector gridPos;
  float gridRotation;
  
  Module () {
    super();
    
    //Set Properties
    dimensions = new PVector(40, 40);
    gridPos = new PVector();
    setBullet(true);
    setDamping(0);
    setAngularDamping(0);
    setDensity(0.1);
    setRotation(radians(180)); //Rotate Properly
    
    //Create Body
    createBody();
  }
  
  void attachTo(Ship ship, int x, int y, float r) {
    gridPos = new PVector(x/40, y/40);
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    a.setPosition(x, y);
    a.setRotation(r);
    b.setPosition(x, y);
    b.setRotation(r);
    ship.addBody(a);
    ship.addBody(b);
  }
  
  void createBody() {
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    addBody(a);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    addBody(b);
  }
  
  void drawGhost(Ship parent, PVector p, float rotation, float c) {
    PVector position = PVector.mult(p, 40);
    
    pushMatrix();
    fill(255);
    strokeWeight(2);
    stroke(c);
    translate(parent.getX(), parent.getY());
    rotate(parent.getRotation());
    translate(position.x, position.y);
    rotate(rotation);
    rect(dimensions.x*.125-20, -20, dimensions.x*0.75, dimensions.y);
    rect(-20, dimensions.y*.125-20, dimensions.x, dimensions.y*0.75);
    popMatrix();
  }
  
  PVector getCenterOfMass() {
    return new PVector(gridPos.x*40, gridPos.y*40);
  }
}