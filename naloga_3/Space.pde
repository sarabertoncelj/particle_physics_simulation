class Space {
  PVector min_bound;
  PVector max_bound;
  PVector gravity;
  PVector wind;
  float scale;
  ArrayList<Radial> radials = new ArrayList<>();
  
  Space(PVector min, PVector max, float s) {
    min_bound=min.copy();
    max_bound=max.copy();
    gravity=new PVector(0.0,0.0,0.0);
    wind=new PVector(0.0,0.0,0.0);
    scale = s;
  }
  void set_gravity(PVector g){
    gravity=g.copy(); 
  }
  
  void set_wind(PVector w){
    wind=w.copy(); 
  }
  void add_radial(Radial r){
    radials.add(r); 
  }
  float get_scale(){
    return this.scale;
  }
  PVector get_min() {
    return this.min_bound;
  }
  PVector get_max() {
    return this.max_bound;
  }
  PVector radial_force (PVector position, Radial r){
    PVector radial_position = r.get_position();
    float distance = PVector.dist(radial_position, position);
    distance = distance/scale;
    
    float strength = r.get_strength();
    if (strength > 0){
        strength = strength/(distance*distance);
        PVector force = PVector.sub(radial_position, position);
        force.normalize();
        force.mult(strength);
        return (force);
    }else if (strength < 0){
        strength = strength/(distance*distance);
        PVector force = PVector.sub(position, radial_position);
        force.normalize();
        force.mult(-strength);
        return (force);
    }
    else{
      return (new PVector (0.0, 0.0, 0.0));
    }
  }
  PVector get_acceleration(float mass, PVector position) {
    PVector acc_wind = wind.copy();
    acc_wind.div(mass);
    PVector acc = PVector.add(gravity, acc_wind);
    for (int i = 0;  i<radials.size(); i++){
      Radial r = radials.get(i);
      PVector acc_rad = radial_force(position, r);
      acc_rad.div(mass);
      println(acc_rad);
      acc.add(acc_rad);
    }
    return acc.mult(scale);
  }
}
