#!/bin/bash

point-cloud --domain unit-square --points 12 --scale 300 --seed 14483295671521681018 >/tmp/point-cloud.wkt

wkt2svg --padding </tmp/point-cloud.wkt >alg-01-point-cloud.svg

triangulate </tmp/point-cloud.wkt |
    wkt2svg --padding >alg-02-delaunay.svg
urquhart </tmp/point-cloud.wkt |
    wkt2svg --padding >alg-02-urquhart.svg

urquhart </tmp/point-cloud.wkt |
    urquhart --output-format tgf |
    traverse --traversals 3 --length 3 --untraversed --seed 14735632682957504560 |
    wkt2svg --padding >alg-03-strokes.svg

urquhart </tmp/point-cloud.wkt |
    urquhart --output-format tgf |
    traverse --traversals 3 --length 3 --untraversed --seed 14735632682957504560 |
    smooth --iterations 5 |
    wkt2svg --padding >alg-04-smooth.svg

index=0
for seed in 26296 9699 31881 7057 14983; do
    # for index in $(seq 0 5); do
    # seed=$RANDOM
    echo "index: $index seed: $seed"
    point-cloud --domain unit-square --points 10 --scale 300 --seed $seed |
        urquhart --output-format tgf |
        traverse --traversals 4 --random-traversals --length 4 --random-length --remove-after-traverse --seed $seed |
        smooth --iterations 5 |
        wkt2svg --padding --output random-$index.svg
    index=$((index + 1))
done

point-cloud --domain unit-square --points 5 --scale 300 --seed 2357632926438738947 |
    triangulate --output-format tgf |
    traverse --traversals 4 --random-traversals --length 4 --random-length --remove-after-traverse --seed 2032873819640371579 |
    smooth --iterations 5 |
    wkt2svg --padding --output refined-01-delaunay.svg

point-cloud --domain unit-square --points 30 --scale 300 --seed 17596477818917357813 |
    triangulate --output-format tgf |
    traverse --traversals 3 --length 10 --random-length --remove-after-traverse --seed 7926289495945540784 |
    smooth --iterations 5 |
    wkt2svg --padding --output refined-02-size.svg

point-cloud --domain unit-square --points 30 --scale 300 --seed 12969821365729362097 |
    urquhart --output-format tgf |
    traverse --traversals 3 --length 10 --random-length --remove-after-traverse --seed 6248254515047047787 |
    smooth --iterations 5 |
    wkt2svg --padding --output refined-03-urquhart.svg

grid --output-format graph 3 4 |
    traverse --traversals 4 --random-traversals --length 5 --random-length --remove-after-traverse --seed 1407781468622176490 |
    transform --scale 100 100 |
    smooth --iterations 5 |
    wkt2svg --padding --output refined-04-grid.svg

grid --output-format graph 3 4 |
    traverse --traversals 4 --random-traversals --length 5 --random-length --remove-after-traverse --seed 7478172003060373133 |
    transform --scale 100 100 |
    smooth --iterations 1 |
    wkt2svg --padding --output refined-05-45deg.svg

grid --output-format points 3 4 |
    triangulate --output-format tgf |
    traverse --traversals 4 --random-traversals --length 5 --random-length --remove-after-traverse --seed 7741777682894467493 |
    transform --scale 100 100 |
    smooth --iterations 5 |
    wkt2svg --padding --output refined-06-triangulate.svg

grid --output-format points 3 4 |
    triangulate --output-format tgf |
    traverse --traversals 4 --random-traversals --length 5 --random-length --remove-after-traverse --seed 7741777682894467493 |
    transform --scale 100 100 |
    smooth --iterations 1 |
    wkt2svg --padding --output refined-07-low-smooth.svg

grid --output-format points 3 4 |
    triangulate --output-format tgf |
    traverse --traversals 4 --random-traversals --length 5 --random-length --remove-after-traverse --seed 7741777682894467493 |
    transform --scale 100 100 |
    wkt2svg --padding --output refined-08-no-smooth.svg
