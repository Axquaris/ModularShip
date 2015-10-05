

class Module extends FCompound {
  PVector dimensions;
  ArrayList<PVector> anchors;
  
  Module () {
    super();
    
    //Set Dimensions
    dimensions = new PVector(40, 40);
    
    //Create Core
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    addBody(a);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    addBody(b);
    
    //Set Properties
    setBullet(true);
    setDamping(0);
    setAngularDamping(0);
    setDensity(0.1);
    setRotation(radians(180)); //Rotate Properly
    
    //Make Anchors
    anchors = new ArrayList<PVector>();
    anchors.add(new PVector(0, 20));
    anchors.add(new PVector(20, 0));
    anchors.add(new PVector(0, -20));
    anchors.add(new PVector(-20, 0));
    
  }
  
  void attachTo(Ship ship) {
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    a.setPosition(getX(), getY());
    a.setRotation(getRotation());
    b.setPosition(getX(), getY());
    b.setRotation(getRotation());
    ship.addBody(a);
    ship.addBody(b);
  }
  
  void drawAnchors() {
    for (PVector a : anchors) {
      PVector pos = new PVector(a.x, a.y);
      pos.rotate(getRotation());
      ellipse(pos.x+getX(), pos.y+getY(), 5, 5);
    }
  }
  
  ArrayList<PVector> getAnchors() {
    ArrayList<PVector> anchorPos = new ArrayList<PVector>();
    
    for (PVector a : anchors) {
      PVector b = new PVector(a.x, a.y);
      b.rotate(getRotation());
      b.add(getX(), getY());
      anchorPos.add(b);
    }
    
    return anchorPos;
  }
}