// Meant to replace cube so we can benefit from 2D functions such as offset to
// create fillets.
module cube2(size=[0,0], center=true) {
  square(size=[size.x, size.y], center);
}
