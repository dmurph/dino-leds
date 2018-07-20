import java.util.*;

class GrowingSpheres implements LightingDesign {
  final float kSphereChance = 0.01;
  final float kSphereMinSpeed = 10;
  final float kSphereMaxSpeed = 100;

  class Sphere {
    float radius;
    float speed;
    color c;
  }

  color currentColor;

  Vec3 sphereCenter;
  float sphereRadius;
  float maxRadius;
  List<Sphere> spheres = new ArrayList<Sphere>();

  GrowingSpheres() {
  }

  color randomColor() {
    colorMode(HSB, 100);
    color c =color(random(100), random(80, 100), 100);
    return c;
  }

  Sphere createSphere() {
    Sphere s = new Sphere();
    s.radius = 0;
    s.speed = random(kSphereMinSpeed, kSphereMaxSpeed);
    s.c = randomColor();
    return s;
  }

  void init(Model m) {
    colorMode(HSB, 100);
    sphereCenter = new Vec3(m.getMinX() + m.getMaxX(), m.getMinY() + m.getMaxY(), m.getMinZ()+ m.getMaxZ());
    sphereCenter.mulLocal(1f/2);
    maxRadius = max(max(m.getMaxX() - m.getMinX(), m.getMaxY() - m.getMinY()), m.getMaxZ() - m.getMinZ());

    currentColor = randomColor();
    spheres.add(createSphere());
  }

  void update(long millis) {
    float lastRadius = 0;
    for (int i = 0; i < spheres.size(); ++i) {
      Sphere s = spheres.get(i);
      if (lastRadius > s.radius) {
        spheres.remove(i);
        --i;
      }
      if (lastRadius > maxRadius) {
        spheres.remove(i);
        --i;
        currentColor = s.c;
      }
      s.radius += millis * 1f / 1000 * s.speed;
      lastRadius = s.radius;
    }
    
    if (random(1) < kSphereChance) {
      spheres.add(0, createSphere());
    }
  }

  color getColor(int strip, int led, Vec3 pos) {
    float distance = pos.sub(sphereCenter).length();

    for (Sphere s : spheres) {
      if (distance < s.radius)
        return s.c;
    }
    return currentColor;
  }
}