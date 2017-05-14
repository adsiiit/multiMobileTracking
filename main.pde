ArrayList<Vehicle> vehicles;
int[] buffer  = new int[]{0, 0, 0, 0} ;  // its size equals the number of cars or targets to be tracked 
ArrayList<Car> cars;
void setup(){
  size(1200, 700);
  vehicles = new ArrayList<Vehicle>();
  cars = new ArrayList<Car>();
  for (int i = 0; i < 5; i++) {
    vehicles.add(new Vehicle(random(width),random(height)));
  }
  
  cars.add(new Car(width/2+100, height/2, 1, 2));
  cars.add(new Car(width/2-100, height/2, 1, -2));
  cars.add(new Car(width/2, height/2+100, -2, -1));
  cars.add(new Car(width/2, height/2-100, -1, 2));
}
void draw(){
  background(255);
  for (Vehicle v : vehicles) {
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles, cars, buffer);
    // Call the generic run method (update, borders, display, etc.)
    v.update();
    v.display();
  }
  
  for(Car c : cars){
    c.run(cars);
  }
}

void mouseDragged() {
  vehicles.add(new Vehicle(mouseX,mouseY));
}