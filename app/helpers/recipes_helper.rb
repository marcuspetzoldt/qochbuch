module RecipesHelper

  def ggt(a,b)
    if b == 0
      a
    else
      ggt(b, a.modulo(b))
    end
  end

  def format_amount(amount, factor)

    result = ''

    a = amount.to_i * factor.to_i
    b = @recipe.portion.to_i
    while (t = ggt(a, b)) > 1
      a = a / t
      b = b / t
    end
    q = a / b
    n = a.modulo(b)

    (result = q.to_s) if q > 0
    (result = result + " <sup>#{n}</sup>/<sub>#{b}</sub>") if n > 0

    return result
  end

end
