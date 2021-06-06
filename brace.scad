include <util.scad>

/**
 * The brace is a kind of support that extends from the wall mount to the
 * extursion that helps hold the load of the extursion. Downwards load should
 * transfer the force into the wall mount and therefore the wall itself.
 */
module shelfWallBrace(x, y, width, thickness) {
  let (
    angle = atan(y/x),
    intersectLengthY = pythagorean(thickness, thickness * tan(angle)),
    intersectLengthX = pythagorean(thickness, thickness * tan(90 - angle)),
    length = pythagorean(x, y)
  ) {
    translate([
      0,
      /* 0, */
      intersectLengthY / 2,
      intersectLengthX / 2,
      /* -0.5, */
      /* -0.25, */
      /* 0, */
      /* 0, */
    ])
      rotate(a=angle, v=[-1, 0, 0])
      translate([
        width / 2,
        /* 0, */
        pythagorean(x, y) / -2,
        /* -(length + thickness) / 2, */
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
        color("red") { sphere(5); }
      }
    braceIntersectionRemoval(angle, thickness, width, intersectLengthY);
    rotate(a=-90, v=[1,0,0])
      translate([0, -y, -(1 * sin(angle) * length)])
      braceIntersectionRemoval(90 - angle, thickness, width, intersectLengthX);
  }
}

module braceIntersectionRemoval(angle, thickness, width, intersectLength) {
  let (
    // We computed this once, but compute it again because the angle differs.
    /* intersectLength = pythagorean(thickness, thickness * tan(angle)), */
    // Invoke "Law of Sines". The hypotenuse of our previously calculated length
    // gives us the height of an imaginary triagle formed by the intersection
    // and the thickness. I don't think the thickness is exactly correct in this
    // case but it appears to completely cover the intersection area - just not
    // the rectangular area beyond it. So later we double the amounts so we can
    // move on. This is all to build up a subtractive area.
    intersectDepth = sin(angle) * intersectLength,
    depth = intersectLength + thickness * tan(angle)
  ) {
    echo(str(
      "angle: ",
      angle,
      " thickness: ",
      thickness,
      " width: ",
      width,
      " intersectLength: ",
      intersectLength,
      " intersectDepth: ",
      intersectDepth,
      " depth: ",
      depth
    ));
    sphere(3);
    translate([
      width / 2,
      intersectDepth / 2,
      /* intersectLength * 0.66, */
      // I do not understand why +1 works so well here, but it does for the
      // bottom. The top is very close.
      /* thickness + 1, */
      /* thickness + sin(angle) * intersect, */
      /* pythagorean(thickness, sin(angle) * interect) */
      /* (thickness / 2), */
      intersectLength,
    ])
      color("green") {
      sphere(3);
      cube(
        size = [
          width,
          // We still wind up with corners poking out, so just double it to move
          // on.
          /* depth * 2, */
          intersectDepth,
          intersectLength,
        ],
        center=true
      );
      /* sphere(3); */
    }
  }
}
