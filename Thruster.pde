
class Thruster {
  PVector position;
  PVector force;
  
  Thruster(PVector position, PVector force) {
    this.position = position;
    this.force = force;
  }
  
  void propel(Ship ship, float orientation) {
    PVector f = new PVector(force.x, force.y).rotate(orientation);
    ship.addForce(f.x, f.y ,position.x, position.y);
  }
}