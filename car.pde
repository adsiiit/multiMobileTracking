class Car{
  PVector position;
  PVector velocity;
  PVector accleration;
  float maxspeed;  
  float r;

  Car(float x, float y, float vx, float vy){
    //accleration = new PVector(0, 0);
    velocity = new PVector(vx, vy);
    position = new PVector(x, y);
    maxspeed = 5;
    r = 7;
  }
  
  void run(ArrayList<Car> cars){
    update(cars);
    display();
  }
  
  boolean collision(ArrayList<Car> cars){
    for(Car c : cars){
      float d = PVector.dist(position, c.position);
      if(d>0 && d<=12){
        return true;
      }
    }
    return false;
  }
  
  void update(ArrayList<Car> cars){
    //velocity.add(accleration);
    //velocity.limit(maxspeed);
    
    position.add(velocity);
    if(position.x > width-10){
      velocity.x = -1 * velocity.x;
    }
    if(position.x < 10){
      velocity.x = -1 * velocity.x;
    }
    if(position.y > height-10){
      velocity.y = -1 * velocity.y;
    }
    if(position.y < 10){
      velocity.y = -1 * velocity.y;
    }
    
    if(collision(cars)){
      System.out.println(" collision " );
      velocity.x = 1 * velocity.x;
      velocity.y = -1 * velocity.y;
    }
  }
  
  void display(){
    float theta = velocity.heading2D() + radians(90);
    fill(127);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }
}