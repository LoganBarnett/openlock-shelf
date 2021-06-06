include <util.scad>

/**
 * Build a support between two different, perpendicular points. This can
 * transfer load in different directions.
 */

module perpendicularSupport(x, y, width, thickness) {
  let (
    angle = atan(x/y),
    intersectLengthY = pythagorean(thickness, thickness * tan(angle)),
    intersectLengthZ = pythagorean(thickness, thickness * tan(90 - angle)),
    // The length hypotenus of the x and y are not sufficient, since they
    // measure from the center of the beam on one side to the other. The
    // outer side of the beam will have the longest dimension, and we need
    // to treat the full length as the true length.
    //
    // We can model a triangle with the beam pivoting off of the surface it is
    // attached to. A gap is created when the angle exceeds 45 degrees. So we
    // compute a tangent based on our current angle (and the other side) to
    // determine an offset. I thought this would be needed twice (for both the
    // angle and the 90 - angle), but that doesn't seem to be the case.
    //
    // It is not lost on me that the angle we are taking the tangent of is the
    // arc tangent of x/y so wouldn't that mean we could do x / y and skip the
    // tangent function? I don't know. Perhaps it has the benefit of creating a
    // normalzed scalar.
    length = pythagorean(x, y)
      + tan(angle) * thickness / 2
  ) {
    translate([
      0,
      // Do not translate... yet! The consumer should be responsible for the
      // offset.
      0,
      0,
    ])
      rotate(a=angle, v=[1, 0, 0])
      translate([
        0,
        length / 2,
        0,
      ])
      {
        union() {
          cube(
            size=[
              width,
              length,
              thickness,
            ],
            center=true
          );
        }
      }
    supportIntersectionRemoval("y", angle, thickness, width, intersectLengthZ);
      translate([0, y, x])
        rotate(a=90, v=[1,0,0])
        supportIntersectionRemoval(
          "x",
          90 - angle,
          thickness,
          width,
          intersectLengthY
        );
  }
}

module supportIntersectionRemoval(
  axis,
  angle,
  thickness,
  width,
  intersectLength
) {
  let (
    // We computed this once, but compute it again because the angle differs.
    /* intersectLength = pythagorean(thickness, thickness * tan(angle)), */
    // Invoke "Law of Sines". The hypotenuse of our previously calculated length
    // gives us the height of an imaginary triagle formed by the intersection
    // and the thickness. I don't think the thickness is exactly correct in this
    // case but it appears to completely cover the intersection area - just not
    // the rectangular area beyond it. So later we double the amounts so we can
    // move on. This is all to build up a subtractive area.
    depth = thickness * cos(angle),
    // Hold onto your butts. I found the way to this via the law of cosines, but
    // I don't actually know if I'm putting it to use. It's basically
    // pythagorean's combined with trig.
    // a^2 + b^2 = c^2
    // b^2 = c^2 - b^2
    // b^2 = intersectLength ^ 2 - depth^2
    // Probabl divided by two because we're moving from the center?
    adjacentSmallLength = sin(90 - angle) * intersectLength,
    intersectionAlignOffset = pow(
      pow(adjacentSmallLength, 2) - pow(depth, 2),
      1/2
    ) / 2
  ) {
    echo(str(
      "angle: ", angle,
      " sin: ", sin(angle),
      " cos: ", cos(angle),
      " tan: ", tan(angle),
      " thickness: ",
      thickness,
      " width: ",
      width,
      " intersectLength: ",
      intersectLength,
      " depth: ",
      depth,
      " intersectionAlignOffset: ",
      intersectionAlignOffset
    ));
    translate([
      0,
      // I don't understand why one needs the offset and the other does not.
      axis == "y" ? intersectionAlignOffset : 0,
      axis == "x" ? depth / -2 : 0,
    ])
      color("green") {
      #cube(
        size = [
          width,
          intersectLength,
          depth,
        ],
        center=true
      );
      sphere(3);
    }
  }
}
