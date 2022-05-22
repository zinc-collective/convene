# Feature: Furniture: Livestream

Convene lets you embed your stream right on your Space!

`@andromeda` `@built`

## Scenario: Embedding a Livestream from Twitch

Twitch is an Amazon subsidiary, and one of the most popular live-streaming oriented sites.

- Given a "Zee's Space O' Streaming" Space
- And the Entrance Hall to "Zee's Space O' Streaming" Space's has the following Furniture:
  | furnitureKind | furnitureAttributes |
  | livestream | { "channel": "zeespencer", "provider": "twitch", "layout": "video" } |
- When a Guest visits the "Zee's Space O' Streaming" Space
- Then a "Twitch" Livestream is playing the "zeespencer" channel

`@andromeda` `@built`
## Scenario: Embedding a Livestream from OwnCast

Owncast is libre software for hosting a LiveStream. You'll need to follow the [OwnCast QuickStart](https://owncast.online/quickstart/) prior to setting up a LiveStream in Convene

- Given a "Zee's Space O' Streaming" Space
- And the Entrance Hall to "Zee's Space O' Streaming" Space's has the following Furniture:
  | furnitureKind | furnitureAttributes |
  | livestream | { "channel": "https://watch.owncast.online", "provider": "owncast" } |
- When a Guest visits the "Zee's Space O' Streaming" Space
- Then an "Owncast" Livestream is playing the "https://owncast.example.com" channel
