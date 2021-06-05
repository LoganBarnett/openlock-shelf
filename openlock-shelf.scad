screwHoleHeadDiameter = 4;
screwHoleHeadThickness = 3;
screwHoleShaftDiameter = 2;
countersinkWallLength = 10;

wallBraceWideWidth = 40;
wallBraceNarrowWidth = 10;
wallBraceHeight = 50;
wallBraceThickness = 5;
wallBraceExtrusion = 30;

module shelfWallBraceFrame() {
  union() {
    cube([wallBraceNarrowWidth, wallBraceThickness, wallBraceHeight]);
    translate([
      (wallBraceWideWidth - wallBraceNarrowWidth) / -2,
      0,
      wallBraceHeight - wallBraceNarrowWidth,
    ])
      cube([wallBraceWideWidth, wallBraceThickness, wallBraceNarrowWidth]);
    translate([
      0,
      -wallBraceExtrusion,
      wallBraceHeight - wallBraceNarrowWidth,
    ])
      cube([wallBraceNarrowWidth, wallBraceExtrusion, 10]);
  }
}

module shelfClamp() {
  union() {
    difference() {
      cube([wallBraceNarrowWidth, wallBraceNarrowWidth, wallBraceNarrowWidth]);
      translate([
        wallBraceNarrowWidth / 2,
        0,
        wallBraceNarrowWidth / 2,
      ])
        rotate(a=90, v=[-1, 0, 0])
        countersink(wallBraceNarrowWidth);
    }
  }
}

module countersink(length) {
  $fn=100;
  union() {
    cylinder(
      d1=screwHoleHeadDiameter,
      d2=screwHoleHeadDiameter,
      h=screwHoleHeadThickness,
      center = true
    );
    translate([0, 0, -screwHoleHeadThickness])
      cylinder(
        d=screwHoleShaftDiameter,
        h=length,
        center = false
      );
  }
}


/**
 * The brace is a kind of support that extends from the wall mount to the
 * extursion that helps hold the load of the extursion. Downwards load should
 * transfer the force into the wall mount and therefore the wall itself.
 *
 *
 */
module shelfWallBrace(x, y, width, thickness) {
  let (
    length = pow(pow(x, 2) + pow(y, 2), 1/2),
    angle = atan(y/x)
  )
    translate([
      0,
      thickness * -0.60,
      0,
    ])
    rotate(a=angle, v=[-1, 0, 0])
    translate([
      0,
      -(length + thickness),
      0
    ])
    {
      union() {
        cube([
          width,
          length,
          thickness,
        ]);
      }
      color("red") { sphere(5); }
    }
  rotate(a=angle, v=[-1, 0, 0])
    color("green") {
    cube([
      10,
      10,
      10,
    ]);
  }
  translate([
  ])
    rotate(a=angle, v=[-1, 0, 0])
    color("green") {
    cube([
      10,
      10,
      10,
    ]);
  }
}

module shelfWallMount() {
  difference() {
    union() {
      translate([
        wallBraceNarrowWidth / 4,
        wallBraceNarrowWidth,
        0,
      ])
        shelfWallBrace(
          wallBraceExtrusion,
          wallBraceHeight - wallBraceNarrowWidth,
          wallBraceNarrowWidth / 2,
          wallBraceNarrowWidth * 0.75
        );
      color("teal") {
        shelfWallBraceFrame();
      }
      translate([
        0,
        -wallBraceExtrusion - wallBraceNarrowWidth,
        wallBraceHeight - wallBraceNarrowWidth,
      ])
        color("blue") {
        shelfClamp();
      }
    }
    translate([
      countersinkWallLength / 2,
      (screwHoleHeadThickness / 2) - 0.1,
      5
    ])
      rotate(a=90, v=[-1, 0, 0])
      countersink(countersinkWallLength);
    translate([
      wallBraceWideWidth / 2,
      (screwHoleHeadThickness / 2) - 0.1,
      wallBraceHeight - wallBraceNarrowWidth / 2
    ])
      rotate(a=90, v=[-1, 0, 0])
      countersink(countersinkWallLength);
    translate([
      -wallBraceWideWidth / 2 + wallBraceNarrowWidth,
      (screwHoleHeadThickness / 2) - 0.1,
      wallBraceHeight - wallBraceNarrowWidth / 2
    ])
      rotate(a=90, v=[-1, 0, 0])
      countersink(countersinkWallLength);
  }
}

shelfWallMount();
