ModRecipe = Class(function(self, inst)
	self.inst = inst
end)

function ModRecipe:ChangeRecipe(name, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image)
	
	name = string.lower(name)
	
	if not AllRecipes[name] then
		return AddRecipe(name, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image)
	end
	
	AllRecipes[name].ingredients = ingredients or AllRecipes[name].ingredients
	
	AllRecipes[name].tab = tab or AllRecipes[name].tab
	
	AllRecipes[name].atlas = atlas or AllRecipes[name].atlas
	AllRecipes[name].image = image or AllRecipes[name].image
	
	AllRecipes[name].level = level or AllRecipes[name].level
	AllRecipes[name].placer = placer or AllRecipes[name].placer
	AllRecipes[name].min_spacing = min_spacing or AllRecipes[name].min_spacing
	
	AllRecipes[name].nounlock = nounlock or AllRecipes[name].nounlock
	AllRecipes[name].numtogive = numtogive or AllRecipes[name].numtogive
	
	AllRecipes[name].builder_tag = builder_tag or AllRecipes[name].builder_tag
	
end

return ModRecipe
