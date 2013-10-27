module RecipesHelper

  def ggt(a,b)
    if b == 0
      a
    else
      ggt(b, a.modulo(b))
    end
  end

  def format_amount(ingredient, factor)

    result = ''

    a = ingredient[:amount].to_i * factor.to_i
    b = @recipe.portion.to_i
    plural = ((a.to_f/b) > 1)
    while (t = ggt(a, b)) > 1
      a = a / t
      b = b / t
    end
    q = a / b
    n = a.modulo(b)

    (result = q.to_s) if q > 0
    (result = result + " <sup>#{n}</sup>/<sub>#{b}</sub>") if n > 0
    if plural
      result = result + ' ' + ingredient[:punit]
    else
      result = result + ' ' + ingredient[:unit]
    end
    return result
  end

  def format_ingredient(ingredient, factor)
    case ingredient[:rule]
      when 0
        return ingredient[:tag]
      when 1
        return ingredient[:ptag]
      else
        if (ingredient[:amount].to_i * factor.to_i).to_f / @recipe.portion.to_i > 1.0
          return ingredient[:ptag]
        else
          return ingredient[:tag]
        end
    end
  end
end
