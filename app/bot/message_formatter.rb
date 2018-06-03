module MessageFormatter
  def self.ingriedient_list(recipe)
    elements = []
    recipe.ingredients.split(/\n/)[0...4].each do |line|
      begin
        result = Ingreedy.parse(line.lstrip)
        elements << {title: "#{result.ingredient.humanize} - #{result.amount} #{result.unit}"}
      rescue
        result = line.lstrip
        elements << {title: "#{result}", subtitle: "-"}
      end
    end
    elements
  end

  def self.carousel(recipe)
     { 
        attachment: {payload: {
        template_type: "generic",
        elements: [
          self.ingriedient_list(recipe),
        ],
      }},
    }
  end
end
