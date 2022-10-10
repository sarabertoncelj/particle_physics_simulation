class Type {
  float min_mass;
  float min_radius;
  float max_mass;
  float max_radius;
  
  Type(float min_m, float max_m, float min_r, float max_r) {
    this.min_mass=min_m;
    this.max_mass=max_m;
    this.min_radius=min_r;
    this.max_radius=max_r;
  }

  float m() {
    return this.get_random(min_mass, max_mass);
  }
  float r() {
    return this.get_random(min_radius, max_radius);
  }
  float get_random(float min, float max){
    return (float)((Math.random() * (max - min)) + min);
  }
}
