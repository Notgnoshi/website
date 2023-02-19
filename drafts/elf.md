---
title: ELF Files
description: What's an ELF file, and how do I peek under the hood?
date: DRAFT

---

# ELF Files

One of my [values](/values/) is "Digging In". One of the ways this manifests is in what I've taken
to calling "Toolchain Interrogation", that is, learning enough about C/C++/Rust compiler toolchains
to understand _how_ and _why_ they work the way they do.

Deepening my understanding of

* The compilation process
* Compilation artifacts
* How processes are loaded (particularly with respect to dynamic symbol resolution)

has increased my confidence, and enabled me to answer more challenging questions with less
information available. I've been able to figure out tricky linker issues, debug DSO search paths,
troubleshoot static global initialization ordering, understand versioned symbol conflicts, debug
crashes on process startup, and more.

I recommend watching Matt Godbolt's CppCon 2018 talk _The Bits Between the Bits_ for a better
and more interesting introduction. It focuses a little more on answering the question "How does
`main()` get executed?" than I will go into here, but it's what got me started down this path, and I
_highly_ recommend it for any systems programming enthusiast.

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/dOfucXtyEsU" title="YouTube video player" frameborder="0" allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

I normally prefer to start from the bottom up, but topics like the compilation pipeline, binary
artifacts, process runtime (startup, dynamic symbol resolution, debugging, stack unwinding, coredump
generation, etc) are all somewhat interconnected, which makes systematic coverage from first
principles difficult.

So I think it will suffice for now to simple answer the question "What's in an ELF file?".

