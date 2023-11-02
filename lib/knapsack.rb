def dynamic_programming_knapsack(items, max_weight)
  num_items = items.size
  cost_matrix = Array.new(num_items) { Array.new(max_weight + 1, 0) }

  items.each_with_index do |item, i|
    (max_weight + 1).times do |j|
      cost_matrix[i][j] = if item.weight > j
        cost_matrix[i - 1][j]
      else
        [cost_matrix[i - 1][j], (item.volume / 1e6) + cost_matrix[i - 1][j - item.weight]].max
      end
    end
  end
  # used_items = get_used_items(items, cost_matrix)
  # [get_list_of_used_items_names(items, used_items), # used items names
  #   items.zip(used_items).map { |item, used| item.weight * used }.inject(:+), # total weight
  #   cost_matrix.last.last] # total value
  get_used_items(items, cost_matrix)
end

def get_used_items(items, cost_matrix)
  i = cost_matrix.size - 1
  currentCost = cost_matrix[0].size - 1
  marked = cost_matrix.map { 0 }

  while i >= 0 && currentCost >= 0
    if (i == 0 && cost_matrix[i][currentCost] > 0) || (cost_matrix[i][currentCost] != cost_matrix[i - 1][currentCost])
      marked[i] = 1
      currentCost -= items[i].weight
    end
    i -= 1
  end
  marked
end

def get_list_of_used_items_names(items, used_items)
  items.zip(used_items).map { |item, used| item.name if used > 0 }.compact.join(", ")
end
