# frozen_string_literal: true

# @see https://github.com/kzkn/gretel

crumb :journal_entry do |entry|
  parent :room, entry.room
  link entry.headline, entry.location
end

crumb :new_journal_entry do |entry|
  parent :room, entry.room
  link "Add a Journal Entry", journal.entries.new.location
end

crumb :edit_journal_entry do |entry|
  parent :journal_entry, entry
  link "Edit", entry.location(:edit)
end
