import java.util.Random;
import java.util.Arrays;
class Vehicle {


  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    // Constructor initialize all values
  Vehicle(float x, float y) {
    position = new PVector(x, y);
    r = 12;
    maxspeed = 2;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void applyBehaviors(ArrayList<Vehicle> vehicles, ArrayList<Car> cars, int[] buffer) {
     PVector separateForce = separate(vehicles);
     PVector seekForce = seek(cars, vehicles, buffer);
     separateForce.mult(2);
     seekForce.mult(1);
     applyForce(separateForce);
     applyForce(seekForce); 
  }
  
    // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(ArrayList<Car> cars, ArrayList<Vehicle> vehicles, int[] buffer) {
    int maxcap = vehicles.size()/cars.size();
    if(maxcap == 0)
      maxcap = 1;
    PVector target = new PVector();
    float dist = 99999999;
    int index = cars.size();
    int carInd = 0;
    for(Car c : cars){
      try{
        if(PVector.dist(position, c.position) < dist && buffer[carInd] < maxcap){
          dist = PVector.dist(position, c.position);
          index = carInd;
        }
        carInd++;
      }catch(Exception e){
        System.out.println(e);
      }
    }
    if(index != cars.size()){
      target = cars.get(index).position;
      buffer[index]++;
    }
    else{
      Random ran = new Random();
      int x = ran.nextInt(cars.size());
      target = cars.get(x).position;
      Arrays.fill(buffer, new Integer(0));
    }
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    return steer;
  }

  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separate (ArrayList<Vehicle> vehicles) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Vehicle other : vehicles) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }

}