---
title: Toolchain interrogation
description: Interrogating your C/C++ toolchain
date: DRAFT

---

# Toolchain interrogation

I've always found compilers interesting. Not _how they work_, but rather _how to use them_. I've
recently taken to calling this "Toolchain Interrogation" -- which I declare means being able to
take an understanding of a toolchain, and use it to reason about certain classes of problems, both
at build time, and at run time.

## What _is_ a toolchain?

First, what even _is_ a toolchain. It's a word that gets thrown around a lot at work, but we don't
always use it correctly.

A toolchain is a suite of tools used to build software.

* https://elinux.org/Toolchains
* https://en.wikipedia.org/wiki/GNU_toolchain
* https://stackoverflow.com/questions/60546658/what-are-the-differences-between-c-toolchains-and-compilers
* https://android.googlesource.com/toolchain/llvm_android/+/master/README.md
* https://clang.llvm.org/docs/Toolchain.html

## What does _interrogating_ a toolchain mean?

TODO: Link to previous post on Values.

Interrogation is a _core value_ of mine. Interrogation means, that when you're confused, uncertain,
and unsure how (or why) something works (or doesn't work), you are willing and able to _dig in_ and
interrogate the problem until you get an answer.

## What questions might you be able to answer by interrogating your toolchain?

* What's in an ELF file?
* How do ELF files from different compilers differ?
* How are ELF files loaded into memory by `ld.so`?
* How are dynamic symbols resolved by `ld.so`?
    * How and why are DSOs versioned?
    * What are versioned symbols?
    * What are weak symbols?
* How does LTO work, and what can and can't it do?
* What does the CMake/Autotools compilation pipeline look like?
* What is linking?
* How does `main()` get executed?
    * Related - how are static globals initialized and deinitialized?
* How can you control where things are in memory with linker scripts?
* How can I understand the generated code, both in size and complexity?
* How are debug symbols used?
* How does a debugger work?
* How are coredumps generated?
* How do exceptions work?
    * Related - how do Rust panics work?
* What's the C/C++ runtime?
    * libc++abi, compiler-rt, libunwind (which one?) libatomic, libgcc,
      libgcc_s, libsupc++, libcxxrt, etc.
    * Scrt1.o, crti.o, crtbeginS.o, crtendS.o, crtn.o
    * _not to mention_ libc (which one?), libstdc++, or libcxx
* How do code coverage instrumentation work? Line? Branch?
* Why are Rust binaries so large?
* What _is_ an ABI? And how does it differ from an API?

These are all really damn interesting questions, and in order to answer them, you need to be able to
understand both how the toolchain _produces_ software, but you also need to understand how that
software actually _runs_.
