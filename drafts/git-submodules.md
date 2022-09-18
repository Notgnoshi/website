---
title: Git submodules
date: DRAFT
description: Tips, tricks, and lessons learned with submodules

---

# Git submodules

## What _is_ a submodule?

## How to add a submodule?

This can go wrong if you get confused. E.g., if you unstage things that `git submodule add` staged.
It's also not sufficient to just edit `.gitmodule`.

Do _not_ run
```bash
git submodule add $URL $PATH
# do some work
# get confused
git restore --staged $PATH
# get more confused
git add $PATH
git commit
```

Do this in its own commit (makes rebases easier)


## Relative vs HTTPS vs SSH submodule URLs

There are tradeoffs for all three.


HTTPS with basic authentication is deprecated in most cases. You often are forced to use SSH or
token-based authentication just to clone.

At work, relative URLs has been a source of pain, particularly after making acquisitions and
migrating repositories.

For a public project though, using an SSH URL might cause frustration for your users, who may have
cloned the super project without ever having setup an SSH key with the Git forge.

See also https://stackoverflow.com/questions/6031494/git-submodules-and-ssh-access

## How to update a submodule

`git diff --submodule`, and `git show --submodule` are helpful!

Do this in its own commit, and include notable changes being brought in.

_Always ensure that the commit a submodule points to is reachable on the remote_

## How is the submodule laid out on the filesystem?

* `.gitmodules`
* `.git/config`
* `path/to/submodule/`
* `path/to/submodule/.git`
* `.git/modules/path/to/submodule/`

## How to move a submodule

## How to extract a subdirectory into its own repository and then submodule it

Don't.
