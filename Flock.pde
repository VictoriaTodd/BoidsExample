class Flock {
  // Boids algorithm referenced from:
  // https://medium.com/fragmentblog/simulating-flocking-with-the-boids-algorithm-92aef51b9e00
  ArrayList<Boid> boids = new ArrayList<Boid>();

  Flock(int num_boids) {
    for (int i = 0; i < num_boids; i++) {
      boids.add(new Boid(random(0, 1280), random(0, 720)));
    }
  }

  void update(boolean angle_avoidance_mode) {
    for (int i = 0; i < boids.size(); i++) {
      PVector vector1 = attract(boids.get(i));
      PVector vector2 = angle_avoidance_mode ? steer_to_avoid(boids.get(i)): repel(boids.get(i));
      PVector vector3 = matchSpeed(boids.get(i));
      PVector finalChange = vector1.add(vector2).add(vector3);
      boids.get(i).velocity.add(finalChange);
      boids.get(i).position.add(boids.get(i).velocity);
      boids.get(i).limitSpeed();
      boids.get(i).stayInFrame();
      boids.get(i).render(angle_avoidance_mode);
    }
  }

  // this rule moves each boid toward the perceived centre of mass of the flock
  // i.e., the average position of every boid but this one
  PVector attract(Boid b) {
    PVector perceived_centre_of_mass = new PVector(0, 0);
    for (int i = 0; i < boids.size(); i++) {
      if (boids.get(i) != b) {
        perceived_centre_of_mass = perceived_centre_of_mass.add(boids.get(i).position);
      }
    }
    perceived_centre_of_mass = perceived_centre_of_mass.div((boids.size() - 1));
    PVector result = (perceived_centre_of_mass.sub(b.position)).div(100); // move 1% towards the perceived center
    return result;
  }

  // this rule makes boids repel each other if they become too close
  PVector repel(Boid b) {
    float distance = 20;
    PVector result = new PVector(0, 0);
    for (int i = 0; i < boids.size(); i++) {
      if (boids.get(i) != b) {
        if (b.position.dist(boids.get(i).position) < distance) {
          result = result.sub(PVector.sub(boids.get(i).position, b.position));
        }
      }
    }
    return result;
  }

  // adjust directon of boid to avoid nearby boids
  // Referenced from: https://slsdo.github.io/steering-behaviors/
  PVector steer_to_avoid(Boid b) {
    float distance = 40;
    PVector result = new PVector(0, 0);
    for (int i = 0; i < boids.size(); i++) {
      if (boids.get(i) != b) {
        if (b.position.dist(boids.get(i).position) < distance) {
          PVector e = PVector.sub(boids.get(i).position, b.position);
          distance = e.mag();
          if (distance > 0) {
            e.normalize();
            result = PVector.sub(e, b.velocity).mult(-1);
          }
        }
      }
    }
    return result;
  }

  // this rule makes a boid modulate it's speed to match the average velocity of other boids in the flock
  PVector matchSpeed(Boid b) {
    PVector pV = new PVector(0, 0);
    for (int i = 0; i < boids.size(); i++) {
      if (boids.get(i) != b) {
        pV.add(boids.get(i).velocity);
      }
    }
    pV = pV.div(boids.size() - 1);
    PVector result = (pV.sub(b.velocity)).div(10);
    return result;
  }
}
