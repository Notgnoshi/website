---
title: Frustration, grit, and digging in
description: Musings on problem solving, and dealing with frustration
date: DRAFT

---

# Frustration, grit, and digging in

## Background

There were several occasions in university where I had the opportunity to tutor students from other
majors, sometimes in a professional capacity provided by the school, and other times as a friend.
During this time, I met a wide range of students from different backgrounds and different
capabilities.

It took me a while to recognize, but looking back, I think this experience taught me a very valuable
lesson.

## Frustration is essential to learning

Every last student I tutored found the material frustrating. They were expected to display
familiarity of the subject matter, but naturally as students, the material was initially unfamiliar.
And _of course it was_. Because that's inherent to the learning process!!

```{dark}
**Frustration**. _noun_., the prevention of the progress, success, or fulfillment of something

**Friction**. _noun_., the resistive force that inhibits relative motion between two bodies in
contact
```

Friction is a resistive force that slows or impedes motion. But that doesn't make friction a _bad_
force. Clearly, _friction_ is necessary for
[simple machines](https://en.wikipedia.org/wiki/Simple_machine) to function. Life would be very
_very_ different if every surface you interacted with was frictionless.

_Frustration_ on the other hand, is a resistive force that has a negative connotation. That is,
feeling like you're being held back from fulfillment, _especially_ if you feel that it's either
yourself (you're not smart enough) or someone else (a professor that isn't good at teaching) that's
holding you back, is, well, _frustrating_.

This is particularly true when there's social pressures for you to demonstrate competence (students
are expected to learn, to do homework, to pass exams, and to not look clueless to their peers).

```{dark}
Finding the unfamiliar frustrating is a universal experience of being Human
```

My claim is that frustration is as necessary to the learning process as friction is for simple
machines to function. That is, when applied to learning, the two words are synonyms. The learning
process is, generally speaking, transforming the unfamiliar into the familiar. There's always
resistance to this transformation; that comes from the unfamiliar being... _unfamiliar_.

Said differently, the learning process requires conquering frustration. This is partly what makes
learning so rewarding; you get to experience that moment where the friction is overcome, where
behind held back yields to making progress, where the unfamiliar becomes familiar, and where
frustration gives way to mastery.

## Dealing with frustration requires grit

In my experience as a tutor, looking at myself as a problem-solver, and in observing colleagues at
work, I observe many different reactions to frustration.

* self-doubt
* anger, sometimes directed at oneself, and other times directed at others
* patience, grit, and determination
* excitement

I claim that the most successful students were the ones who accepted frustration, and learned to
meet it with it with grit and determination.

My favorite students to tutor were the ones who met uncertainty with excitement. _They still felt
the self-doubt_, and the challenge stemming from the unfamiliar. Learning the material didn't come
easy to these students, but rather, they were able to manage the discouragement long enough to
navigate to the solution.

```{dark}
**Grit**. _noun_., courage and resolve

**Determination**. _noun_., firmness of purpose; resoluteness
```

This is _challenging_. It's a natural reaction to meet constant frustration with self-doubt, or even
anger. But because frustration is an essential aspect of learning, those who weathered out their
frustration were the ones who learned the most.

## Confidence

This is perhaps the most valuable lesson I took away from my university experience; frustration is a
normal and necessary aspect of learning. The feelings of self-doubt, discouragement, and frustration
are normal, **and I'm not lesser for feeling them**.

```{dark}
I do, however, feel that anger, while a natural response, is not appropriate, and holds back the
problem-solver from the solution. Anger at yourself is short sighted and unproductive, and anger at
others doesn't recognize the learner's own responsibility in learning.
```

This realization leads me (only now after lots of reflection, and only seemingly when it comes to
technical challenges) to meet challenges surrounded with uncertainty with confidence.

## Learning vs memorization

During my time as a tutor, I also came across students with surprising expectations. There were no
small number of students who expected that every exam problem first had to be a homework problem,
and for every homework problem to first have been an in-class example, albeit with possibly
different numbers.

I felt this was a bizarre expectation; that they could only be expected to succeed on a problem if
they had seen it before. To this day, I still look back on those experiences with shock. Memorizing
a catalog of homework problems isn't _learning_. And it's incorrect to put an expectation on others
to help you navigate and uncertain challenge (even if it _is_ helpful to have this help).

## Digging in

Another metaphor often used to discuss the learning process, is that of digging; when faced with a
question you don't know the answer to, sometimes you can google it and find a ready-made answer.
There's a large number of questions out there where this is possible. But there's also question's
that you don't know _how_ to search for the answer in a search engine.

It's these questions where you need to **dig in** order to find answers. You have to sift through
large amounts of potentially unrelated material, building up a mental model piece-by-piece.

