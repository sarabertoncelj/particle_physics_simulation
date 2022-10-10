import java.util.*;
import java.util.regex.*;
float x, y, z;
float space_x, space_y, space_z;
ArrayList<Float> radius = new ArrayList<>();
ArrayList<Float> mass = new ArrayList<>();
ArrayList<Type> particle_types = new ArrayList<>();
ArrayList<Emitter> emitters = new ArrayList<>();
ArrayList<Radial> radials = new ArrayList<>();
Space space;
PVector space_min;
PVector space_max;
PVector gravity;
PVector wind;
float scale;
int frame_rate;
Emitter e;
Particle p;

void setup() {
  size(1000, 1000, P3D);

  x = width/2;
  y = height/2;
  z = 0;
  frame_rate = 30;
  frameRate(frame_rate);
  String lines[] = loadStrings("../input/simple_01.txt");
  gravity = new PVector (0.0, 0.0, 0.0);
  wind = new PVector (0.0, 0.0, 0.0);
  for (int i = 0; i<lines.length; i++) {
    if (lines[i].startsWith("space")) {
      float values[] = float(lines[i].split(" "));

      scale = height/(values[5]- values[2]);
      space_min = new PVector (values[1], values[2], values[3]);
      space_max = new PVector (values[4], values[5], values[6]);
      space_min.mult(scale);
      space_max.mult(scale);
      space_x = space_max.x-space_min.x;
      space_y = space_max.y-space_min.y;
      space_z = space_max.z-space_min.z;
      space = new Space(space_min, space_max, scale);
      print(space_min);
    } else if (lines[i].startsWith("gravity")) {
      float values[] = float(lines[i].split(" "));
      if (values.length >1) {
        gravity.y = -values[1];
      }
      else{
        gravity.y = 9.81;
      }
      space.set_gravity(gravity);
    } else if (lines[i].startsWith("wind")) {
      float values[] = float(lines[i].split(" "));
      if (values.length >1) {
        wind.x = values[1];
        wind.y = -values[2];
        wind.z = values[3];
        print(wind);
      }
      space.set_wind(wind);
    } else if (lines[i].startsWith("radial")) {
      float values[] = float(lines[i].split(" "));
      PVector radial_pos = new PVector(values[1],-values[2],values[3]);
      float strength = values[4];
      Radial r = new Radial(radial_pos, strength);
      space.add_radial(r);
    } else if (lines[i].startsWith("type")) {
      Pattern p = Pattern.compile("\\((.*?)\\)");
      Matcher m = p.matcher(lines[i]);      
      m.find();
      float temp[] = float(m.group(1).split(" "));  // The matched substring
      float min_m, max_m;
      if (temp.length == 1){
        min_m = temp[0];
        max_m = temp[0];
      } else  {
        min_m = temp[0];
        max_m = temp[1];
      }
      m.find();
      temp = float(m.group(1).split(" "));  // The matched substring
      float min_r, max_r;
      if (temp.length == 1){
        min_r = temp[0];
        max_r = temp[0];
      } else  {
        min_r = temp[0];
        max_r = temp[1];
      }
      Type t = new Type(min_m, max_m, min_r*scale, max_r*scale);
      particle_types.add(t);
    } else if (lines[i].startsWith("emitter point")) {
      Pattern p = Pattern.compile("\\((.*?)\\)");
      Matcher m = p.matcher(lines[i]);
      println(lines[i]);
      
      
      m.find();
      PVector emitter_position;
      float temp[] = float(m.group(1).split(" "));  // The matched substring
      emitter_position = new PVector(temp[0]*scale,-temp[1]*scale,temp[2]*scale);
      
      m.find();
      PVector min_vel;
      PVector max_vel;
      temp = float(m.group(1).split(" "));  // The matched substring
      if (temp.length == 3){
        min_vel = new PVector(temp[0]*scale,-temp[1]*scale,temp[2]*scale);
        max_vel = new PVector(temp[0]*scale,-temp[1]*scale,temp[2]*scale);
      }
      else{
        min_vel = new PVector(temp[0]*scale,-temp[1]*scale,temp[2]*scale);
        max_vel = new PVector(temp[3]*scale,-temp[4]*scale,temp[5]*scale);
      }
      
      m.find();
      int rate = int(m.group(1));
      
      m.find();
      println(m.group(1));
      int type_index[] = int(m.group(1).split(" "));
      ArrayList<Type> particle_types_subset = new ArrayList<>();
      for (int j=0; j<type_index.length; j++){
        particle_types_subset.add(particle_types.get(type_index[j]));
      }
      m.find();
      int max_number = int(m.group(1));
      println(m.group(1));
      e = new Emitter(emitter_position, min_vel, max_vel, rate, frame_rate, max_number, particle_types_subset, space);
      emitters.add(e);
    }
  }
}

void draw() {
  camera(0, 0, height*1.5, 0, 0, 0, 0, 1, 0);
  background(255);
  push();
  for (int i = 0; i < emitters.size(); i++){
    emitters.get(i).run();
  }
  lights();
  stroke(0);
  noFill();
  translate(0, 0, 0);
  box(space_x, space_y, space_z);
  pop();
}
