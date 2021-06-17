include <nut.scad>

module countersink(mSize, length) {
  $fn=100;
  union() {
    translate([0, -(screws[mSize][screwHeadDiameterIndex] / 2), 0])
      rotate(a=90, v=[1, 0, 0])
    cylinder(
      d=screws[mSize][screwHeadDiameterIndex],
      h=screws[mSize][screwHeadThicknessIndex],
      center = true
    );
    translate([0, -screws[mSize][screwHeadThicknessIndex] + 0.1, 0])
      rotate(a=90, v=[1, 0, 0])
      cylinder(
        d=screws[mSize][screwShaftClearanceDiameterIndex],
        h=length,
        center = false
      );
  }
}
