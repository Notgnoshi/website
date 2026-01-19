---
title: Engineering is the art of making tradeoffs to solve constrained problems
description: TODO
date: DRAFT

---

# Engineering is the art of making tradeoffs to solve constrained problems

```{warning}
Calling this page a "draft" is generous; it's really just a brain dump that still needs to
crystalize.
```

```{toc}
```

## The solution landscape

### No solutions

### One solution

### Many solutions

* infinite variations of a solution
* combinatorics
* hybrid solutions

## A professional is pragmatic

A professional most be pragmatic about which problems they choose to solve, how much effort they
expend in their solution, and how they pick which solution to implement.

Sometimes it's too expensive to find an answer. Sometimes finding an answer provides no value other
than to scratch an intellectual itch. Any many times, the number of problems to solve is so large
that you must carefully pick which ones to solve.

## There are many different ways to measure value

* business value - does solving it make the business money?
* technical debt - there's an age-old tradeoff between making a product valuable right now vs making
  it valuable in the future.
* intellectual curiosity - does solving it satisfy your curiosity?
* LinkedIn Driven Development (LDD) - does the solution use new and popular enough frameworks that
  you can post them on your LinkedIn profile?
* intellectual prowess - does the solution sufficiently demonstrate how smart you are?
* long-term maintainability - how does the solution age five years later with a new team with new
  priorities?
* timeline - some solutions are faster to implement than others, but that often comes at the cost of
  some other metric.
* buzzword density - does the solution involve enough buzzwords that the political members of your
  organization believe that it's an appropriate solution?
* social circumstances - how well suited is the team surrounding the problem to understand and
  master the solution?
* generality - how general is the solution? Does it handle edge cases, or just the happy path? How
  easy is it to handle edge cases in the future?

## All problems have constraints

Problem solving can be viewed as a constrained optimization problem. You're trying to maximize some
objective function while satisfying some set of contraints.

```{warning}
Are the values the objective function or constraints? What's the difference?
```

## The "right" solution caters to circumstance

I've encountered folks optimizing for an extreme on each of these axes. And the end result is that
there's a tradeoff involved. Gains made in one axis might result in losses on another. And the
_right_ tradeoff is always unique, and depends on the circumstances surrounding the problem being
solved.

```{dark}
There is **never** an objectively "right" answer. Even when there looks like there is, there's
probably a dimension you're not considering (perhaps you don't believe that dimension is worth
optimizing for).
```

The best problem-solvers I know spend considerable amounts of time thinking about what the _right_
tradeoff is for their particular circumstances. Sometimes it's time, sometimes it's technical
robustness, sometimes it's dollar value.

It's _very_ helpful to understand your own biases, as well as what values your engineering
leadership prefer. Please, remember to approach navigating the solution landscape with an open mind.
I personally tend to value solution-execution over solution-finding, and pragmatism over finding the
"best" most "right" and "optimal" solution.

## How to deconflict design disagreements?

### Identify when you disagree on values

### Idenfity which values to use

```{dark}
One of the roles of engineering leadership is to identify which values matter to the organization.
```

### Split your discussion into enumeration and selection phases

```{warning}
This is hard to do in practice

* Sometimes you're dealing with someone who wants to argue about solutions while you're trying to
  enumerate them (in bad faith)
* Sometimes you're dealing with someone who (in good faith) doesn't understand a solution you've
  enumerated, and wants more detail
* Sometimes during enumeration, you try to identify variations, and it becomes clear that a hybrid
  solution is best
```

### Know when to short circuit the enumeration phase

## Write a design document

There's less to disagree on the shorter it is. The purpose of a design document is to add clarity to
a discussion; so don't drown out clarity with verbosity.

Understand if you need to enumerate and choose a solution, or if you need to design a particular
solution.

Tailor the document to the need. What is there a lack of clarity on? Focus on that.

## The solution landscape

I can't tell you how many times someone has tried to explain a problem to me, while assuming they
already know what the solution is. Often, this very useful; they've already spent some time
considering the problem, the solution landscape, and what the right tradeoffs are for their
circumstance. However, I've also experienced a lot of tunnel vision that these assumptions cause if
they're not managed.

These conversations can often be difficult, because the description of the problem is hidden behind
a description of the believed solution. This can get in the way of understanding! Additionally, the
assumed solutions sometimes pick just a single axis to optimize for, and often miss out on picking
the right tradeoff for whatever circumstances the team(s) find themselves in.

As a result, I make it an effort to interrupt anyone assuming the solution, and tell them "before we
discuss an action plan, lets discuss what options we have". These conversations often get off-track
if I'm not careful, so I always try to make it clear that I want to _list_ alternatives, rather than
pick the right one. Otherwise, it's too easy to start with the first alternative, and
stream-of-consciousness-style discuss it, _completely missing out on the other alternatives_.
stream-of-consciousness-style discuss it, _completely missing out on the other alternatives_.
Holding conversations in this style require discipline, and buy-in from the participants.

Each time, to emphasize that we're listing alternatives, and not discussing which one is the right
one, I always start the list with "Do Nothing" (the
[Ostrich Algorithm](https://en.wikipedia.org/wiki/Ostrich_algorithm)) as the first option. I've
found that doing so gets the involved parties in the right mindset, because much of the time, doing
nothing isn't appropriate. And in the cases where it _is_ the right choice, it often isn't even
considered as an option.

When we work together to consider what solutions exist in the solution landscape, I often find that
there's something the other party hasn't considered, and as a result of combining the dimensions
they value, the dimensions I value, and the circumstances surrounding the problem, there's often a
"better" solution that's some hybrid approach.

```{dark}
I've found that when I disagree with a colleague about what to do, often the conversation _feels_
like we're arguing about the technical detals about whether or not a solution _actually solves the
problem_. But most often, I find that this disagreement _actually_ stems from not understanding what
the involved parties _value_.

It is _very_ helpful to defuse tense disagreements and ask "what values are you prioritizing? I
think that's maybe where we're not connecting?"
```

This kind of disagreement over what the "right" solution is, is a significant source of frustration.
But it's less friction in the learning (solution-finding) process, and more that it's friction in
the solution-execution process. Both of which are essential skills for engineers as they solve
challenges.
