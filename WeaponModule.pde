
class WeaponModule extends Module{
  int gunCooldown;
  
  WeaponModule() {
    super();
    
    gunCooldown = 0;
  }
  
  FCompound fire(Ship ship) {
    if (gunCooldown == 0 && !ship.grid.weaponFireable((int)gridPos.x, (int)gridPos.y, (int)gridRotation)) {
      PVector vel = new PVector(0, 1);
      vel.setMag(20);
      vel.rotate(ship.getRotation()+gridRotation+PI);
      PVector pos = new PVector(gridPos.x*40, gridPos.y*40);
      
      pos.rotate(ship.getRotation());
      pos.add(ship.getX()+vel.x, ship.getY()+vel.y);
      vel.setMag(5000);
      vel.x += ship.getVelocityX();
      vel.y += ship.getVelocityY();
      
      FCompound bullet = createBullet();
      bullet.setPosition(pos.x, pos.y);
      bullet.setVelocity(vel.x, vel.y);
      bullet.setRotation(ship.getRotation()+gridRotation+PI);
      vel.mult(bullet.getDensity());
      bullet.addForce(-vel.x, -vel.y);
      gunCooldown = 10;
      
      return bullet;
    }
    return null;
  }
  
  void update() {
    if (gunCooldown > 0) {
      gunCooldown--;
    }
  }
  
  void attachTo(Ship ship, int x, int y, float r) {
    PVector p1 = new PVector(0, dimensions.y*(.4));
    p1.rotate(r);
    PVector p2 = new PVector(0, 0);
    p2.rotate(r);
    
    FBox a = new FBox(dimensions.x*.4, dimensions.y*.2);
    a.setPosition(x + p1.x, y + p1.y);
    a.setRotation(r);
    ship.addBody(a);
    FBox b = new FBox(dimensions.x*.3, dimensions.y*.6);
    b.setPosition(x + p2.x, y+ p2.y);
    b.setRotation(r);
    ship.addBody(b);
  }
  
  void createBody() {
    FBox a = new FBox(dimensions.x*.4, dimensions.y*.2);
    a.setPosition(0, dimensions.y*(.4));
    addBody(a);
    FBox b = new FBox(dimensions.x*.3, dimensions.y*.6);
    b.setPosition(0, 0);
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
    rect(-20 +dimensions.x*(.3), -20 +dimensions.y*(.8), dimensions.x*.4, dimensions.y*.2);
    rect(-20 +dimensions.x*(.35), -20 +dimensions.x*(.2), dimensions.x*.3, dimensions.y*.6);
    popMatrix();
  }
}