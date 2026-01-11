---
title: Profiling a C++ CMake build with buildbloat
date: DRAFT
description: How to profile a C++ CMake build with buildbloat to generate a treemap of compile times

---

# Profiling a C++ CMake build with buildbloat

This page describes how to use [buildbloat](https://github.com/Notgnoshi/buildbloat) to profile a
C++ CMake build and generate a treemap visualization of compile times with
[webtreemap](https://github.com/Notgnoshi/webtreemap) using [geos](https://github.com/libgeos/geos)
as a nontrivial C++ example project.

This can be useful to understand what parts of your build take the most time at a larger granularity
than you get with tools like <https://github.com/royjacobson/externis> or
<https://github.com/jrmadsen/compile-time-perf>. This also doesn't tell you _what about_ your build
is slow; is it because your Translation Units are massive? Or is it template instantiation? or is it
a CMake [`add_custom_command`](https://cmake.org/cmake/help/latest/command/add_custom_command.html)
that runs every time you build?

## Prerequisites

* A C++ toolchain
* Ninja (buildbloat processes Ninja build logs)
* Node.js and NPM (for webtreemap)

## Run your CMake build with Ninja

If you're using `ccache`, you probably want to disable it for the sake of accurate profiling.

```sh
rm -rf ./build/
export CCACHE_DISABLE=1
cmake -B ./build/ -G Ninja
cmake --build ./build/ --parallel
```

```{warning}
Depending on your project size and build system capabilities, you may want to limit the number of
jobs more than just "use all the cores". You can do this with `--parallel $(($(nproc) - 4))` or
similar.
```

Ninja generates `build/.ninja_log` which we will use for generating the treemap. But first, we need
to convert it to a format that `webtreemap` understands.

````{warning}
I can't find "official" documentation for this file format, but I did find
<https://pkg.go.dev/go.fuchsia.dev/fuchsia/tools/build/ninjago/ninjalog> which documents it as

```
# ninja log v5
<start>\t<end>\t<restat>\t<target>\t<hash>
```

but it appears the format version was bumped to v6 with Ninja 1.12, and to v7 with Ninja 1.13. From
looking at <https://github.com/ninja-build/ninja/commits/master/src/build_log.cc> it appears the
only differences between v5, v6, and v7 are the implementation details of how the `<hash>` field is
calculated and formatted, which we don't care about for our purposes.
````

## Convert the Ninja build log to du format

`webtreemap` wants its input in the format

```
<size>\t<path>
```

but the Ninja build log is

```
<start>\t<end>\t<restat>\t<target>\t<hash>
```

so we use [buildbloat](https://github.com/Notgnoshi/buildbloat) to convert between the two format.

```sh
git clone https://github.com/Notgnoshi/buildbloat.git
cd geos
../buildbloat/buildbloat.py --build-dir ./build >./build/bloat.log
```

```{info}
I found that the build for the project I was working on mixed relative and absolute paths in the
`.ninja_log` file, hence the addition of the `--build-dir ./build` argument, which causes
`buildbloat.py` to convert each path to be relative to the given build directory.
```

## Generate the treemap

First we have to install `webtreemap`

```sh
git clone git@github.com:Notgnoshi/webtreemap.git
cd webtreemap
# Install dependencies in a local env
npm install
# Build webtreemap
npm run build
# Make webtreemap script globally available
npm link
```

````{warning}
Preface: I'm not a web developer.

I wanted easier installation instructions than this, but I struggled to make it work any other way.

If you run `npm install webtreemap`, that installs a prebuilt version from <npmjs.com>. But if you
run `npm install evmar/webtreemap`, that installs from GitHub (not <npmjs.com>) and does not install
the CLI tool (because it hasn't been built).

Searching around lead me to believe that adding

```json
"scripts": {
    "prepare": "npm install && npm run build"
}
```

to the `package.json` would run the build during `npm install Notgnoshi/webtreemap` but that did not
work, seemingly because the `npm install` was screwing with my global `node_modules` installation.

If you know how to make this work, please let me know!
````

Now we can generate the treemap HTML file:

```sh
webtreemap --title GEOS -i ./build/bloat.log -o ./build/bloat.html
xdg-open ./build/bloat.html
```

## All together

It's a bit easier to run all in one line than to stash the intermediate log file as this lets you
run and re-run it over and over while you're iterating:

```sh
~/src/buildbloat/buildbloat.py --build-dir ./build/ ./build/.ninja_log | webtreemap --title GEOS -o ./build/bloat.html
```

## Improvements

If you're trying to tell a story with the results, you likely want to colorize some of your treemap.
It'd be cool if `webtreemap` could do this automatically using heuristics (i.e., high saturation for
large sizes, decreasing as you get smaller; children sharing the same hue as their parent, except if
a sibling is large enough proportional to another child, it should get its own hue?), but for now
you can do it manually by defining your own substrings with `-c <substring>`:

```sh
~/src/buildbloat/buildbloat.py --build-dir ./build/ ./build/.ninja_log |
    webtreemap --title GEOS -o ./build/bloat.html -c operation -c geom -c algorithm -c noding -c test
```

I hacked that capability into my fork of `webtreemap`, so the poor quality substring matching is all
my fault, not the original author's.

## Results

We can see that the majority of build time is spent building GEOS's tests. After that, it's the
`operation` module.

<iframe src="geos-bloat.html" style="border:none;" width="1610px" height="1210px"></iframe>

## Bonus: SLOC treemap

```sh
shopt -s globstar
wc -l --total=never ./**/*.{cpp,h,in,hpp,c} |
    awk '{$1=$1;print}' |
    webtreemap --title "GEOS SLOC" -o ./build/sloc.html -c geom -c operation -c algorithm -c deps -c vend -c tests
```

<iframe src="geos-sloc.html" style="border:none;" width="1610px" height="1210px"></iframe>
