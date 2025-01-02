
class Particle {
  PVector loc, vel, acc;
  float lifespan;
  PImage img;
  color col;

  Particle(PVector l, PImage img_, color col_) {
    acc = new PVector(0, 0);
    vel = new PVector(randomGaussian() * 0.3, randomGaussian() * 0.3 - 1.0);
    loc = l.copy();
    lifespan = 100.0;
    img = img_;
    col = col_;
  }

  void run() {
    update();
    render();
  }

  void applyForce(PVector f) {
    acc.add(f);
  }

  void update() {
    vel.add(acc);
    loc.add(vel);
    lifespan -= 2.5;
    acc.mult(0);

    if (loc.x > 10 && loc.x < 230 && loc.y > 10 && loc.y < height - 10) {
      lifespan = 0; // Remove the particle if it enters the menu area
    }
  }

  void render() {
    imageMode(CENTER);
    tint(col, lifespan);
    image(img, loc.x, loc.y);
  }

  boolean isDead() {
    return lifespan <= 0.0;
  }
}


class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PImage img;
  color smokeColor;

  ParticleSystem(int num, PVector v, PImage img_) {
    particles = new ArrayList<Particle>();
    origin = v.copy();
    img = img_;
    smokeColor = color(200, 200, 200);
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin, img, smokeColor));
    }
  }

  void addParticle() {
    particles.add(new Particle(origin, img, smokeColor));
  }

  void applyForce(PVector force) {
    for (Particle p : particles) {
      p.applyForce(force);
    }
  }

  void updateColor(color newColor) {
    smokeColor = newColor;
    for (Particle p : particles) {
      p.col = newColor;
    }
  }

  void run() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run(); //
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
