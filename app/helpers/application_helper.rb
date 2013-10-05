module ApplicationHelper

  def require_login
    unless signed_in?
      redirect_to(root_path)
    end
  end

  def cloud(category, used_tags, outer)
    # get all tags categorized as category
    # normalize tag count

    used_tags = [] if used_tags.nil?
    if outer
      usable_tags = Tag.where(category: category).order(:tag) - used_tags
    else
      usable_tags = Tag.joins("JOIN taggings ON tags.id = taggings.tag_id").where(category: category).distinct.order(:tag) - used_tags
    end
    used_tags.map! do |t| { id: t.id, tag: t.tag, font_size: t.recipes.count } end
    usable_tags.map! do |t| ({ id: t.id, tag: t.tag, font_size: t.recipes.count }) end
    unless usable_tags.empty?
      max_font_size = ((used_tags + usable_tags).max do |a,b| a[:font_size] <=> b[:font_size] end)[:font_size]
      min_font_size = ((used_tags + usable_tags).min do |a,b| a[:font_size] <=> b[:font_size] end)[:font_size]
      factor = 24.0/(max_font_size - min_font_size + 1)
      used_tags.each do |t| t[:font_size] = (t[:font_size]*factor).to_i + 12 end
      usable_tags.each do |t| t[:font_size] = (t[:font_size]*factor).to_i + 12 end
      return { used: used_tags, usable: usable_tags }
    else
      return { used: [], usable: usable_tags }
    end
  end

end
