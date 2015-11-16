
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
  void removeWeapon(WeaponModule wMod) {
    modules.remove(wMod);
  }
  
  void fire() {
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