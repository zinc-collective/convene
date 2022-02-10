# Media Box

Own your own (or your neighborhood's) list of {book|music|other media} recommendations.

For use cases, see [`features/furniture/media_box.feature`](../../../features/furniture/media_box.feature)

We could start by focusing on the book recommendation use case, and think about ways to federate with [BookWyrm](https://github.com/bookwyrm-social) or perhaps cross-post.

One big question to think about is: who provides and/or maintains the Source of Truth data for these recommendations (e.g. a database of all ISBNs and their metadata)? And, relatedly: how much do we care about there being a solid data source backing these recommendations? We could start with something like a controlled database and let people add to it, with some simple encouragement for de-duping when adding a new entry.

For book data specifically, there are some open sources of data that we could start with, such as the Open Library (see: https://openlibrary.org/developers/dumps, https://github.com/LibrariesHacked/openlibrary-search)
