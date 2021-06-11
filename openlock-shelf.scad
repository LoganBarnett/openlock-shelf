include <perpendicular-support.scad>
include <screw.scad>
include <shelf-clamp.scad>
include <wall-frame.scad>

wallBraceWideWidth = 40;
wallBraceNarrowWidth = 10;
wallBraceHeight = 50;
wallBraceThickness = 5;
// This is how far out from the wall we go. OpenLock tiles are about 1 inch
// across, or perhaps more accurately 25mm (instead of 25.4mm? I haven't
// verified). To hold a single E piece, plus two A-thickness pieces is 3 tiles
// worth of space, or 75mm.
// tiles = 2.5;
tiles = 3;
// We don't want to make it an exact fit though - we want the clamp to bite down
// on the piece.
wallBraceExtrusion = tiles * 25 - wallBraceNarrowWidth / 2;

module shelfWallMount(preview) {
  union() {
    support();
    crossSupport();
    wallFrame();
    if(preview) {
      shelfClampPreview();
    }
  }
}

module shelfClampPreview() {
  translate([
    0,
    wallBraceHeight + wallBraceNarrowWidth / 2,
    wallBraceExtrusion + wallBraceNarrowWidth / 2,
  ])
    color("blue") {
    shelfClamp(
      wallBraceNarrowWidth,
      wallBraceNarrowWidth,
      wallBraceNarrowWidth,
      wallBraceNarrowWidth / 3,
      wallBraceNarrowWidth / 4
    );
  }
}

module shelfClampPrintable() {
  translate([
    wallBraceNarrowWidth + 3,
    wallBraceNarrowWidth / 2,
    wallBraceNarrowWidth / 2 - (wallBraceNarrowWidth / 4),
  ])
    shelfClamp(
      wallBraceNarrowWidth,
      wallBraceNarrowWidth,
      wallBraceNarrowWidth,
      wallBraceNarrowWidth / 3,
      wallBraceNarrowWidth / 4
    );
}

module crossSupport() {
  translate([
    0,
    (wallBraceHeight - wallBraceNarrowWidth * 1.25) / 2
    + wallBraceNarrowWidth * 1.25,
    (wallBraceExtrusion - wallBraceNarrowWidth) / 2,
  ])
    rotate(a=180, v=[0, 1, 0])
    perpendicularSupport(
      (wallBraceExtrusion - wallBraceNarrowWidth * 1.75) / 2,
      (wallBraceHeight - wallBraceNarrowWidth * 1.5) / 2,
      wallBraceNarrowWidth * 0.25,
      wallBraceNarrowWidth / 2,
      false
    );
}

module support() {
  translate([
    0,
    wallBraceNarrowWidth * 1.25,
    0,
  ])
    perpendicularSupport(
      wallBraceExtrusion - wallBraceNarrowWidth,
      wallBraceHeight - wallBraceNarrowWidth * 1.25,
      wallBraceNarrowWidth / 2,
      wallBraceNarrowWidth * 0.75,
      true
    );
}

preview = false;
shelfWallMount(preview);
if(!preview) {
  shelfClampPrintable();
}
