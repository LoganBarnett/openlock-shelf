include <nut.scad>
include <screw.scad>

countersinkWallLength = 10;

module wallFrame() {
  color("teal") {
    difference() {
      union() {
        translate([0, (wallBraceHeight + wallBraceNarrowWidth) / 2, 0])
          cube(
            size=[
              wallBraceNarrowWidth,
              wallBraceHeight + wallBraceNarrowWidth,
              wallBraceThickness,
            ],
            center=true
          );
        overhangBeam();
      }
      wallFrameScrews();
    }
  }
}

module overhangBeam() {
  difference() {
    translate([
      0,
      wallBraceHeight + wallBraceNarrowWidth / 2,
      wallBraceExtrusion / 2,
    ])
      cube(
        size = [wallBraceNarrowWidth, 10, wallBraceExtrusion],
        center = true
      );
    let (
      nutZ = (wallBraceNarrowWidth / 2) + 0.1
    ) {
      translate([
        0,
        wallBraceNarrowWidth / 2 + wallBraceHeight,
        wallBraceExtrusion - nutZ / 2,
      ])
        rotate(a=90, v=[-1,0,0])
        hexNutGap(m3, 20, nutZ);
    }
  }
}

module wallFrameScrews() {
  translate([
    0,
    wallBraceNarrowWidth / 2,
    screws[m5][screwHeadThicknessIndex] - 0.1,
  ])
    rotate(a=90, v=[1, 0, 0])
    countersink(m5, countersinkWallLength);
  translate([
    0,
    wallBraceHeight - wallBraceNarrowWidth,
    screws[m5][screwHeadThicknessIndex] - 0.1,
  ])
    rotate(a=90, v=[1, 0, 0])
    countersink(m5, countersinkWallLength);
}
