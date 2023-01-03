---
title: Asemic Writing
date: DRAFT
description: Generative script creation

---

# Asemic Writing

I've found Anders Hoff's work on [Inconvergent](https://log.inconvergent.net/list/) hugely
inspiring. In particular his works that are 2D planar geometries (and graphs). This is in part (the
second reason why is because of what I do for work) why
[https://github.com/Notgnoshi/generative](https://github.com/Notgnoshi/generative) exclusively uses
the [Simple Feature Access](https://www.ogc.org/standards/sfa) geometries as geometric primitives.

Two of his posts that have really captured my imagination have been on [Asemic
Writing](https://en.wikipedia.org/wiki/Asemic_writing) (generative handwriting having no semantic
content).

[Spline Script](https://inconvergent.net/2017/spline-script/) gives an algorithm that uses spline
fits inside rotated ellipses to generate cursive handwriting. The use of splines is problematic,
because all of the tooling that I've built for myself over the last few years has exclusively used
[WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) as a serialization
format for geometries, and while extending WKT to support splines is
[possible](https://docs.rs/beziercurve-wkt/latest/beziercurve_wkt/), I haven't found the time nor
motivation to build support for handling both splines and discrete geometries in my tooling (I'd
want each tool to handle both equally well, which is daunting).

However [More Asemic Writing](https://inconvergent.net/2020/asemic-writing/) gives an algorithm for
generating glyphs more like [Hangul](https://en.wikipedia.org/wiki/Hangul) and
[Katakana](https://en.wikipedia.org/wiki/Katakana), which again uses splines, but less "loopy" ones!
So instead of taking on the work of providing true spline support, I instead operate on discrete
geometries, and then smooth them afterward ;)

This has a few downsides, but the upside is that it's _easy_.

## Setup

For the rest of the page, I'll be referring to code from
[https://github.com/Notgnoshi/generative](https://github.com/Notgnoshi/generative). It's a mix of
Python, C++, and Rust.

```sh
# Install the Python dependencies
python3 -m venv --prompt generative .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
# Build the Rust and C++ parts
git submodule update --init --recursive
cargo build --release
# Invoking "cargo run --bin ... -- ..." gets old
export PATH="$PWD/target/release/:$PATH"
```

Each tool that utilizes random number generation can optionally be seeded, and logs the seed used at
INFO level to `stderr` so that the results can be reproduced, even when a seed wasn't given. For
brevity though, I'll leave off the seeds in the shell snippets on this page.

## The algorithm

### 01 - Generate random points

First, generate a uniform random point cloud in a square domain.

```sh
$ point-cloud --domain unit-square --points 4 --scale 100
INFO - Generating 4 points with seed 6547691638051612608
POINT (48.0592033866307 60.000131021120076)
POINT (42.74869165920112 57.607049587621795)
POINT (44.23321026420486 2.7466311018484735)
POINT (60.15061084098781 60.0434120953931)

$ point-cloud --domain unit-square --points 12 --scale 300 |
    wkt2svg
```

![Random point cloud with 12 points](/images/asemic-writing/alg-01-point-cloud.svg "a random point cloud")

### 02 - Calculate the points' relative neighborhood

Second, generate the point cloud's [relative
neighborhood](https://en.wikipedia.org/wiki/Relative_neighborhood_graph) graph. While not quite
equivalent, you can approximate the relative neighborhood by computing the [Urquhart
graph](https://en.wikipedia.org/wiki/Urquhart_graph).

To do this, compute the Delaunay triangulation of the point cloud

```sh
$ point-cloud --domain unit-square --points 12 --scale 300 |
    triangulate |
    wkt2svg
```
![Delaunay triangulation](/images/asemic-writing/alg-02-delaunay.svg "Delaunay triangulation of the point cloud")

And then remove the longest edge from each triangle

```sh
$ point-cloud --domain unit-square --points 12 --scale 300 |
    urquhart |
    wkt2svg
```
![Urquhart graph](/images/asemic-writing/alg-02-urquhart.svg "Urquhart graph of the points")

### 03 - Randomly traverse the graph to create strokes

Third, generate a stroke by randomly traversing the graph. Repeat for some number of times.

```sh
$ point-cloud --domain unit-square --points 12 --scale 300 |
    urquhart --output-format tgf |
    traverse --traversals 3 --length 3 --untraversed |
    wkt2svg
```
![Random strokes](/images/asemic-writing/alg-03-strokes.svg "Random strokes")

Spoiler: you can immediately tell that this will generate quite a bit of nonsense.

### 04 - Fit splines through the strokes

Finally, fit splines through some (or all) of the strokes. Here's where I cheat by using [Chaikin's
smoothing
algorithm](http://www.idav.ucdavis.edu/education/CAGDNotes/Chaikins-Algorithm/Chaikins-Algorithm.html)
instead of using splines.

```sh
$ point-cloud --domain unit-square --points 12 --scale 300 |
    urquhart --output-format tgf |
    traverse --traversals 3 --length 3 --untraversed --remove-after-traverse |
    smooth --iterations 5 |
    wkt2svg
```
![smoothed strokes](/images/asemic-writing/alg-04-smooth.svg "Smoothed strokes")

And then repeat a few thousand times and cherry-pick the good results.

## Some results

I was disappointed in the quality of the results.

![](/images/asemic-writing/random-0.svg "random-00")

![](/images/asemic-writing/random-1.svg "random-01")

![](/images/asemic-writing/random-2.svg "random-02")

![](/images/asemic-writing/random-3.svg "random-03")

![](/images/asemic-writing/random-4.svg "random-04")

## Some better results

So what can we do to make the results better?

### Delaunay instead of Urquhart

We could try using the Delaunay triangulation directly instead of the Urquhart graph.

```sh
$ point-cloud --domain unit-square --points 5 --scale 300 |
    triangulate --output-format tgf |
    traverse --traversals 4 --length 4 --remove-after-traverse --seed 0 |
    smooth --iterations 5 |
    wkt2svg --padding --output refined-01-delaunay.svg
```

![Using the Delaunay triangulation](/images/asemic-writing/refined-01-delaunay.svg "Using the Delaunay triangulation")

That could be promising.

### Moar data

We could increase the side of the point cloud and the length of the strokes.

```sh
$ point-cloud --domain unit-square --points 30 --scale 300 |
    triangulate --output-format tgf |
    traverse --traversals 3 --length 10 --random-length --remove-after-traverse |
    smooth --iterations 5 |
    wkt2svg
```
![Increasing the point cloud size](/images/asemic-writing/refined-02-size.svg "Increasing the point cloud size")

This could also be promising! It also used Delaunay triangulation directly. What is it like with the
relative neighborhood?
```sh
$ point-cloud --domain unit-square --points 30 --scale 300 |
    urquhart --output-format tgf |
    traverse --traversals 3 --length 10 --random-length --remove-after-traverse |
    smooth --iterations 5 |
    wkt2svg
```
![Increasing the point cloud size](/images/asemic-writing/refined-03-urquhart.svg "Big point cloud with Urquhart")

It seems as though using the relative neighborhood is more likely to generate strokes that don't
intersect, which I don't like.

### Regular grid

It seems as though what these glyphs are missing is self-symmetry, or rather, maybe just some kind
of "relationship" that the human eye can see. They're _too_ random as-is, so what if we use a
regular grid of points instead?

```sh
$ grid --output-format graph 3 4 |
    traverse --traversals 4 --length 5 --remove-after-traverse |
    transform --scale 300 300 |
    smooth --iterations 5 |
    wkt2svg
```
![Using a regular grid](/images/asemic-writing/refined-04-grid.svg "Using a regular grid")

Hmm, now _this_ is something where the human eye sees _order_; I expect that if I were to generate
hundreds of these, and lay them next to each other, it'd look coherent.

### Less smoothing

Something else that we could do is perform fewer iterations of the smoothing algorithm
(specifically, only _one_ iteration to add a bevel to each corner).

```sh
$ grid --output-format graph 3 4 |
    traverse --traversals 4 --length 5 --remove-after-traverse |
    transform --scale 300 300 |
    smooth --iterations 1 |
    wkt2svg
```
![Less smoothing](/images/asemic-writing/refined-05-45deg.svg "Less smoothing")

_That's cool._

### Triangulate the grid

Using a grid added much-needed order, but what if we used triangles instead?
```sh
grid --output-format points 3 4 |
    triangulate --output-format tgf |
    traverse --traversals 4 --length 5 --remove-after-traverse |
    transform --scale 100 100 |
    smooth --iterations 5 |
    wkt2svg
```
![Triangulated grid](/images/asemic-writing/refined-06-triangulate.svg "Using a triangulated grid")

That could probably be compelling. Let's try a few more variations.

```sh
grid --output-format points 3 4 |
    triangulate --output-format tgf |
    traverse --traversals 4 --length 5 --remove-after-traverse |
    transform --scale 100 100 |
    smooth --iterations 1 |
    wkt2svg
```
![Less smoothing](/images/asemic-writing/refined-07-low-smooth.svg "Less smoothing")

```sh
grid --output-format points 3 4 |
    triangulate --output-format tgf |
    traverse --traversals 4 --length 5 --remove-after-traverse |
    transform --scale 100 100 |
    wkt2svg
```
![No smoothing](/images/asemic-writing/refined-08-no-smooth.svg "No smoothing")

I personally find the square grid to be the most compelling variant so far, both with lots of
smoothing, and with 45 degree beveled corners.

## Next steps

As is the case with all generative art, there's a million different variations. And as we've seen,
small changes in the rules can generate significantly different results. Here's a bunch of things
that could be explored next.

* Try biasing the random graph traversal by always starting from an extreme vertex
* Build tooling to sift through the random results and cherry pick the good ones
* Build tooling to tile glyphs (regular grid, ragged left-to-right, top-to-bottom, etc)
* Add diacritical marks
* Use a different tiling (hexagons?)
* Perturb, scale, stretch, skew the grid (The `transform` tool can do some of this)
* Snap random points to a grid (the grid would probably have to be coarse for the results to be
  noticeable).
* Use real splines (NURBS, Hobby splines, etc)
* Use the algorithm from
  [https://inconvergent.net/2017/spline-script/](https://inconvergent.net/2017/spline-script/)
* Add variable stroke widths to look more like calligraphy
* Join multiple glyphs together (cursive)
