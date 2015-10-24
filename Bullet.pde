
class Bullet extends FCompound{
  Bullet() {
    super();
    
    FCircle head = new FCircle(8);
    head.setFillColor(color(#000000));
    
    FBox body = new FBox(8, 15);
    body.setPosition(0, -8); 
    
    addBody(head);
    addBody(body);
    
    setGrabbable(false);
    setBullet(true);
    setDensity(.1);
    setDamping(0);
    setAngularDamping(0);
  }
  
  @Override
  public String toString() {
    return "Bullet";
  }
}