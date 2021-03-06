import java.util.ArrayList;

ArrayList<Ball> balls = new ArrayList<Ball>();
boolean startChainReaction;

void setup() {
  size(1000, 1000);
  startChainReaction = false;
  for (int i = 0; i < 20; i++) {
    balls.add( new Ball() ); 
  }
}

void mouseClicked() {
  //only start chain reaction once
  if (!startChainReaction) {
    startChainReaction = true;
    //get nearest ball
    PVector mouse = new PVector( mouseX, mouseY );
    Ball nearest = balls.get(0);
    float nearestDis = PVector.sub( nearest.position, mouse ).mag();
    for (Ball b : balls) {
      float dis = PVector.sub( b.position, mouse ).mag();
      if (dis < nearestDis) {
        nearest = b;
        nearestDis = dis;
      }
    }
    nearest.startExpand = true;
  }
}

void draw() {
  background(51);
  for (Ball b : balls) {
    if (b.startExpand) {
      b.checkCollision(balls);
      b.reaction();
    }
    b.update();
    b.display();
    b.checkBoundaryCollision();
    // removes dead balls from screen
    if (b.size <= 0) {
       b.position = new PVector( -1, -1 ); 
    }
  }
}

class Ball {
  
  // instance vars
  PVector position, velocity;
  float init_size, size, red, green, blue;
  boolean doneExpanding, startExpand;

  // default constuctor, init vars
  Ball() {
    position = new PVector( random(width-100)+50, random(height-100)+50);
    velocity = PVector.random2D().mult(3);
    init_size = size = random(100)+20;
    red = random(200);
    green = random(200);
    blue = random(200);
    doneExpanding = false;
  }

  void reaction() {
     // stop its movement
     velocity = new PVector(0,0); 
     // expand to 100 more than original size
     if (size < init_size+100 && !doneExpanding) {
        size++;
     }
     // shrink
     else {
       doneExpanding = true;
       if (size > 0)
         size -= 2;
       // red = green = blue = 100; // DEBUG
     }
  }

  // movement
  void update() {
    position.add(velocity);
  }  
  
  void display() {
    noStroke();
    fill(red, green, blue);
    ellipse(position.x, position.y, size, size);
  }
  
  // if ball hits wall of screen, bounce off
  void checkBoundaryCollision() { // right wall
    if (position.x > width-size/2) {
      velocity.x *= -1;
    } else if (position.x < size/2) { // left wall
      velocity.x *= -1;
    } else if (position.y > height-size/2) { // top wall
      velocity.y *= -1;
    } else if (position.y < size/2) { // bottom wall
      velocity.y *= -1;
    }
  }
  
  void checkCollision(ArrayList<Ball> others) {
    //if the distance between balls is less than the sum of radii, then they are colliding
    for (Ball b : others) {
      float dis = PVector.sub(b.position, position).mag();
      float minDis = size / 2 + b.size / 2;
      if (dis < minDis)
        b.startExpand = true;
    }
  }
  
}