module TagsHelper

  def path_from_category(category, *query)
    q = query[0] if query
    case category.to_i
      when 1
        categories_path(q)
      when 2
        ingredients_path(q)
      else
        regions_path(q)
    end
  end
end
