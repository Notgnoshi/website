---
title: Valuable lessons learned as a new engineer
date: DRAFT
description: Lessons learned as a new, full-time engineer.

---

# Valuable lessons learned as a new engineer

## Jira and Confluence

* Take the time to learn how to use Jira (and how your organization expects Jira to be used!).
* Learn how to create tickets, and what kind of information makes tickets useful!
  * Ticket type - epic, bug, task, story
  * If it's a bug, include relevant software version numbers, environment details, screenshots, log snippets, etc
  * Provide enough of a description that the ticket is valuable to more than just yourself
* Update your tickets when work gets done.

  It's helpful for yourself, your manager, and your team, if they can easily tell where you are at.
  This is especially important for tasks that block others.
  Standups can help, but stuff can get forgotten, and as I work on a team that's spread over
  multiple timezones, often not everyone joins.
* Organize related tickets into epics.

  This provides a convenient mechanism for grouping related tickets together, but also helps you
  find that one ticket you're looking for!
  * For example, I've been keeping a "Developer Experience" epic for pipeline improvements, build
    issues, logging improvements, documentation, deployment tooling, etc.
* **Don't mark a ticket as "done" until it's actually done!**

  That means:
  * It's been merged
  * It's been released
  * It's been tested

## Keep a brag document

[https://jvns.ca/blog/brag-documents/](https://jvns.ca/blog/brag-documents/)

I've instead done something slightly different. I've been keeping a quarterly retrospective where I
outline what goals I had, how they went, and anything interesting that I got done outside of my
planned work (my fun-day-fridays/fuck-it-fridays/20% time).

## The value stream matters

Know that there _is_ a value stream, and understand roughly what it is.

## You can put email filters to good use

Here's a taste of the different filters I have:
* Code review activity

  For a while, I also had a separate filter for code review assignments (for when someone assigned
  me a code review) but recently I've clumped that back in, and try to treat _all_ code review
  activity as relatively important.
* Username mentions (both code reviews and Confluence/Jira)
* Failed pipelines (I don't need that kind of negativity in my inbox, but it _is_ useful to know
  sometimes)
* Edits or updates to Confluence pages I'm watching

## Code reviews

Your team should have a conversation on the purpose of code reviews, and what value they bring.
There are a lot of different ways to have code reviews, and they're pretty painful when someone
tries enforcing their own personal standards on a team who hasn't agreed to them.

* Prefix commits with "nitpick:", "offtopic:", "question:", "opinion:", and "out-of-scope:" to help
  facilitate a more effective (and less frustrating) code review process. This helps identify
  comments that the reviewee _needs_ to address, and those that they really don't.

  See [Conventional Comments](https://conventionalcomments.org/)

* **Always** review your own diffs first (every single line)
* Review branches commit-by-commit!
* The work isn't done when you submit a code review
  * It has to get merged
  * It might need to be cherry-picked into maintenance branches
  * It might need to go through testing
  * There might be downstream build processes that need to run
  * You may need to work with tech writing to develop user manuals, training material, etc.
* Link to related tickets and design documentation in the code review description, in addition to
  any other related code reviews.
* Find the right level to review someone else's code review. I've had reviews with over 100 comments
  on _stuff that just didn't matter_ (like whether comments can include markdown markup). This is
  _infuriating_. These kinds of comments are draining, but they also diminish the quality of the
  review, by detracting from the comments that actually _do_ provide value.

  Please, code reviews are _not_ the place to enforce your own personal standards.
  Each team should have standards that they value, and their reviews should reflect this.

## The right way vs. the quick way

I'm not sure I've figured this one out.
But I _can_ say that your own opinion shouldn't be the only input to this determination.

There will always be tradeoffs you make.
Identify them, and work with your peers to identify the _right_ tradeoffs to make.

The perfect _really is_ the enemy of the good.

And if you're always crying wolf, eventually you'll blend into the background. Pick the right areas
to make noise about.

## Tunnel vision is real

I tend to lose sight of the bigger picture, and narrow in on stuff.
Sometimes, I do this to the point where, if I were able to zoom out and re-evaluate, I might find
that whatever incredibly difficult technical roadblock I'm fighting doesn't matter in the grander
scheme of things, and I should re-evaluate, and re-focus on what actually moves me closer to my
goals.

## Rapid feedback is _great_
One of my worst mistakes at work was to work _by myself_ on the same project for _months_ before
trying to integrate my project. There were several layers of mistakes made by several people, but
the result was an absolute _mess_ because I didn't think about a few critical things:
* backwards compatibility
* how are we going to release this new feature?

It was complex enough (and touched enough core things) that adding a feature flag after the fact,
while the _right_ thing to do, would have been inordinately difficult, because of assumptions that I
(and others, but mostly me) made.

It would have been better to add a feature flag as the first thing I did, and merge and test
rapidly, instead of waiting for _months_.

## Five whys

I don't normally keep track of how many times I ask "why?", but the common advice is to ask "why?"
five times, and by the fifth time, you know that you _really do_ understand the problem at hand, and
are getting at its root cause.

## Frustration, grit, and digging in

I think how you respond to frustration is a really great indicator of what kind of engineer you are.
Don't be afraid to dig in, and really get after what's going on.

It's pretty frustrating to me, when peers run into a problem and immediately move on to something
else without "digging in".

Programming is unique in the sense that a software engineer spends an inordinate amount of time
being frustrated.
Those are the times I relish, and the times I think I shine.
But some of my peers don't respond in the same way to frustration -- sometimes frustration will
negatively impact their emotions, or they'll spin their wheels, or even just sit there without
trying to make progress at all! And these are the peers who don't give up!

I think frustration is (or maybe should be?) the norm -- I'm tempted to say that if you're not
constantly frustrated, you're perhaps not being challenged in the right ways.

Of course, there's probably such thing as "bad" frustration and "good" frustration, but I'm not yet
sure how I'd draw the line between them.

## Never stop learning
I keep hearing peers complain how topic `$FANCY_THING` isn't taught in school. But you shouldn't be
relying on school to teach you particulars.

Yeah, it might be nice to learn in some kind of structured environment. But at the end of the day,
it's _your_ responsibility to learn (and you _do_ have that responsibility!)

## Technical stuff
### Git
* How to interrogate repositories to help answer questions
* What are effective commits? When do you break something into multiple commits?
* How to refine my local commit history into something more effective

### Docker
Docker is a quite useful skill to build. Especially in a team with complex environments. I mostly
use it to build CI/CD pipelines for projects, because I work on embedded Linux systems, where
Docker doesn't make sense for deployments.

### Toolchains
If you're a systems developer, you should take some time to understand what a toolchain is. This is even
more important for embedded Linux developers targetting specialized hardware.

This can be
* How to cross-compile for specialized hardware
* How to remote debug with `gdbserver`
* What _really_ happens when you press the big, green "Build" button

### Making effective use of a Linux development environment
* Related to above, learn how to build whatever project from the terminal. There's more going on
  than the magic "Build" button in your IDE, and when stuff goes wrong (and it will), you should
  equip yourself with the ability to fix it.
* Reverse-history search is awesome even without FZF, which takes it to a whole other level.

  I like to set (on modern Bash shells) `HISTSIZE` and `HISTFILESIZE` to `-1`, to keep _everything_.
  My shell history is like my second brain. I _constantly_ refer back to it.
* Grepping (and ripgrepping) is a super power
* Vim is awesome, but you don't need to become one of _those people_. But it's helpful enough as a
  Git `EDITOR` that I think you should learn the basics ;)
