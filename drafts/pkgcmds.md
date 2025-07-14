---
title: Package management command cheat sheet
date: 2025-07-14
description: A cheat sheet for different rpm/deb package management commands

---

# Package management command cheat sheet

```{toc}
```

Many of the following `rpm` commands use `rpm -q <package>` to query against an installed package by
name. You can also query a possibly-uninstalled `.rpm` file with `rpm -qp path/to/package.rpm`.

## What does a package depend on?

```sh
# dnf/rpm
dnf repoquery --installed --requires <package>
rpm --requires -q <package>
```

You can replace `--requires` with `--provides` and `--conflicts` for more information.

```sh
# apt/deb
apt-cache depends <package>
```

## What packages depend on the given package?

```sh
# dnf/rpm
dnf repoquery --installed --whatrequires <package>
rpm --whatrequires -q <package>

# apt/deb
apt-cache rdepends --installed <package>
```

## Which package provides a given file?

```sh
# dnf/rpm
rpm -qf <path/to/file>

# apt/deb
dpkg -S <path/to/file>
```

## List pre|postinst scriptlets in a package

```sh
rpm -q <package> --scripts

# From a given .deb package
dpkg --dry-run -i <package.deb>
# From an installed .deb package
ls /var/lib/dpkg/info/<package>*
```

## List contents of a package

```sh
rpm -ql <package>
rpm -qpl <package.rpm>
dpkg -L <package>
dpkg --contents <package.deb>
cat /var/lib/dpkg/info/<package>.list
```

## Extract contents of a package

It's often super useful to extract the contents of a package to a temporary prefix without
installing the package.

```sh
# For an .rpm
sudo apt install rpm2cpio
mkdir prefix/
cd prefix/
rpm2cpio <package.rpm> | cpio -idmv
cd ../
tree prefix/
```

```sh
# For a .deb
dpkg --contents <package.deb>
dpkg-deb -x <package.deb> prefix/
```

## List installed packages

```sh
rpm -qa
dnf list --installed
apt list --installed
```

## Remove a package and anything that depends on it

```sh
dnf remove <package>
apt remove <package>
```

## Remove a package, but not things that depend on it

```sh
rpm --nodeps -e <package>
```

## Install a package from file

```sh
rpm -i <package.rpm>
rpm --force -i <package.rpm>

# Needs ./ prefix to look for the given package file, instead of treating as a package name
dnf install --nogpgcheck ./package.rpm
apt install ./package.deb
```

## TODO

* How to audit recent transactions?
  * Failed scriptlets
  * Conflicts
  * What caused a change
* Where are rpms downloaded to?
* How to download an rpm from a package feed without installing it
* How does the rpm database work?
* Repos? Channels?
* Package name vs package provides vs package filename (I've seen all three be different!)
* How are dnf, yum, smart, and rpm all related?
