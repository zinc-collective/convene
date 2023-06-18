# Convene::Features::ParameterTypes

We use [Cucumber Parameter Types] to help keep our phrasing consistent when
describing the different adjectives and nouns within our domain model, as well
as to provide [affordances] for adding behavior specific to those nouns.

Parameter Types are automatically detected from a feature files Steps, and can
be transformed into JavaScript objects before being passed into step
definitions. This gives us a [seam] for customizing behavior within a step based
upon a feature definition without changing the step implementation.

For more information, see the [Cucumber parameter types] documentation, as well
as the [cucumber-js parameter types API reference].

[affordances]: https://www.interaction-design.org/literature/topics/affordances
[seam]: https://wiki.c2.com/?SoftwareSeam
[cucumber parameter types]: https://cucumber.io/docs/cucumber/cucumber-expressions/#custom-parameter-types
[cucumber-js parameter types api reference]: https://github.com/cucumber/cucumber-js/blob/master/docs/support_files/api_reference.md#defineparametertypename-preferforregexpmatch-regexp-transformer-useforsnippets

## Core Parameter Types

The core nouns in Convene are:

1. [Actors], the person or program performing a Step.
2. [Rooms], where people congregate to work together.
3. [Spaces], which group Rooms and People for access and discoverability
   purposes.
4. [Furniture] for human/computer interaction within a space.

Note: `Room/Rooms` has been renamed to `Section/Sections`.

Note: `Furniture` has been renamed to `Gizmo/Gizmos`.

[actors]: ./actors.js
[rooms]: ./rooms.js
[spaces]: ./spaces.js
[furniture]: ./furniture.js
