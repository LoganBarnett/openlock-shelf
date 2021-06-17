
module shelfClamp(x, y, z, lipHeight, lipDepth) {
  union() {
    translate([0, y / 2 + lipHeight / 2, z / 2 - lipDepth / 2])
      cube(size=[x, lipHeight, lipDepth], center=true);
    difference() {
      cube(size = [x, y, z,], center = true);
      translate([0, 0, z / 4])
        cube(size = [x * 0.75 , y * 0.75 , z * 0.75], center = true);
      translate([
        0,
        0,
        z / 4,
      ])
        rotate(a=90, v=[1, 0, 0])
        countersink(m3, z);
    }
  }
}
