---
title: Personal values
description: What I've learned about my personal values
date: DRAFT

---

# Personal values

A few days ago, I was in some internal training where we went through an exercise to help us
determine our core values. While to some degree I already knew what my values were, I found the
exercise helped me put my core values into perspective against the backdrop of the rest of my
values. This exercise also helped explain some of what I've found most frustrating at work.

My core values are **interrogation**, **trust**, and **openness**.

## Interrogation

This is an odd one, that I doubt you'd see if you were to Google for a list of personal values. But
I've learned that it's _really_ important to me to "dig in", to ask (and answer!) questions that are
difficult to answer with my current level of understanding.

Continual growth is a common value (I hope, anyways), and it's somewhat related. You _have_ to grow,
to learn, and to become more capable to interrogate systems you don't understand. While the
understanding is important (vital, in fact), that's not what's most important to me. What I find
important, is the ability to be confronted with a problem I don't understand, and to pull on
whatever threads I find until I construct an understanding that's useful enough to take action on.
It's about saying "Huh. This doesn't match my expectation. Why?"

It's also related to "drive". It takes strategic planning, patience, dedication, and the ability to
be frustrated without getting discouraged to start pulling on threads. Most importantly though, it
also requires you to recognize tunnel vision so that you can pull back and ask "What am I _actually_
trying to do here?".

I tend to do depth-first searches rather than breadth-first. The unfortunate thing about software,
is that there's a _huge_ amount of depth -- eventually, you get to the fundamental laws of
mathematics, and let me tell you what, my manager _loves_ being told a bug fix is mathematically
impossible. So it's important to know when to start popping sub-problems off the stack so you can
focus on things to move you closer to your goals.

### Example

At work, we recently updated a project to use Rust 1.62.1 instead of 1.60.0 (the feature we wanted
was stabilized in 1.61.0, but 1.62.1 was the latest stable release at the time), and doing so broke
a doctest somewhat unexpectedly -- all of a sudden, that particular test could no longer find a
shared library!

Eventually, I found the issue by running `rustdoc` from 1.60.0 and 1.62.1 with `strace`, and then
diffing a few million lines of output, which was a messy diff, because the strace logs contained
version numbers, timestamps, and hashes, which were uninteresting diffs.

After getting my difftool to ignore these uninteresting differences, I was able to determine the
cause to be [rust#95604](https://github.com/rust-lang/rust/pull/95604), which was exacerbated by
[cargo#8531](https://github.com/rust-lang/cargo/issues/8531) but only after significant. (but super
interesting) effort.

The result? We disabled that test, which was the original recommendation of the team, but I wasn't
comfortable _disabling_ a _test_ without first knowing _why_ it was failing.

### Example

A colleague volunteered to work on a bug ticket in a system I'm very familiar with (I wrote the bug
🙁). I gave them some advice, and told them I had a suspicion of which subsystem the bug was in, but
that the application log files would tell them for sure, as long as they changed the log level to
DEBUG.

So I recommended turning up the default log level to DEBUG before attempting to reproduce. I made
this recommendation over several standups, and to my dismay, this colleague had _no_ interest in
looking at the logs.

After we finally reproduced the issue together in an unrelated meeting several weeks later, and
wouldn't you know it, looking at the logs pointed out the root cause in a single digit number of
minutes.

Of course I _knew_ what to look for, and I _knew_ that the information was there. But my colleague
wasn't willing to "dig in" to the logs (they're somewhat verbose, but if you turn only the subsystem
you're interested in to DEBUG level, they have a pretty high signal-to-noise ratio).

