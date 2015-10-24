
class WeaponSystem {
  Ship ship;
  ArrayList<WeaponModule> modules;
  
  WeaponSystem(Ship ship) {
    this.ship = ship;
    modules = new ArrayList<WeaponModule>();
  }
  
  void addWeapon(WeaponModule wMod) {
    modules.add(wMod);
  }
  
  void fire(FWorld world) {
    for (WeaponModule w: modules) {
      world.add(w.fire(ship));
    }
  }
  
  void update() {
    for (WeaponModule w: modules) {
      w.update();
    }
  }
}