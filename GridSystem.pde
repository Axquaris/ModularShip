
class GridSystem {
  ArrayList<Module> modules;
  ArrayList<PVector> modulePositions; //Index corresponds with module location in modules
  ArrayList<PVector> openPositions; //Positions that a module can be attached to
  
  GridSystem(Ship ship) {
    modules = new ArrayList<Module>();
    modulePositions = new ArrayList<PVector>();
    openPositions = new ArrayList<PVector>();
    
    modules.add(ship);
    modulePositions.add(new PVector());
    openPositions = new ArrayList<PVector>();
    openPositions.add(new PVector(1, 0));
    openPositions.add(new PVector(-1, 0));
    openPositions.add(new PVector(0, 1));
    openPositions.add(new PVector(0, -1));
  }
  
  void addModule(Module module, int x, int y) {
    if (positionOpen(x, y)) {
      //Close position
      openPositions.remove(new PVector(x, y));
      
      //Add module to grid
      modules.add(module);
      modulePositions.add(new PVector(x, y));
      
      //Update open positions
      if (!(module instanceof ThrusterModule) && !(module instanceof WeaponModule)) {
        if (positionBlank(x+1, y)) openPositions.add(new PVector(x+1, y));
        if (positionBlank(x-1, y)) openPositions.add(new PVector(x-1, y));
        if (positionBlank(x, y+1)) openPositions.add(new PVector(x, y+1));
        if (positionBlank(x, y-1)) openPositions.add(new PVector(x, y-1));
      }
    }
  }
  
  void removeModule (int x, int y) {
    //Lookup index of module
    int index = modulePositions.indexOf(new PVector(x, y));
    
    //Make sure there is a module present
    if (index != -1) {
      modulePositions.remove(index);
      openPositions.add(new PVector(x, y));
      
      //Update open positions
      updatePosition(x+1, y);
      updatePosition(x-1, y);
      updatePosition(x, y+1);
      updatePosition(x, y-1);
    }
  }
  
  //Determines whether a grid position is "OPEN"
  boolean positionOpen(int x, int y) {
    for (PVector position: openPositions) {
      if (Math.round(position.x) == x && Math.round(position.y) == y)
        return true;
    }
    return false;
  }
  
  //Determines whether a module is using a grid position
  boolean positionUsed(int x, int y) {
    for (PVector position: modulePositions) {
      if (Math.round(position.x) == x && Math.round(position.y) == y)
        return true;
    }
    return false;
  }
  
  //Determines whether a grid position is "BLANK"
  boolean positionBlank(int x, int y) {
    if (positionOpen(x, y) || positionUsed(x, y))
      return false;
    return true;
  }
  
  //Updates positions (fixes invalid open spots)
  void updatePosition(int x, int y) {
    if (positionOpen(x, y)) {
      if (!positionUsed(x+1, y) && !positionUsed(x-1, y) && 
          !positionUsed(x, y+1) && !positionUsed(x, y-1)) {
        openPositions.remove(new PVector(x, y));
      }
    }
  }
  
  //Tells whether a thruster with given rotation can be added to a position
  boolean thrusterAttachable(int x, int y, int rotation) {
    if (rotation == 0)
      y += 1;
    else if (rotation == 90)
      x -= 1;
    else if (rotation == 180)
      y -= 1;
    else if (rotation == 270)
      x += 1;
    else
      return false;
    
    if (positionUsed(x, y) && !(getModuleAt(x, y) instanceof WeaponModule)
        && (!(getModuleAt(x, y) instanceof ThrusterModule) || (getModuleAt(x, y) instanceof Ship)))
      return true;
    return false;
  }
  
  boolean weaponFireable(int x, int y, int rotation) {
    if (rotation == 0)
      y -= 1;
    else if (rotation == 90)
      x += 1;
    else if (rotation == 180)
      y += 1;
    else if (rotation == 270)
      x -= 1;
    else
      return false;
    return positionUsed(x, y);
  }
  
  Module getModuleAt(int x, int y) {
    return modules.get(modulePositions.indexOf(new PVector(x, y)));
  }
}