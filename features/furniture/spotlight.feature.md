# Furniture: Spotlight!

Websites would be pretty boring without a way to highlight something really important.

Whether a video highlighting your favorite book, a picture of the sunset, or a value-proposition
with a mind-blowing animated GIF; Spotlights illuminate the best you have to offer!

`@andromeda`

## Scenario: Hero Image

Hero' images<sup>[1] [2]</sup> are a mainstay of web design, providing a clear place for people who enter a space to direct their attention.

Hero images are often used to convey the core value proposition of a product or service, highlight a particularly impressive piece of work on a portfolio, capture a viewers imagination, or direct their attention to a key call to action.

Hero Images are automatically resized to maintain their aspect ratio while providing as high a resolution experience to visitors as possible.

- Given an "Zee's Artist Portfolio" Space
- And a "Spotlight" Furniture in the Entrance Hall to "Zee's Artist Portfolio" Space is configured with:
  | file | adorable_kitten_12mp_16x9.heic |
  | heading | Kittens Are The Best |
  | summary | Everyone loves kittens. They're adorable! Look at them! They make you melt! How can you not love kittens?! |
  | link_text | Scroll your way to happiness |
  | link | //kitten-gallery |

- Then a 1 megapixel 16x9 Spotlight of "adorable_kittens" is shown to Portrait Phone visits to "Zee's Artist Portfolio" Space
- And a 4 megapixel 16x9 Spotlight of "adorable_kittens" is shown to Landscape Phone visits to "Zee's Artist Portfolio" Space
- And a 2 megapixel 16x9 Spotlight of "adorable_kittens" is shown to Portrait Tablet visits to "Zee's Artist Portfolio" Space
- And a 6 megapixel 16x9 Spotlight of "adorable_kittens" is shown to Landscape Tablet visits to "Zee's Artist Portfolio" Space

[1]: https://design4users.com/hero-images-in-web-design/
[2]: https://elementor.com/blog/hero-image/

`@andromeda` `@unstarted`

## Scenario: Hero Video

While Hero _Images_ are quite common, many sites embed video to really showcase what's up.

- Given an "Zee's Artist Portfolio" Space
- And a "Spotlight" Furniture in the Entrance Hall to "Zee's Artist Portfolio" Space is configured with:
  | file | adorable_kitten_12mp_16x9.mp4 |
  | heading | Kittens Are The Best |
  | summary | Everyone loves kittens. They're adorable! Look at them! They make you melt! How can you not love kittens?! |
  | link_text | Scroll your way to happiness |
  | link | //kitten-gallery |

- Then Portrait Phone Guests see a 1.2 megapixel 16x9 Spotlight of "adorable_kittens" on "Zee's Artist Portfolio"
- And Landscape Phone Guests see a 4 megapixel 16x9 Spotlight of "adorable_kittens" on "Zee's Artist Portfolio"
- And Portrait Tablet Guests see a 2 megapixel 16x9 Spotlight of "adorable_kittens" on "Zee's Artist Portfolio"
- And Landscape Tablet Guests see a 6 megapixel 16x9 Spotlight of "adorable_kittens" on "Zee's Artist Portfolio"
to