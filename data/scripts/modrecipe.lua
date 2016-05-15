ModRecipe = Class(function(self, name, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image)
	self.name = name
	
	self.ingredients = {}
	self.character_ingredients = {}
	
	for k,v in pairs(ingredients) do
		if table.contains(CHARACTER_INGREDIENT, v.type) then
			table.insert(self.character_ingredients, v)
		else
			table.insert(self.ingredients, v)
		end
	end
	
	self.product = name
	self.tab = tab or AllRecipes[name].tab
	
	self.atlas = (atlas and resolvefilepath(atlas)) or resolvefilepath("images/inventoryimages.xml") or AllRecipes[name].atlas
	self.image = image or (name .. ".tex") or AllRecipes[name].image
	
	self.sortkey = num or AllRecipes[name].sortkey
	self.rpc_id = num or AllRecipes[name].rpc_id
	self.level = level or AllRecipes[name].level or 0
	self.level.ANCIENT = self.level.ANCIENT or AllRecipes[name].self.level.ANCIENT or 0
	self.level.MAGIC = self.level.MAGIC or AllRecipes[name].self.level.MAGIC or 0
	self.level.SCIENCE = self.level.SCIENCE or AllRecipes[name].self.level.SCIENCE or 0
	self.level.SHADOW = self.level.SHADOW or AllRecipes[name].self.level.SHADOW or 0
	self.placer = placer or AllRecipes[name].placer
	self.min_spacing = min_spacing or AllRecipes[name].min_spacing or 3.2
	
	self.nounlock = nounlock or AllRecipes[name].nounlock or false
	
	self.numtogive = numtogive or AllRecipes[name].numtogive or 1
	
	self.builder_tag = builder_tag or nil
	
	num = num + 1
	AllRecipes[name] = self
end)

function ModRecipe:ChangeRecipe(...)
	if not AllRecipes[name] then
		return AddRecipe(...)
	end
	arg = {...}
	print("ChangeRecipe", arg[1])
	mod_protect_Recipe = false
	local rec = Recipe(...)
	mod_protect_Recipe = true
	rec:SetModRPCID()
	return rec
end

return ModRecipe
