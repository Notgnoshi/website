---
title: BitBake pkgdata cheat sheet
date: DRAFT
description: A cheat sheet for frequently reached for pkgdata investigation
---

# BitBake pkgdata cheat sheet

```{toc}
```

This cheat sheet expands [Package management command cheat sheet](/pkgcmds) to include similar FAQs
for BitBake recipes and package data.

## How many different names for a package can there be?

1. **Recipe name** - this is defined by the name of the BitBake recipe, and is accessed through
   `${PN}`. You can access the pkgdata for a recipe name in `${TMPDIR}/pkgdata/${MACHINE}/${PN}`.
   The `PACKAGES` pkgdata variable defines the packages that a recipe provides. The `DEPENDS`
   variable uses the recipe name. `RDEPENDS` uses the internal package name.

2. **Internal package name** - this is the name of the package as utilized within BitBake recipes,
   i.e., in `RDEPENDS`, etc. You can access the pkgdata for an internal package name in
   `${TMPDIR}/pkgdata/${MACHINE}/runtime/<pkg>`. There is no magic variable to access the internal
   package name within a BitBake recipe. Recipes can provide _many_ packages.

3. **Published package name** - this is the name of the package as it is used by DNF, RPM, DEB, IPK,
   etc. You can access the pkgdata for a published package name in
   `${TMPDIR}/pkgdata/${MACHINE}/runtime-reverse/<pkg>`. These files are symlinks into `../runtime/`

## Multiple layers provide a recipe, which one wins?

* Given a package name, you can lookup the recipe name by
  * Inspecting `pkgdata/${MACHINE}/runtime/<pkg>` (or `runtime-reverse`) and looking for `PN:`
  * Using `oe-pkgdata-util lookup-recipe <pkg>`

  however, most of the time, the recipe name is the same as the package name, so this is less
  helpful.
* Given a recipe name, you can find _candidates_ by
  * `bitbake-layers show-recipes <recipe>` - this will show the layer name, and the `${PV}`
  * `fd <recipe> build/layers/`
* Given a recipe name, you can lookup the recipe file by
  * `bitbake -e <recipe> |& grep ^FILE=` to find the recipe file. (`bitbake -e` is a _really_ handy
    troubleshooting tool to keep in your back pocket)
  * `bitbake-getvar -r <recipe> FILE`

There are _lots_ of controls to set layer priority, pick preferred versions, pick preferred
providers for virtual packages, mask out recipes, etc.

## What package / recipe ships a given file path?

If you have the ability to investigate the generated image, you can use `rpm -qf <path/to/file>` to
search through RPM's database for what package shipped a give file.

In the BitBake context, you can use the pkgdata files with
`oe-pkgdata-util find-path <path/to/file>` The file path accepts `fnmatch` style globs.

## What files does a package ship?

If you can login to a runtime image, you can run `rpm -ql <pkg>`. If you have the `.rpm` package
file, you can run `rpm -qpl <pkg.rpm>`.

If you want to tell what a package ships from the BitBake context, then we go to the pkgdata files
with `oe-pkgdata-util list-pkg-files <pkg>` or `oe-pkgdata-util read-value FILES <pkg>`.

## What recipes does a recipe depend on?

For direct dependencies declared in the recipe, you can use `bitbake-getvar -r <recipe> DEPENDS` or
`bitbake -e <recipe> |& grep ^DEPENDS=`.

If you want to include transitive dependencies, you can use `bitbake -g <recipe>` to generate
`task-depends.dot` and then use `oe-depends-dot -d -k <recipe> task-depends.dot` to list the
dependencies of the recipe.

## What packages does a package depend on?

This is the `RDEPENDS` variable in the pkgdata file. Use `oe-pkgdata-util read-value RDEPENDS <pkg>`

## What depends on a given recipe?

Use `bitbake -g <recipe>` to generate `task-depends.dot`, and then use
`oe-depends-dot -w -k <recipe> task-depends.dot` to list the recipes that _depend on_ the given
recipe. This is most useful when you run `bitbake -g core-image-minimal` (or your particular product
image) to include the _full_ set of recipe dependencies.

## What depends on a given package?

This one's harder. If you can login to a runtime image, you can use `rpm --whatrequires -q <pkg>`.

But in the BitBake context, there's no reverse-RDEPENDS index to give us the answer in a single
query. So we have to parse the whole batch of pkgdata files with something like

```sh
rg -l '^RDEPENDS:[^:]+:.* <pkg>( |\(|$)'
```

## What packages are included in my image?

Look at the `${TMPDIR}/deploy/images/${MACHINE}/<image>.manifest`, or use `rpm -qa` in the runtime
image.
