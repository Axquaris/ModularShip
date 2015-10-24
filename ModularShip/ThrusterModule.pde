
class ThrusterModule extends Module{
  ArrayList<Thruster> thrusters;
  
  ThrusterModule() {
    super();
    
    thrusters = new ArrayList<Thruster>();
    thrusters.add(new Thruster(new PVector(0, 0), new PVector(0, 1000)));
    
    hp = 50;
  }
  
  void attachTo(Ship ship, int x, int y, float r) {
    PVector p1 = new PVector(0, dimensions.y*(.4));
    p1.rotate(r);
    PVector p2 = new PVector(0, dimensions.y*(.2));
    p2.rotate(r);
    
    FBox a = new FBox(dimensions.x*.6, dimensions.y*.2);
    a.setPosition(x + p1.x, y + p1.y);
    a.setRotation(r);
    ship.addBody(a);
    FBox b = new FBox(dimensions.x*.8, dimensions.y*.2);
    b.setPosition(x + p2.x, y+ p2.y);
    b.setRotation(r);
    ship.addBody(b);
  }
  
  void createBody() {
    FBox a = new FBox(dimensions.x*.6, dimensions.y*.2);
    a.setPosition(0, dimensions.y*(.4));
    addBody(a);
    FBox b = new FBox(dimensions.x*.8, dimensions.y*.2);
    b.setPosition(0, dimensions.y*(.2));
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
    rect(-20 +dimensions.x*.2, -20 +dimensions.y*(.8), dimensions.x*.6, dimensions.y*.2);
    rect(-20 +dimensions.x*.1, -20 +dimensions.y*(.6), dimensions.x*.8, dimensions.y*.2);
    popMatrix();
  }
  
  void setThrusterOrientation(float rotation) {
    for (Thruster t: thrusters)
      t.orientation = rotation;
  }
  
  void updateThrusterPos(int x, int y) {
    for (Thruster t: thrusters)
      t.position.add(x, y);
  }
}