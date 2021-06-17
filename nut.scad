/*******************************************************************************
 * The M-series of hex nut dimensions can be found here:
 * https://www.engineersedge.com/hardware/standard_metric_hex_nuts_13728.htm
 *
 * Here we will assume an M5 hex nut.
 ******************************************************************************/

m3=0;
m5=1;
nutDiameterIndex=0;
nutFlatDistanceIndex=1;
nutThicknessIndex=2;
// Add more as we go.
nuts = [
  [6.35, 5.5, 2.4], // m3
  [9.24, 8, 4.7], // m5
];

// TODO: Use or consolidate with countersink.scad somehow.
/**
 * See https://www.insight-security.com/get-to-know-metric-bolt-sizes
 * for sizes.
 */
screwShaftDiameterIndex=0;
screwShaftClearanceDiameterIndex=1;
screwHeadDiameterIndex=2;
screwHeadThicknessIndex=3;
screws = [
  [3, 3.3, 5, 5],
  [5, 5.5, 7, 5],
];

hexNutGapHead=16;
// Use this if using the "tall" rotation of the hex nut.
/* hexNutDiameter=9.24; */
// Use this if using the "short" rotation of the hex nut.
/* hexNutFlatDistance=8; */
// The unit 8.0 is given as the maximum size of the nut that are two sides wide.
// This doesn't give us a side, and since it's at an angle we can't simply
// divide by two. However we can treat half of that width as a triangle, and we
// know its angles due to the hexagon shape.
hexNutSideLength = cos(polygonAngle(6) - 90) * (8 / 2);

function polygonAngle(sides) = ((sides - 2) * 180) / sides;

/**
 * This gives us the hex nut sans the bore.
 */
module hexNutBoreless(mSize) {
  let (
    hexNutDiameter = nuts[mSize][nutDiameterIndex],
    hexNutThickness = nuts[mSize][nutThicknessIndex]
  ) {
    rotate(a=90, v=[1, 0, 0])
      rotate(a=90, v=[0, 0, 1])
      // Do we want it at its widest angle going up and down? Probably not. But
      // keep this in case we change our minds.
      /* rotate(a=90, v=[0, 0, 1]) */
      translate([0, 0, -hexNutThickness / 2])
      linear_extrude(hexNutThickness)
      circle(d=hexNutDiameter, $fn=6);
  }
}

/**
 * The hex nut gap is for placing both a hex nut and a screw inside of the
 * object in question.
 */
module hexNutGap(mSize, countersinkDepth, nutDepth) {
  let (
    tolerance = 1.2
  ) {
    scale(tolerance) {
      union() {
        hexNutBoreless(mSize);
      }
      let (
        nutThickness = nuts[mSize][nutThicknessIndex]
      ) {
        translate([0, -(nutThickness + nutDepth), 0])
          screwShaft(mSize, countersinkDepth + nutThickness);
      }
      hexNutContinuation(mSize, nutDepth);
    }
  }
}

module hexNutContinuation(mSize, depth) {
  let (
    hexNutFlatDistance = nuts[mSize][nutFlatDistanceIndex],
    hexNutThickness = nuts[mSize][nutThicknessIndex]
  ) {
    translate([0, 0, depth / 2])
      cube([hexNutFlatDistance, hexNutThickness, depth], center=true);
  }
}

/**
 * The shaft of the screw.
 */
module screwShaft(mSize, length, nutThickness) {
  let (
    screwBodyDiameter = screws[mSize][screwShaftClearanceDiameterIndex]
  ) {
    $fn=100;
    rotate(a=90, v=[1, 0, 0])
      translate([0, 0, -length / 2])
      cylinder(
        d=screwBodyDiameter,
        h=length,
        center=true
      );
  }
}

previewNutGap = false;
if(previewNutGap) {
  translate([20, 20, -20])
    hexNutGap(m5, 20, 10);
}
