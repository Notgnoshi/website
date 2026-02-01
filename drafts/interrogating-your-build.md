# Interrogating your build

This post is an FAQ style page about how to interrogate a C++ CMake project's build system.

## Working with Headers

* How can I identify if a header is missing an include guard?
* Do the headers compile standalone? (g++ -fsyntax-only)
* What is the header dependency graph for a given Translation Unit?
* Given a header, what source files transitively depend on it?
* Sort headers by the number of source files that transitively include them
* Sort source files by the number of headers they transitively include
* What's the deepest include-chain?
* How can I identify unused headers?
* What tools can I use to interrogate specifically my header dependency graph?
* How can I detect circular header dependencies?
* What are the tradeoffs with precompiled headers?
* How can I identify if a header depends on symbols that aren't directly included?
* How can I identify if a header depends on symbols that aren't included? (depends on other headers
  being included first)
* What C++ stdlib headers are expensive to include? Can we reduce the number of source files that
  have to include them?
* What headers are good candidates for precompilation?
* Are there private headers being improperly included by other components? How can I identify this?
* Are there public headers that could / should be private? How can I identify this?
* What includes can be moved from a header to a source file? How can I identify this?
* How can you identify candidates for forward declarations?
* What headers define templated / inlined functions used only in one source file?

## Working with Your Build System

* What's the object file that corresponds to a given source file?
* How can I get a list of all the source files in my build? (Including generated source files)
* What things trigger a CMake reconfigure?
* When do I need to manually trigger a CMake reconfigure?
* How can I identify dead source files and headers?
* What files got generated during a CMake reconfigure?
* If the build generates some source files, how can I find them?
* How many object files are in each of our libraries?
* How can I see the target / library level dependency graph? - cmake --graphviz
* How can I interrogate a graphviz file without needing to render a very large diagram?
* Am I using unity builds? How can I identify this? How do they work? Are they effective?
* What kind of stuff does your CMake reconfigure do? Generate code? Run commands?
* When and where does code generation happen?
* Are there circular library dependencies? How can I identify this?
* What components have the largest fan-in / fan-out?
* How can I find instantiations of templates?
* What object files include the most symbols?
* Are there PUBLIC cmake dependencies that should be PRIVATE or INTERFACE? How to tell? What's the
  impact?
* Are there template instantiations repeated across multiple source files? How can I identify this?
* Are there circular symbol dependencies? How can I identify this?
* What's the impact of -fvisibility=hidden? Can we identify what symbols need to be exported? How
  does symbol visibility work?
* How sensitive is your project to platform-specific / architecture-specific code? How can you
  identify this?
* Where are the conditional compilation hotspots? Do they result in dead code? Do we test them?

## Profiling Your Build System

* How can you identify whether your build is parallelizing effectively? - make -l / ninja -l / ninja
  default / nproc - 2
* If I modify a file, how many things will get rebuilt? Can I tell this without actually performing
  the incremental build?
* Sort files by how frequently they change
* What are the top 10 worse source file offenders from a compile time perspective? From a memory
  usage perspective?
* How can you identify the critical path through your build graph?
