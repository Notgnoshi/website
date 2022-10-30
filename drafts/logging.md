---
title: Logging
description: Stuff I've learned about logging
date: DRAFT

---

# Logging

## Event based
## Explain _why_
## Logs should be useful
## What's "useful" changes over time
## What's "useful" is different based on your perspective
Especially library vs application.

## Asynchronous
## Logs should be quiet when nothing is happening
## The happy path should be quiet
## Log on interface boundaries
Especially IPC. But pay attention to how frequently messages are sent. Turn off spammy messages by
default.

If you _really_ care about them, add a toggle, or a way to identify the interesting times _to_ log
them. Like `spdlog`'s backtrace.

## Hierarchical categories are great
## Most logging libraries are missing the NOTICE level
## Libraries should grant applications control over their logs
## Logs should be written to disk and rotated
