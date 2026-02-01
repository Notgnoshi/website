# Interrogating GraphViz dependency graphs

* Filter out subtrees
* Identify isolated islands
* Identify circular dependencies
* Identify simplification opportunities? - transitive reduction?
* Convert between .dot, .d, and .tgf graph formats
* Identify strongly connected components
* Shorten node names
  * Strip off a common base path
  * Use shortest unique path
  * Shorten directory names to single characters
* Clustering algorithms
* Given a node, what does it depend on? What depends on it?

I suspect I'll end up building tool(s) to help answer these questions. Is Bash / FZF a good choice?
(the actual processing would be done in Python via dedicated scripts) Maybe Rust?
