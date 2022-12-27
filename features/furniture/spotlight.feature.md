# Furniture: Spotlight!

Instagram and Signal have Stories, eCommerce sites have "Featured Items", Product Landing Pages have
"Highlighted Value Propositions." Each of these "Spotlight" something on the Web, and bring it to the
front of a Visitors attention.

Spotlight the latest page from your favorite WebComic, an episode of your friend's thrilling DnD Podcast, or
your own latest artistic endeavor!

Spotlights are:

1. Focused! Spotlights can fit up to 3 Targets!
2. Time-Boxed! Targets stick around for a few hours, days or weeks.
3. Multi-format! Spotlight writing, illustrations, comics, short stories, photos, videos, 3d models, VR scenes, and more!


## Fauxsonas

- Spotter - Sets a Spotlight's Targets
- Viewer - Sees a Spotlight's Targets

`@andromeda` `@unimplemented-steps`

## Scenario: Hero Style

Hero images<sup>[1] [2]</sup> are a mainstay of web design, providing a clear place for people to direct their
attention. Spotlights in Hero Style take up a large portion of the Room.

Hero's often convey the core value proposition of a product or service, highlight a particularly impressive
piece of work on a portfolio, capture a viewer's imagination, or direct their attention to a key call to action.

Spotlights in Hero Style preserve the Spotlighted Target (such as aspect ratio) while providing as resonant
Viewer's experience as possible across form factors.

- Given an "Zee's Artist Portfolio" Space
- And a "Spotlight" Furniture in the Entrance Hall to "Zee's Artist Portfolio" Space is configured with:
  | file | adorable_kitten.heic |
  | alt | Two adorable kittens sitting in a fruit bowl |
  | heading | Kittens Are The Best |
  | summary | Everyone loves kittens. They're adorable! Look at them! They make you melt! How can you not love kittens?! |
  | link_text | Scroll your way to happiness |
  | link | //kitten-gallery |

- When a Guest visits the "Zee's Artist Portfolio" Space
- Then a "Spotlight" Furniture is rendered with:
  | file | adorable_kitten.heic |
  | alt | Two adorable kittens sitting in a fruit bowl |
  | heading | Kittens Are The Best |
  | summary | Everyone loves kittens. They're adorable! Look at them! They make you melt! How can you not love kittens?! |
  | link_text | Scroll your way to happiness |
  | link | //kitten-gallery |

[1]: https://design4users.com/hero-images-in-web-design/
[2]: https://elementor.com/blog/hero-image/

`@andromeda` `@unstarted`

## Scenario: Hero Video

While Hero _Images_ are quite common, many sites embed video to really showcase what's up.

- Given an "Zee's Artist Portfolio" Space
- And a "Spotlight" Furniture in the Entrance Hall to "Zee's Artist Portfolio" Space is configured with:
  | file | adorable_kitten.mp4 |
  | alt | Two adorable kittens playing in a fruit bowl |
  | heading | Kittens Are The Best |
  | summary | Everyone loves kittens. They're adorable! Look at them! They make you melt! How can you not love kittens?! |
  | link_text | Scroll your way to happiness |
  | link | //kitten-gallery |
- When a Guest visits the "Zee's Artist Portfolio" Space
- Then a "Spotlight" Furniture is rendered with:
  | file | adorable_kitten.heic |
  | alt | Two adorable kittens sitting in a fruit bowl |
  | heading | Kittens Are The Best |
  | summary | Everyone loves kittens. They're adorable! Look at them! They make you melt! How can you not love kittens?! |
  | link_text | Scroll your way to happiness |
  | link | //kitten-gallery |
