# Makes Rails auto-lookup of views and i18n a little bit nicer when working in small namespaces.
module StripsNamespaceFromModelName
  def model_name
    @model_name ||= ActiveModel::Name.new(self, name.deconstantize.constantize)
  end
end
