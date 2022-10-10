class Emitter {
  PVector postition;
  PVector min_velocity;
  PVector max_velocity;
  PVector gravity;
  PVector wind;
  ArrayList<Radial> radials;
  Space space;
  int count;
  int max_number;
  ArrayList<Type> type;
  ArrayList<Particle> particles;
  float dt;
  int current_frame;
  int next_event_frame;
  
  
  Emitter(PVector p, PVector min_v, PVector max_v, int rate, int frame_rate, int max_p, ArrayList<Type> t, Space s) {
    postition = p.copy();
    min_velocity = min_v.copy();
    max_velocity = max_v.copy();
    dt=(1.0/rate) * frame_rate;
    count = 0;
    max_number = max_p;
    type = t;
    particles = new ArrayList<Particle>();
    radials = new ArrayList<Radial>();
    current_frame = 0;
    next_event_frame = this.get_next_event();
    space = s;
  }
  void next_frame(){
    current_frame++;
  }
  void new_particles(){
    println(next_event_frame - current_frame);
    if (next_event_frame - current_frame == 0 && max_number-count>0){
      count++;
      Type particle_type = particle_types.get((int)(Math.random() * particle_types.size()));
      PVector velocity = this.get_random(min_velocity, max_velocity);
      Particle p = new Particle(postition, velocity, particle_type, space);
      particles.add(p);
      int next_event = this.get_next_event();
      while (next_event==0 && max_number-count>0){
        
       count++;
       particle_type = particle_types.get((int)(Math.random() * particle_types.size()));
       velocity = this.get_random(min_velocity, max_velocity);
       p = new Particle(postition, velocity, particle_type, space);
       particles.add(p);
       next_event = this.get_next_event();
      }
    next_event_frame = current_frame+next_event;
    }
    
    
  }
  
  void run(){
    new_particles();
    for (int i = 0; i<particles.size(); i++){
      particles.get(i).run();
    }
    current_frame++;
  }
  PVector get_random(PVector min, PVector max){
    float x = (float)((Math.random() * (max.x - min.x)) + min.x);
    float y = (float)((Math.random() * (max.y - min.y)) + min.y);
    float z = (float)((Math.random() * (max.z - min.z)) + min.z);
    PVector v = new PVector(x,y,z);
    return v;
  }
  int get_next_event() {
    Random r = new Random();
    double L = Math.exp(-this.dt);
    int k = 0;
    double p = 1.0;
    do {
        p = p * r.nextDouble();
        k++;
    } while (p > L);
    return k - 1;
  }
}
