

class Module extends FCompound {
  ArrayList<PVector> anchors;
  
  Module () {
    super();
    
    //Create Core
    FBox a = new FBox(20, 40);
    addBody(a);
    FBox b = new FBox(40 ,20);
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