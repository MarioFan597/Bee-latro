--- STEAMODDED HEADER
--- MOD_NAME: Bee-latro
--- MOD_ID: Beelatro
--- MOD_AUTHOR: [InspectorB]
--- MOD_DESCRIPTION: This Mod adds BEES !

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
	key = "beeatlas",
	path = "beeatlas.png",
	px = 71,
	py = 95
}

SMODS.Joker {
	key = 'jimbee',
	loc_txt = {
		name = 'Jimbee',
		text = {
            "{C:mult}+#1#{} Mult",
			"\n",
			"{C:inactive}this counts as a bee joker"
		}
	},
	config = { extra = { mult = 4, bee = true} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 0, y = 0 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
    end
}




----------------------------------------------
------------MOD CODE END----------------------