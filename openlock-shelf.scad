include <brace.scad>
screwHoleHeadDiameter = 4;
screwHoleHeadThickness = 3;
screwHoleShaftDiameter = 2;
countersinkWallLength = 10;

wallBraceWideWidth = 40;
wallBraceNarrowWidth = 10;
wallBraceHeight = 50;
wallBraceThickness = 5;
wallBraceExtrusion = 50;

module shelfWallBraceFrame() {
  union() {
    translate([0, wallBraceHeight / 2, 0])
      cube(
        size=[wallBraceNarrowWidth, wallBraceHeight, wallBraceThickness],
        center=true
      );
    translate([
      0,
      wallBraceHeight + wallBraceNarrowWidth / 2,
      0,
    ])
      cube(
        size=[wallBraceWideWidth, wallBraceNarrowWidth, wallBraceThickness],
        center=true
      );
    translate([
      0,
      wallBraceHeight + wallBraceNarrowWidth / 2,
      wallBraceExtrusion / 2,
    ])
      cube(
        size = [wallBraceNarrowWidth, 10, wallBraceExtrusion],
        center = true
      );
  }
}

module shelfClamp() {
  union() {
    difference() {
      cube(
        size = [
          wallBraceNarrowWidth,
          wallBraceNarrowWidth,
          wallBraceNarrowWidth,
        ],
        center = true
      );
      translate([
        /* wallBraceNarrowWidth / 2, */
        0,
        0,
        wallBraceNarrowWidth / 2 + 0.1,
      ])
        rotate(a=90, v=[1, 0, 0])
        countersink(wallBraceNarrowWidth);
    }
  }
}

module countersink(length) {
  $fn=100;
  union() {
    translate([0, -(screwHoleHeadThickness / 2), 0])
      rotate(a=90, v=[1, 0, 0])
    cylinder(
      d1=screwHoleHeadDiameter,
      d2=screwHoleHeadDiameter,
      h=screwHoleHeadThickness,
      center = true
    );
    translate([0, -screwHoleHeadThickness + 0.1, 0])
      rotate(a=90, v=[1, 0, 0])
      cylinder(
        d=screwHoleShaftDiameter,
        h=length,
        center = false
      );
  }
}

module shelfWallMount() {
  difference() {
    union() {
      translate([
        0,
        /* wallBraceNarrowWidth, */
        0,
        0,
      ])
        shelfWallBrace(
          wallBraceExtrusion,
          wallBraceHeight,
          wallBraceNarrowWidth / 2,
          wallBraceNarrowWidth * 0.75
        );
      color("teal") {
        #shelfWallBraceFrame();
      }
      translate([
        0,
        wallBraceHeight + wallBraceNarrowWidth / 2,
        wallBraceExtrusion + wallBraceNarrowWidth / 2,
      ])
        color("blue") {
        #shelfClamp();
      }
    }
    translate([
      0,
      wallBraceNarrowWidth / 2,
      screwHoleHeadThickness - 0.1,
    ])
      rotate(a=90, v=[1, 0, 0])
      countersink(countersinkWallLength);
    translate([
      wallBraceWideWidth / 2 - wallBraceNarrowWidth / 2,
      wallBraceHeight + wallBraceNarrowWidth / 2,
      screwHoleHeadThickness - 0.1,
    ])
      rotate(a=90, v=[1, 0, 0])
      countersink(countersinkWallLength);
    translate([
      -wallBraceWideWidth / 2 + wallBraceNarrowWidth / 2,
      wallBraceHeight + wallBraceNarrowWidth / 2,
      screwHoleHeadThickness - 0.1,
    ])
      rotate(a=90, v=[1, 0, 0])
      countersink(countersinkWallLength);
  }
}

shelfWallMount();
