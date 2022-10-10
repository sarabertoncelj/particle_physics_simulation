class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float time;
  float dt;
  float radius;
  float mass;
  PVector min_bound;
  PVector max_bound;
  Space space;

  Particle(PVector spawn_location, PVector initial_v, Type type, Space s) {
    
    velocity = initial_v.copy();
    //PVector direction = PVector.random3D();
    //velocity.x = velocity.x*direction.x;
    //velocity.y = velocity.y*direction.y;
    //velocity.z = velocity.z*direction.z;
    position = spawn_location.copy();
    space = s;
    min_bound = space.get_min();
    max_bound = space.get_max();
    time = 0.0;
    dt=1.0/30.0;
    radius=type.r();
    mass=type.m();
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    time = time+dt;
    
    
    PVector v = velocity.copy();
    v.mult(dt);
    PVector new_position = position.copy();
    new_position.add(v);
    PVector a = space.get_acceleration(mass, new_position);
    a.mult(0.5*dt*dt);
    new_position.add(a);
    
    for (int i = 0;  i<space.radials.size(); i++){
      Radial r = space.radials.get(i);
      PVector r_pos = r.get_position();
      PVector direction1 = PVector.sub(r_pos, position).normalize();
      PVector direction2 = PVector.sub(r_pos, new_position).normalize();
      if(PVector.dot(direction1, direction2) < 0.5){
        velocity.set(0.0, 0.0, 0.0);
        return;
      }
      
    }
    
    if (outbounds(new_position)){
      //velocity.mult(-1);
      collision(new_position);
    }
    else {
      position = new_position.copy();
      PVector a2 = space.get_acceleration(mass, new_position);
      a2.mult(dt);
      velocity.add(a2);
    }
    
  }
  
  void collision(PVector p){
    PVector n = new PVector(0.0,0.0,0.0);
    if (p.x<min_bound.x){n.x=1;}
    if (p.y<min_bound.y){n.y=1;}
    if (p.z<min_bound.z){n.z=1;}
    if (p.x>max_bound.x){n.x=-1;}
    if (p.y>max_bound.y){n.y=-1;}
    if (p.z>max_bound.z){n.z=-1;}
    float dot = PVector.dot(velocity,n);
    PVector vn = PVector.mult(n, dot);
    PVector vt = PVector.sub(velocity, vn);
    PVector v = PVector.sub(vt, vn);
    velocity = v.copy();
  }
  
  boolean outbounds(PVector p){
    if (p.x<min_bound.x || p.y<min_bound.y || p.z<min_bound.z){return true;}
    else if (p.x>max_bound.x || p.y>max_bound.y || p.z>max_bound.z){return true;}
    else {return false;}
  }
  
  PVector current_position(){
    return position;
  }

  // Method to display
  void display() {
    lights();
    push();
    noStroke();
    fill(200);
    translate(position.x, position.y, position.z);
    sphere(radius);
    pop();
  }
}
