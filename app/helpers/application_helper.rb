module ApplicationHelper

  def require_login
    redirect_to(root_path) unless signed_in?
  end

  def require_admin
    redirect_to(root_path) unless is_admin?
  end

  def sort_direction(column, sort_by, sort_direction)
    return 1 unless column.to_s == sort_by.to_s
    sort_direction > 0 ? -1 : 1
  end

  def sort_by_column(columns)
    columns.each do |name, order|
      unless order.nil?
        if order.to_i > 0
          return [name, 1]
        else
          return [name, -1]
        end
      end
    end
    return [columns.keys[0], 1]
  end

  def cloud(category, used_tags, outer)
    # get all tags categorized as category
    # normalize tag count

    used_tags = [] if used_tags.nil?
    if outer
      usable_tags = Tag.where(category: category).order(:tag) - used_tags
    else
      # Show only tags which are used by recipes in the result set.
      if Recipe.matching_recipes.empty?
        usable_tags = []
      else
        usable_tags = Tag.joins("JOIN taggings ON tags.id = taggings.tag_id JOIN recipes ON recipes.id = taggings.recipe_id AND recipes.id IN (#{Recipe.matching_recipes.join(',')})").where(category: category).distinct.order(:tag) - used_tags
      end
    end
    used_tags.map! do |t| { id: t.id, tag: t.tag, font_size: t.recipes.count } end
    usable_tags.map! do |t| ({ id: t.id, tag: t.tag, font_size: t.recipes.count }) end
    unless used_tags.empty? && usable_tags.empty?
      max_font_size = ((used_tags + usable_tags).max do |a,b| a[:font_size] <=> b[:font_size] end)[:font_size]
      min_font_size = ((used_tags + usable_tags).min do |a,b| a[:font_size] <=> b[:font_size] end)[:font_size]
      factor = 24.0/(max_font_size - min_font_size + 1)
    end
    used_tags.each do |t| t[:font_size] = (t[:font_size]*factor).to_i + 12 end
    usable_tags.each do |t| t[:font_size] = (t[:font_size]*factor).to_i + 12 end
    return { used: used_tags, usable: usable_tags }
  end

end