The [ELF (Executable and Linking Format) file format](https://refspecs.linuxbase.org/elf/elf.pdf) is
used for a large number of binary files

* object files
* executables
* dynamic libraries
* static libraries (`ar(1)` archives of object files)
* coredumps
* debug symbols

We'll focus on executables here, because they'll introduce most of the important concepts.

# The simplest possible example

Consider the following example C++ application:
```cpp
int main() { return 0; }
```

From the beginner's perspective, there's no simpler application! (Although you could get simpler if
you followed [A Whirlwind Tutorial on Creating Really Teens ELF Executables for
Linux](http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html))

Before proceeding with looking at the resulting ELF file, I've found it useful to start with a
refresher on the compilation pipeline. Throughout this page I'll use the GCC toolchain, but the same
concepts hold with any other C++ toolchain.

1. **Preprocess**

   ```sh
   cpp empty.cpp -o empty-preprocessed.cpp
   ```
   Or, equivalently, we could use the GCC frontend for the preprocessor
   ```sh
   gcc -E empty.cpp -o empty-preprocessed.cpp
   ```
   For such a simple example project, the preprocessed output isn't very interesting.
2. **Compile**

   ```sh
   g++ -S empty-preprocessed.cpp -o empty.S
   ```
3. **Assemble**

   ```sh
   as -c empty.S -o empty.o
   ```
   Or, equivalently, we could use the GCC frontend as above
   ```sh
   gcc -c empty.S -o empty.o
   ```
4. **Link**

   Most people invoke the linker using the GCC frontend
   ```sh
   g++ empty.o -o empty
   ```
   But if you enable verbose output
   ```sh
   g++ -v empty.o -o empty
   ```
   you can see that under the hood, `g++` is invoking `ld` with a set of default arguments that do
   things _very_ specific to your particular toolchain
   ```sh
   ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 \
       -o empty \
       -L/usr/lib/gcc/x86_64-linux-gnu/11 \
       -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu \
       -L/usr/lib/gcc/x86_64-linux-gnu/11/../../../../lib \
       -L/lib/x86_64-linux-gnu \
       -L/lib/../lib \
       -L/usr/lib/x86_64-linux-gnu \
       -L/usr/lib/../lib \
       -L/usr/lib/gcc/x86_64-linux-gnu/11/../../.. \
       /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/Scrt1.o \
       /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/crti.o \
       /usr/lib/gcc/x86_64-linux-gnu/11/crtbeginS.o \
       empty.o \
       -lstdc++ -lm -lgcc_s -lgcc -lc -lgcc_s -lgcc \
       /usr/lib/gcc/x86_64-linux-gnu/11/crtendS.o \
       /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/crtn.o
   ```

There's quite a bit of interesting stuff happening in the linking step. In particular, the linker is
setting up default search paths for system libraries, and it's also injecting pre-compiled object
files to setup static global constructors and destructors. Matt Godbolt's talk goes into more detail
on this than I will.

The outputs, `empty.o` and `empty` are ELF files
```sh
$ file empty.o empty
empty.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
empty:   ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=1125813516236d591944beebe6bc65026a401188, for GNU/Linux 3.2.0, not stripped
```

We'll use these trivial examples to dig through what exactly is in an ELF file below before adding
more and more complexity to investigate different aspects of ELF files.

# ELF overview

Typical of most binary data formats, an ELF file consists of a series of headers and tables, with
the headers having predictable sizes and formats, telling us how to read the various tables.

![ELF Layout](https://upload.wikimedia.org/wikipedia/commons/7/77/Elf-layout--en.svg)

The first header in the file is always the same -- called the file header, or sometimes the ELF
header.

## File header

The file header contains a bunch of metadata about the file, including what _type_ of ELF file it
is, and how to proceed parsing the rest of it.

```sh
$ readelf --file-header empty.o
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          448 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)
  Number of section headers:         12
  Section header string table index: 11
```

If we compare the ELF header for the `empty.o` object file and the `empty` executable, we can see a
few notable differences:

```sh
$ readelf --file-header empty
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Position-Independent Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x1040
  Start of program headers:          64 (bytes into file)
  Start of section headers:          13912 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         13
  Size of section headers:           64 (bytes)
  Number of section headers:         29
  Section header string table index: 28
```

The object file doesn't include any **program headers**, and doesn't define the **entry point
address**. Further, the executable has a few extra sections, and _does_ include a program header and
entry point address.

## Section headers

From looking at the file header, we can determine that the meat of the file is stored in things
called sections, defined by a number of **section headers**.

```sh
$ readelf --wide --section-headers empty.o
There are 12 section headers, starting at offset 0x1c0:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000000000 000040 00000f 00  AX  0   0  1
  [ 2] .data             PROGBITS        0000000000000000 00004f 000000 00  WA  0   0  1
  [ 3] .bss              NOBITS          0000000000000000 00004f 000000 00  WA  0   0  1
  [ 4] .comment          PROGBITS        0000000000000000 00004f 000027 01  MS  0   0  1
  [ 5] .note.GNU-stack   PROGBITS        0000000000000000 000076 000000 00      0   0  1
  [ 6] .note.gnu.property NOTE           0000000000000000 000078 000020 00   A  0   0  8
  [ 7] .eh_frame         PROGBITS        0000000000000000 000098 000038 00   A  0   0  8
  [ 8] .rela.eh_frame    RELA            0000000000000000 000140 000018 18   I  9   7  8
  [ 9] .symtab           SYMTAB          0000000000000000 0000d0 000060 18     10   3  8
  [10] .strtab           STRTAB          0000000000000000 000130 000010 00      0   0  1
  [11] .shstrtab         STRTAB          0000000000000000 000158 000067 00      0   0  1
```

Interestingly, we see from the file header:

> ```
> Size of section headers:           64 (bytes)
> ```

from which we can infer that the section name isn't included in the section header. We can confirm
by looking at [elf(5)](https://linux.die.net/man/5/elf) or the
[ELF standard](https://refspecs.linuxbase.org/elf/elf.pdf) if we wanted more details. The section
names are stored in their own string table section:

> ```
> Section header string table index: 11
> ```

The 11th section header:

> ```
> [11] .shstrtab         STRTAB          0000000000000000 000158 000067 00      0   0  1
> ```

So we can dump this string table and confirm that we see the actual section names

```sh
$ readelf --wide --string-dump=.shstrtab empty.o

String dump of section '.shstrtab':
  [     1]  .symtab
  [     9]  .strtab
  [    11]  .shstrtab
  [    1b]  .text
  [    21]  .data
  [    27]  .bss
  [    2c]  .comment
  [    35]  .note.GNU-stack
  [    45]  .note.gnu.property
  [    58]  .rela.eh_frame
```

This isn't normally something that's useful to do because
[readelf(1)](https://linux.die.net/man/1/readelf) is smart enough to parse the `.shstrtab` table in
order to display the section headers with more helpful output.

## Program headers and segments

The **Program Header** defines what **Segments** get loaded into memory. Segments consist of one or
more **Sections**, which are defined by the **Section Header**.
Object files don't have segments, because they don't define how something gets loaded into memory.

```sh
$ readelf --segments empty.o
There are no program headers in this file.
```

That's something an executable (or a shared library) defines.

```sh
$ readelf --segments --wide empty

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000000040 0x0000000000000040 0x0002d8 0x0002d8 R   0x8
  INTERP         0x000318 0x0000000000000318 0x0000000000000318 0x00001c 0x00001c R   0x1
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x0005f0 0x0005f0 R   0x1000
  LOAD           0x001000 0x0000000000001000 0x0000000000001000 0x000145 0x000145 R E 0x1000
  LOAD           0x002000 0x0000000000002000 0x0000000000002000 0x0000c4 0x0000c4 R   0x1000
  LOAD           0x002df0 0x0000000000003df0 0x0000000000003df0 0x000220 0x000228 RW  0x1000
  DYNAMIC        0x002e00 0x0000000000003e00 0x0000000000003e00 0x0001c0 0x0001c0 RW  0x8
  NOTE           0x000338 0x0000000000000338 0x0000000000000338 0x000030 0x000030 R   0x8
  NOTE           0x000368 0x0000000000000368 0x0000000000000368 0x000044 0x000044 R   0x4
  GNU_PROPERTY   0x000338 0x0000000000000338 0x0000000000000338 0x000030 0x000030 R   0x8
  GNU_EH_FRAME   0x002004 0x0000000000002004 0x0000000000002004 0x00002c 0x00002c R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
  GNU_RELRO      0x002df0 0x0000000000003df0 0x0000000000003df0 0x000210 0x000210 R   0x1

 Section to Segment mapping:
  Segment Sections...
   00
   01     .interp
   02     .interp .note.gnu.property .note.gnu.build-id .note.ABI-tag .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn
   03     .init .plt .plt.got .text .fini
   04     .rodata .eh_frame_hdr .eh_frame
   05     .init_array .fini_array .dynamic .got .data .bss
   06     .dynamic
   07     .note.gnu.property
   08     .note.gnu.build-id .note.ABI-tag
   09     .note.gnu.property
   10     .eh_frame_hdr
   11
   12     .init_array .fini_array .dynamic .got
```

This diagram helps summarize what's in an ELF file, and where they're located.

![ELF 101](https://i.imgur.com/EL7lT1i.png)

(source: https://github.com/corkami/pics/tree/master/binary/elf101)

So let's run this application with GDB and start looking at where things are in memory.

```sh
$ gdb --quiet -ex "break main" -ex "run" empty
(gdb) info proc mappings
process 230427
Mapped address spaces:

          Start Addr           End Addr       Size     Offset  Perms  objfile
      0x555555554000     0x555555555000     0x1000        0x0  r--p   /home/nots/Documents/elf-interrogation/examples/empty/empty
      0x555555555000     0x555555556000     0x1000     0x1000  r-xp   /home/nots/Documents/elf-interrogation/examples/empty/empty
      0x555555556000     0x555555557000     0x1000     0x2000  r--p   /home/nots/Documents/elf-interrogation/examples/empty/empty
      0x555555557000     0x555555558000     0x1000     0x2000  r--p   /home/nots/Documents/elf-interrogation/examples/empty/empty
      0x555555558000     0x555555559000     0x1000     0x3000  rw-p   /home/nots/Documents/elf-interrogation/examples/empty/empty
(program break)
      0x7ffff7d77000     0x7ffff7d7a000     0x3000        0x0  rw-p
      0x7ffff7d7a000     0x7ffff7da2000    0x28000        0x0  r--p   /usr/lib/x86_64-linux-gnu/libc.so.6
      0x7ffff7da2000     0x7ffff7f37000   0x195000    0x28000  r-xp   /usr/lib/x86_64-linux-gnu/libc.so.6
      0x7ffff7f37000     0x7ffff7f8f000    0x58000   0x1bd000  r--p   /usr/lib/x86_64-linux-gnu/libc.so.6
      0x7ffff7f8f000     0x7ffff7f93000     0x4000   0x214000  r--p   /usr/lib/x86_64-linux-gnu/libc.so.6
      0x7ffff7f93000     0x7ffff7f95000     0x2000   0x218000  rw-p   /usr/lib/x86_64-linux-gnu/libc.so.6
      0x7ffff7f95000     0x7ffff7fa2000     0xd000        0x0  rw-p
      0x7ffff7fbb000     0x7ffff7fbd000     0x2000        0x0  rw-p
      0x7ffff7fbd000     0x7ffff7fc1000     0x4000        0x0  r--p   [vvar]
      0x7ffff7fc1000     0x7ffff7fc3000     0x2000        0x0  r-xp   [vdso]
      0x7ffff7fc3000     0x7ffff7fc5000     0x2000        0x0  r--p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
      0x7ffff7fc5000     0x7ffff7fef000    0x2a000     0x2000  r-xp   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
      0x7ffff7fef000     0x7ffff7ffa000     0xb000    0x2c000  r--p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
      0x7ffff7ffb000     0x7ffff7ffd000     0x2000    0x37000  r--p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
      0x7ffff7ffd000     0x7ffff7fff000     0x2000    0x39000  rw-p   /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
      0x7ffffffde000     0x7ffffffff000    0x21000        0x0  rw-p   [stack]
  0xffffffffff600000 0xffffffffff601000     0x1000        0x0  --xp   [vsyscall]
```

All this shows is that there's a few memory regions, and where their addresses are, with a _little_
bit if information on what's loaded into those regions.

```
+--------------+ 0x555555554000
|              |
| ELF Segments |
|              |
+--------------+ 0x555555559000
| Heap         |
+--------------+ 0x555555559000 (program break)
...
+--------------+ 0x7ffff7d77000
|              |
| Loaded DSOs  |
|              |
+--------------+ 0x7ffff7fff000
...
+--------------+ 0x7ffffffde000
|              |
| Stack        |
|              |
+--------------+ 0x7ffffffff000
```

From the GDB output, we can grok that the stack starts at a high address (`0x7ffffffff000`) and
grows _downwards_ to low addresses. If you've ever written assembly, this is why we normally
_decrement_ from the stack pointer to grow the stack.

The heap, which we'll investigate later, starts at a low address, and grows updwards as the
**program break** is incremented. Also note that the heap technically has a maximum size, because if
it grows too far, it will run into the loaded dynamic libraries. But `0x7ffff7d77000 -
0x555555559000 = 46,912,359,227,392` bytes (46.9 TB), which for consumer systems could well be
considered infinite (as of 2020).

This also shows that the stack has a maximum size of `0x7ffffffff000 - 0x7ffffffde000 = 135,168`
bytes, which is much more likely to _Stack Overflow_ if, for example, a resursive application
recurses too far.

It's not shown here, but it's also worth noting that each thread has its own stack, but that all
threads share the same heap.

**TODO:** Link to "How processes get loaded into memory" (this will cover the heap)

# What could possibly go wrong?!

## String table

## Symbol table

## Stripping

## Code

## Data

### Static constants
### Local constants
**TODO:**
### Global / static locals
**TODO:**

## Debug symbols
## Relocations
**TODO:**
## Dynamic symbols
**TODO:**
## DT_RPATH and DT_BIND_NOW
**TODO:**
## Metadata
**TODO:**
## Customizing sections with GCC
**TODO:**
## Per-thread stacks
**TODO:**
## Thread local storage
**TODO:**
