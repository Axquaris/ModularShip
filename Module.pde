

class Module extends FCompound {
  PVector dimensions;
  ArrayList<PVector> anchors;
  boolean[] anchorUsed;
  
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
    
    //Make Anchors
    anchors = new ArrayList<PVector>();
    anchors.add(new PVector(0, 20));
    anchors.add(new PVector(20, 0));
    anchors.add(new PVector(0, -20));
    anchors.add(new PVector(-20, 0));
    anchorUsed = new boolean[4];
    for (int c = 0; c < anchorUsed.length; c++) anchorUsed[c] = false;
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
    for (int c = 0; c < anchors.size(); c++) {
      if (!anchorUsed[c]) {
        PVector pos = new PVector(anchors.get(c).x, anchors.get(c).y);
        pos.rotate(getRotation());
        ellipse(pos.x+getX(), pos.y+getY(), 5, 5);
      }
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
  
  boolean anchorUsed(int c) {
    return anchorUsed[c];
  }
  
  void createBody() {
    FBox a = new FBox(dimensions.x*0.75, dimensions.y);
    addBody(a);
    FBox b = new FBox(dimensions.x, dimensions.y*0.75);
    addBody(b);
  }
}