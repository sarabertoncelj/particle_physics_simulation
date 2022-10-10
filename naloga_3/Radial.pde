class Radial {
  PVector position;
  float strength;
  
  Radial(PVector p, float s) {
    this.position=p.copy();
    this.strength=s;
  }

  PVector get_position() {
    return this.position;
  }
  float get_strength() {
    return this.strength;
  }
}
