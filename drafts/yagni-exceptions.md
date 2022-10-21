---
title: Exceptions to the YAGNI rule of thumb
description: Occasions when you actually DO need it
date: DRAFT

---

# Exceptions to the YAGNI rule of thumb

Luke Plant wrote a [blog post](https://lukeplant.me.uk/blog/posts/yagni-exceptions/) on exceptions
to the [You Ain't Gonna Need It](https://martinfowler.com/bliki/Yagni.html) rule of thumb. Simon
Willison followed up with a [blog post](https://simonwillison.net/2021/Jul/1/pagnis/) on PAGNI's
(things you Probably Are Going to Need It).

## You Ain't Gonna Need It

YAGNI is a philosophy that says "don't build presumptive features until they're needed".

Now, the first thing I think of, is what happens when YAGNI is taken too far. But Martin Fowler
actually has a pretty sane take:

> Yagni only applies to capabilities built into the software to support a presumptive feature, it
> does not apply to effort to make the software easier to modify.
>
> ... Yagni is not a justification for neglecting the health of your code base. Yagni requires (and
> enables) malleable code.

## Exceptions to the rule

So when do you break the rule? Luke Plant has the following list

* Applications of Zero One Many -- when you need to go from one of a thing to multiple of a thing.
* Versioning protocols, APIs, formats, etc.
* Logging - log more than you think you'd need
* Timestamps for important events
* Using a relational database

This is a pretty good list, but in conversations at work, we identified a few others that we thought
were good fits

* Feature flags
* Building out the CI/CD pipelines
* Design for testability

Simon Willison hits on CI/CD pipelines with his list of PAGNI's

* Out-of-data versioning kill switch for your apps -- being able to deprecate support for old
  versions.
* Automated deployments
* Continuous integration
* API pagination
* Detailed API logs
