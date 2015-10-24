
class ThrusterSystem implements Serializable{
  ArrayList<ThrusterModule> modules;
  ArrayList<Thruster> allThrusters;
  ArrayList<Thruster> w; //Thrusters fired when W pressed
  ArrayList<Thruster> a; //Thrusters fired when A pressed
  ArrayList<Thruster> s; //                     S
  ArrayList<Thruster> d; //                     D
  ArrayList<Thruster> q; //                     Q
  ArrayList<Thruster> e; //                     E
  
  ThrusterSystem(Ship ship) {
    modules = new ArrayList<ThrusterModule>();
    allThrusters = new ArrayList<Thruster>();
    
    modules.add(ship);
    for (Thruster t: ship.thrusters)
      allThrusters.add(t);
    updateWASDQE();
  }
  
  void addThruster(ThrusterModule tMod){
    modules.add(tMod);
    for (Thruster t: tMod.thrusters)
      allThrusters.add(t);
    updateWASDQE();
  }
  
  void fireThrusters(String str){
    str = str.toUpperCase();
    ArrayList<Thruster> firedThrusters = new ArrayList<Thruster>();
    
    if(str.indexOf("W") != -1) {
      for(Thruster t: w){
        t.propel((Ship)modules.get(0));
        firedThrusters.add(t);
      }
    }
    if(str.indexOf("A") != -1) {
      for(Thruster t: a){
        if(firedThrusters.indexOf(t) == -1) {
          t.propel((Ship)modules.get(0));
          firedThrusters.add(t);
        }
      }
    }
    if(str.indexOf("S") != -1) {
      for(Thruster t: s){
        if(firedThrusters.indexOf(t) == -1) {
          t.propel((Ship)modules.get(0));
          firedThrusters.add(t);
        }
      }
    }
    if(str.indexOf("D") != -1) {
      for(Thruster t: d){
        if(firedThrusters.indexOf(t) == -1) {
          t.propel((Ship)modules.get(0));
          firedThrusters.add(t);
        }
      }
    }
    if(str.indexOf("Q") != -1) {
      for(Thruster t: q){
        if(firedThrusters.indexOf(t) == -1) {
          t.propel((Ship)modules.get(0));
          firedThrusters.add(t);
        }
      }
    }
    if(str.indexOf("E") != -1) {
      for(Thruster t: e){
        if(firedThrusters.indexOf(t) == -1) {
          t.propel((Ship)modules.get(0));
          firedThrusters.add(t);
        }
      }
    }
  }
  
  void updateWASDQE() {
    PVector ctrMass = modules.get(0).getCenterOfMass();
    w = new ArrayList<Thruster>();
    a = new ArrayList<Thruster>();
    s = new ArrayList<Thruster>();
    d = new ArrayList<Thruster>();
    q = new ArrayList<Thruster>();
    e = new ArrayList<Thruster>();
    
    for (Thruster t: allThrusters) {
      PVector force = t.getForce();
      if(force.y > 100) {
        w.add(t);
        if(t.position.x < ctrMass.x)
          a.add(t);
        else if(t.position.x > ctrMass.x)
          d.add(t);
      }
      else if(force.y < -100) {
        s.add(t);
        if(t.position.x < ctrMass.x)
          d.add(t);
        else if(t.position.x > ctrMass.x)
          a.add(t);
      }
      else if(force.x > 100) {
        q.add(t);
        if(t.position.y < ctrMass.y)
          d.add(t);
        else if(t.position.y > ctrMass.y)
          a.add(t);
      }
      else if(force.x < -100) {
        e.add(t);
        if(t.position.y < ctrMass.y)
          a.add(t);
        else if(t.position.y > ctrMass.y)
          d.add(t);
      }
    }
  }
}