You also have to re-evaluate your mental model with each nugget of new information. I've recently
faced some problems where I had an incorrect understanding that led me to an incorrect conclusion.
To help combat this, I've found it useful to take detailed notes listing:

* observations, stated as "here's what I see", with any exposition left off
* facts, these are things I _know_, and can be verified, both via external resources and
  experimentation
* beliefs, these are things I _think I know_, but there's uncertainty
* experiments, these are _actions_ I have performed, that led me to make _observations_ that lead me
  to _beliefs_.

I find it _very_ helpful to separate facts from beliefs, because it allows me to focus on beliefs
until I either find that they are facts, or that I don't have the right understanding. The astute
reader can recognize this as the
[Scientific Method](https://en.wikipedia.org/wiki/Scientific_method).

The utility of these notes, is that humans sometimes have difficulty separating belief from fact.
It's pretty frustrating when it's not yourself that displays this difficulty. It's unsatisfying when
you hear someone failing to make a distinction between fact and belief. So, I find that
acknowledging the difference helps me approach problem-solving with a more open mind. Often, the
process of asking myself "Is this something I believe, or something I _know_?" leads me to the
solution.

When faced with uncertainty, unfamiliar topics, and when you're not sure where to start, this is
when "digging in" proves to be valuable. It's _okay_ to not know the answer, but dammit I'm going to
find it.

## Pragmatism

Professional answer-seekers can tell you that the problem solving process can be addictive. But not
every problem needs to be well-understood. Sometimes it's too expensive to find the answer. Other
times, finding the answer doesn't provide value other than scratching an intellectual itch.

For example, at work, we had a case where our test suite would crash, but only with a particular
combination of:

* building with code coverage instrumentation
* with a particular compiler version
* with release builds
* and only when a module was moved from one file to another

We could "solve" this problem by doing any one of:

* don't measure code coverage
* don't build the tests with optimizations
* upgrade the compiler version
* don't move the module from one file to another

While each of these is dissatisfying (none of them display mastery or understanding of the root
cause), upgrading our compiler version was what we initially chose because

* it was easy enough to do
* we wanted to upgrade the compiler anyways
* it enabled us to move on and solve more valuable challenges

We did eventually find the root cause; there was a bug that the compiler was able to tell invoked
Undefined Behavior that, when optimized, was compiled down to the
[x86 ud2](https://mudongliang.github.io/x86/html/file_module_x86_id_318.html) instruction. We found
the bug as we were ripping out the module.

## How do you measure "value"?

There are several dimensions you can measure the "value" of a solution with:

* business value - does solving it make the business money?
* technical debt - there's an age-old tradeoff between making a product valuable right now vs making
  it valuable in the future.
* intellectual curiosity - does solving it satisfy your curiosity?
* LinkedIn Driven Development (LDD) - does the solution use new and popular enough frameworks that
  you can post them on your LinkedIn profile?
* intellectual prowess - does the solution sufficiently demonstrate how smart you are?
* long-term maintainability - how does the solution age five years later with a new team with new
  priorities?
* buzzword density - does the solution involve enough buzzwords that the political members of your
  organization believe that it's an appropriate solution?
* social circumstances - how well suited is the team surrounding the problem to understand and
  master the solution?
* generality - how general is the solution? Does it handle edge cases, or just the happy path? How
  easy is it to handle edge cases in the future?

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

```{dark}
I personally tend to value solution-execution over solution-finding, and pragmatism over finding the
"best" most "right" and "optimal" solution.
```

It's _very_ helpful to understand your own biases, as well as what values your engineering
leadership prefer. Please, remember to approach navigating the solution landscape with an open mind.

## The solution landscape

I can't tell you how many times someone has tried to explain a problem to me, while assuming they
already know what the solution is. Often, this very useful; they've already spent some time
considering the problem, the solution landscape, and what the right tradeoffs are for their
circumstance. However, I've also experienced a lot of tunnel vision that these assumptions cause.

These conversations can often be difficult, because the description of the problem is hidden behind
a description of the believed solution. This can get in the way of understanding! Additionally, the
assumed solutions sometimes pick just a single axis to optimize for, and often miss out on picking
the right tradeoff for whatever circumstances the team(s) find themselves in.

As a result, I make it an effort to interrupt anyone assuming the solution, and tell them "before we
discuss an action plan, lets discuss what options we have". These conversations often get off-track
if I'm not careful, so I always try to make it clear that I want to _list_ alternatives, rather than
pick the right one. Otherwise, it's too easy to start with the first alternative, and
stream-of-conciousness-style discuss it, _completely missing out on the other alternatives_. Holding
conversations in this style require discipline, and buy-in from the participants.

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

## Conclusion

I believe that frustration is inherent to the problem solving process, and that the ability to
manage the negative emotions that come along with frustration is an _essential_ skill for any
problem-solver. This ability is just as important to technical problem solving as is mastery of the
technical topics at hand.
