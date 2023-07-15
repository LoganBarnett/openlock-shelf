#!/usr/bin/env bash
set -euo pipefail

function scad2stl {
  openscad -o $2 -Dtiles=$1 openlock-shelf.scad
}

mkdir -p dist
scad2stl 2.5 dist/openlock-shelf-2.5-tiles.stl
scad2stl 3.0 dist/openlock-shelf-3-tiles.stl
scad2stl 3.5 dist/openlock-shelf-3.5-tiles.stl
