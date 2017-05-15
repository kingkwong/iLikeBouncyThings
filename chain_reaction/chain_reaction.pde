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
    int ran = (int)random(20);
    balls.get( ran ).startExpand = true;
  }
}

void draw() {
  background(51);
  
  // look for nearest ball
  
  /*
  for (Ball b : balls) {
    if (startChainReaction) {
      PVector one = b.position;
      PVector two = new PVector( globalx, globaly );
      if (one.sub(two).mag() < 100) {
         b.startExpand = true;       
         globaly = globalx = 10000000;   
      }   
    }
  }
  */
  for (Ball b : balls) {
    if (b.startExpand) {
      b.checkCollision(balls);
      b.expand();
      b.shrink();
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

  void expand() {
     // if ball is starting to expand, stop its movement
     if (startExpand) {
        velocity = new PVector(0,0); 
     }
     // expand to 100 more than original size
     if (size < init_size+100 && !doneExpanding && startExpand) {
        size++;
     }
     // indicate shrink method is ready to start
     else {
       doneExpanding = true;
       // red = green = blue = 100; // DEBUG
     }
  }
  
  void shrink() {
     if (startExpand && doneExpanding && size > 0) {
        size -= 2;
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

    // Create list of distances between balls and the minimum distance they'd have to be before being considering "colliding"
    ArrayList<Float> distanceVectMags = new ArrayList<Float>();
    ArrayList<Float> minDistances = new ArrayList<Float>();
    
    for (Ball b : others ) {
      // Calculate magnitude of the vector separating the balls
      distanceVectMags.add( PVector.sub(b.position, position).mag() );
      // Minimum distance before they are touching
      minDistances.add( size/2 + b.size/2 );
    }

    for (int i = 0; i < distanceVectMags.size(); i++) {
      float distanceVectMag = distanceVectMags.get(i);
      float minDistance = minDistances.get(i);
      // if ball is part of chain reaction
      // and within colliding distance with another ball
      // start the expanding process
      if (distanceVectMag < minDistance && distanceVectMag != 0 && startExpand) {
         Ball b = others.get(i);
         b.startExpand = true;
      }
      
    }
    
  }
  
}