# Furniture: Spotlight!

Websites would be pretty boring without a way to highlight something really important.

Whether a video highlighting your favorite book, a picture of the sunset, or a value-proposition
with a mind-blowing animated GIF; Spotlights illuminate the best you have to offer!

`@andromeda` `@unimplemented-steps`
## Scenario: Hero Image

Hero' images<sup>[1] [2]</sup> are a mainstay of web design, providing a clear place for people who enter a space to direct their attention.

Hero images are often used to convey the core value proposition of a product or service, highlight a particularly impressive piece of work on a portfolio, capture a viewers imagination, or direct their attention to a key call to action.

Hero Images are automatically resized to maintain their aspect ratio while providing as high a resolution experience to visitors as possible.

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