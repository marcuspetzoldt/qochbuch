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

  def moniker_from_category(category, count = 1)
    case category.to_i
    when 1
      t('activerecord.attributes.tag.tag', count: count)
    when 2
      t('activerecord.attributes.tag.ingredient', count: count)
    else
      t('activerecord.attributes.tag.region', count: count)
    end
  end
end