I've found this to be true over the last few years -- that I tend to immediately jump to looking at
the log files (or core dumps and screenshots; things that are tangible and can't be argued with),
even going as far as regularly comparing the log files of one system to an adjacent, related system.
It's a skill that I've built up over time; being able to debug a system by reconstructing the events
from logs files. And I've put significant effort in making the software I work on understandable by
paying close attention to what we log, and when we log it. But what I've found when suggesting to
coworkers that they look at the logs, is that they don't want to "dig in", to start looking at what
_actually_ happened, and why that might not match their expectation of what _should_ happen.

This is frustrating, when "digging in" is something I _highly_ value -- especially when I _know_ the
information we need is there (because I _put_ it there!) -- and it's not valued by my peers.

## Trust results in freedom

I've also learned that I value freedom. I don't respond well when I'm told how to do something,
_especially_ if it's something I'm a subject matter expert in (or even just barely competent, like
washing the dishes, but that's a story I do _not_ want to expound on).

For example, this has come up at work in how we approve and merge pull requests. Someone was upset
with a recent change, and changed the project settings so that only a few people could approve and
merge pull requests. This person was _not_ a project owner, and made this change without expressing
their concern, or talking to the rest of the team.

So now, I can review someone else's code, but my approval is no longer good enough?! And when it
_is_ approved, even by one of the select few, I can't even _merge_ it?!?! As a senior engineer, and
an owner of the project?!

Now don't get me wrong, it's not the freedom to write and merge whatever I damn well please that I'm
after. I understand the value of code review, and believe that _every_ submission should be
reviewed.

But what happened, was that someone was disappointed, decided they didn't trust the team, and
instead of building up that trust, instead of addressing the issue, they built up nonsensical
controls that _perpetuated_ the lack of trust.

It's easy to focus on freedom, as it's easier to measure. But it wasn't the change in freedom that
bent me out of shape. I think it's perfectly acceptable to have a list of who can and can't approve
pull requests. What I learned about myself, is that I value _trust_, and that I don't function well
in a team that doesn't trust each other.

When you _are_ in such a team (I am now, and I love it), this trust results in quite a few positive
outcomes
* Code reviews become more respectful, and productive
* We become more open about failure, and consequently growth
* We become more open about receiving feedback (or even becoming _willing_ to receive feedback)
* I come to work every day _excited_ to work on both the project, _and_ with the team I'm on. This
  is _incredible_.
* We have the _freedom_ to adapt our processes, our software, and our workflow to our needs

This has come up when discussing certain design patterns in projects owned by other teams. There's a
certain family of projects at work, where the owner doesn't trust the technical excellence of their
team, which caused them to reach for some quite complex design patterns to make things "just
magically work" without trusting the team to understand what the needs of each project are, and to
configure them appropriately. This colleague's goals is no No-Code their way to victory. That would
be a quite cool technical achievement, but my perspective is that it's born from a lack of trust
(which isn't completely baseless, there's opportunities for excellence anywhere and everywhere).

Instead of responding to a lack of trust by throwing up more and more controls, I value responding
by building up the trust level -- doing more training, having conversations on what I want to see in
a high quality piece of software.

A culture of trust and respect results in freedom.

## Openness enables opinionation

> Strong opinions loosely held.

I'm an opinionated person, and the ability to express my opinions is important to me. I do not
hesitate to say "I disagree, here's what I think, and why", and it's important to me that I work in
an environment where this is possible. But I work on a team _full_ of opinionated engineers who
don't hesitate to voice their own opinions. And our opinions are all _different_.

Your first reaction might be "That sounds _hellish_, how do you get anything _done_?" but I really
quite the dynamic. I think it's only successful because of the culture of trust and mutual respect
that the team has built over the past few months.

One of the ways I think we've built this culture, is through being open to changing our opinion, and
through being open to trying something that doesn't quite sit comfortably. It's sometimes pretty
hard -- a lot of our opinions are on things that we've personally experience pain with, and we don't
want to experience that pain again! This can result in very _strongly held_ opinions.

There's a few ways that we've still been able to be productive without requesting transfers to
another team. To a person, we're all open to changing our opinions when presented a (compelling)
reason. Sometimes though, we have to say "Okay, I don't quite agree, but I'm willing to help you try
it out". This has been important, because each team member has different strengths, and is a subject
matter expert in _some_ part of the system. So we frequently say "Seeing _this_ surprised me, I
initially though _that_ might be better". Sometimes, the resolution is "Oh, yeah, that's pretty
sweet". Sometimes though, the resolution is "I tried that, but here's why it didn't work".

Sometimes, I've even found us having heated disagreements over how much we agree. Communication is
the single hardest thing about my job, and I'm not sure that will ever stop being true. We often
have the same values, and come to different conclusions. We also commonly use different words to say
the same thing, but we don't quite understand what the other person is saying, so we immediately
jump to disagreeing with them (because we _know_ that we're right). The helpful thing to do in these
kinds of conversations, is to try to identify _why_ we're disagreeing, and even _what_ we're
disagreeing about.

I value being opinionated, but this _must_ be tempered with being open to changing my opinion. I
still struggle with this, and have to be intentional when I approach conversations. I've found that
even identifying disagreement can help its resolution. We often argue without even knowing what
we're arguing about. It's pretty helpful to try to restate what someone else's opinions are, without
making any kind of judgement on them -- "Can I try to restate your opinion to make sure I
understand? You think ... because ...?"

Being opinionated only works in an environment of trust and a willingness to change your opinion.
