# frozen_string_literal: true

module Buttons
  class SecondaryComponent < ButtonComponent
    def initialize(
      classes: "rounded-md bg-white px-3.5 py-2.5 text-sm font-semibold text-indigo-950 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-purple-100 hover:text-purple-700 no-underline",
      **kwargs
    )
      super(classes: classes, **kwargs)
    end
  end
end
