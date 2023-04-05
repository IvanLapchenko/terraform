#!/bin/bash

cd harbor/templates

for dir in */; do
  outdir=${dir%*/}_tf
  mkdir -p "$outdir"
  cd "$dir"
  for f in $(find . -name '*.yaml' -or -name '*.yml'); do 
    echo $f
    out="../$outdir/$(basename "$f" .yaml).tf"
    echo $out
    k2tf -f "$f" -o "$out"
  done
  cd ..
done