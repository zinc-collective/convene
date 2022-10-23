# frozen_string_literal: true

# @see https://github.com/kzkn/gretel
crumb :journal_entry do |entry|
  parent :room, entry.room
  link entry.headline, [entry.space, entry.room, entry]
end

crumb :new_journal_entry do |entry|
  parent :room, entry.room
  link 'Add a Journal Entry', [:new, entry.space, entry.room]
end

crumb :edit_journal_entry do |entry|
  parent :journal_entry, entry
  link "Edit", [:edit, entry.space, entry.room, entry]
end
