#!/usr/bin/env bash
set -euo pipefail

function scad2stl {
  openscad -o $1 openlock-shelf.scad
}

mkdir -p dist
scad2stl dist/openlock-shelf-2.5-tiles.stl
scad2stl dist/openlock-shelf-3-tiles.stl
scad2stl dist/openlock-shelf-3.5-tiles.stl
