module PosHelper
  def stock_badge_class(stock)
    if stock <= 0
      'bg-danger bg-opacity-10 text-danger'
    elsif stock <= 5
      'bg-warning bg-opacity-10 text-danger'
    elsif stock <= 20
      'bg-info bg-opacity-10 text-info'
    else
      'bg-success bg-opacity-10 text-success'
    end
  end

  def stock_status_text(stock)
    if stock <= 0
      'Sold Out'
    elsif stock <= 5
      "Only #{stock} left"
    elsif stock <= 10
      'Low Stock'
    else
      ''
    end
  end

  def price_label(price)
    case price
    when 'under_10k' then 'Under MMK 10k'
    when '10k_30k' then 'MMK 10k-30k'
    when '30k_50k' then 'MMK 30k-50k'
    when 'over_50k' then 'Over MMK 50k'
    else 'All Prices'
    end
  end

  def stock_label(stock)
    stock.to_s.humanize
  end

  def sort_label(sort)
    case sort
    when 'newest' then 'Newest'
    when 'price_asc' then 'Price: Low to High'
    when 'price_desc' then 'Price: High to Low'
    when 'best_selling' then 'Best Selling'
    else 'Sort'
    end
  end
end
