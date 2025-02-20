--- STEAMODDED HEADER
--- MOD_NAME: Bee-latro
--- MOD_ID: Beelatro
--- MOD_AUTHOR: [InspectorB]
--- MOD_DESCRIPTION: This Mod adds BEES !
--- PREFIX: bee
--- DEPENDENCIES:Cryptid>=0.5.3<=0.5.3c

----------------------------------------------
------------MOD CODE -------------------------
---
function Card:is_bee()
	local check = false

	--self.ability.extra ~= nil and 
	if not is_number(self.ability.extra) and self.ability.extra ~= nil and self.ability.extra.bee then
		check = true
	return check

	end
end

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
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 4, bee = true, bold = 1} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 0, y = 0 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.bee, card and card.ability.extra.bold } }
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

SMODS.Joker {
	key = 'ctrlplusbee',
	loc_txt = {
		name = 'Ctrl + Bee',
		text = {
            "This has {C:mult}+#2#{} Mult for each ",
			"{C:attention}bolded{} word or number your {C:attention}Bee Jokers{} have",
			"{C:inactive}(Currently +#1# Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 4} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 0, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.bee, card and card.ability.extra.bold }	}
	end,
	calculate = function(self, card, context)

		local boldCount = 0
		for i = 1, #G.jokers.cards do
			if
				G.jokers.cards[i]:is_bee()
			then
				boldCount = boldCount + G.jokers.cards[i].ability.extra.bold
			end
		end
		card.ability.extra.mult = card.ability.extra.mult_mod * boldCount

		if context.joker_main then			
			return {
				mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
    end
}

SMODS.Joker {
    key = "beebeedagger",
    pos = { x = 2, y = 0 },
	loc_txt = {
		name = 'Bee-Bee Dagger',
		text = {
            "When {C:attention}Blind{} is selected,",
            "destroy Joker to the right",
        	"to create #1# {C:attention}Jimbee{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
    rarity = 2,
    cost = 8,
	config = { extra = {jimbeeCount = 2, bee = true, bold = 2} },
    atlas = "beeatlas",
    blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.jimbeeCount, card and card.ability.extra.bee, card and card.ability.extra.bold }	}
	end,
    calculate = function(self, card, context)
        local my_pos = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				my_pos = i
				break
			end
		end
		if
			context.setting_blind
			and not (context.blueprint_card or self).getting_sliced
			and my_pos
			and G.jokers.cards[my_pos + 1]
			and not G.jokers.cards[my_pos + 1].ability.eternal
			and not G.jokers.cards[my_pos + 1].getting_sliced
		then
			local sliced_card = G.jokers.cards[my_pos + 1]
			sliced_card.getting_sliced = true
			if sliced_card.config.center.rarity == "cry_exotic" then
				check_for_unlock({ type = "what_have_you_done" })
			end
			G.GAME.joker_buffer = G.GAME.joker_buffer - 1
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.joker_buffer = 0
					card:juice_up(0.8, 0.8)
					sliced_card:start_dissolve({ HEX("f6fa00") }, nil, 1.6)
					play_sound("slice1", 0.96 + math.random() * 0.08)
					return true
				end,
			}))
			for i = 1, card.ability.extra.jimbeeCount do
				local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
				card:add_to_deck()
				G.jokers:emplace(card)
			end
			
			return nil, true
		end
    end,
}

SMODS.Joker {
	key = 'spellingbee',
	loc_txt = {
		name = 'Spelling Bee',
		text = {
            "When round ends, this gains {C:chips}+#2#{} Chips",
			"for each {C:attention}Bee Joker{} you currently have",
			"{C:inactive}(Currently +#1# Chips)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { chips = 0, chip_mod = 5, bee = true, bold = 3} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 0, y = 3 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.chips, card and card.ability.extra.chip_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.blueprint
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		then
			local beeCount = 0
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]:is_bee()
				then
					beeCount = beeCount + 1
				end
			end
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod * beeCount
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{
					message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.chip_mod * beeCount} }),
					colour = G.C.CHIPS,
				}
			)
		end

		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
    end
}

SMODS.Joker {
	key = 'bigbee',
	loc_txt = {
		name = 'Big Bee',
		text = {
            "When round ends, this gains {C:mult}+#2#{} Mult",
			"for each {C:attention}Bee Joker{} you currently have",
			"{C:inactive}(Currently +#1# Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 3} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 0, y = 3 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.blueprint
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		then
			local beeCount = 0
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]:is_bee()
				then
					beeCount = beeCount + 1
				end
			end
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * beeCount
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{
					message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult_mod * beeCount} }),
					colour = G.C.MULT,
				}
			)
		end

		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
    end
}

SMODS.Joker {
	key = 'ballofbees',
	loc_txt = {
		name = 'Ball of Bees',
		text = {
            "When you play a {C:attention}Straight{}, create #1# {C:attention}Jimbee{}",
			"When you play a {C:attention}Flush{}, retrigger your {C:attention}Bee Jokers{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { beecount = 1, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 0, y = 3 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.beecount, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Straight']) and not context.blueprint then
			for i = 1, card.ability.extra.beecount do				
				local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
				card:add_to_deck()
				G.jokers:emplace(card)								
			end

			return {message = 'Created!', colour = G.C.FILTER,}
		end

		if (context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self and G.GAME.last_hand_played == 'Flush') then
			if (context.other_card:is_bee()) then
				return {
					message = localize("k_again_ex"),
					repetitions = 1,
					card = card,
				}
			end
		end
    end
}

SMODS.Joker {
	key = 'hivemind',
	loc_txt = {
		name = 'Hivemind',
		text = {
            "{C:attention}+#1# Joker Slots{} for each",
			"{C:attention}Bee Joker{} you have when this is obtained",
			"{C:inactive}(Granting +#2# Joker Slots)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { slots = 2, bee = true, bold = 5, beeCount = 1, activeSlots = 0} },
	rarity = "cry_epic",
	atlas = 'beeatlas',
	pos = { x = 0, y = 0 },
	cost = 15,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.slots, card and card.ability.extra.activeSlots, card and card.ability.extra.bee, card and card.ability.extra.bold, } }
	end,
	add_to_deck = function(self, card, context)
		for i = 1, #G.jokers.cards do			
			if
				G.jokers.cards[i]:is_bee()
			then
				card.ability.extra.beeCount = card.ability.extra.beeCount + 1
			end
		end
		card.ability.extra.activeSlots = card.ability.extra.slots * card.ability.extra.beeCount
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.activeSlots
    end,
	remove_from_deck = function(self, card, context)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.activeSlots
    end
}

SMODS.Joker {
	key = 'kingbee',
	loc_txt = {
		name = 'King Bee',
		text = {
            "{C:mult}+#2#{} Mult for each {C:attention}Bee Joker{} ",
			"you have whenever you score a {C:attention}King{}",
			"{C:inactive}(Currently +#1# Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 1, bee = true, bold = 4} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 0, y = 3 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and not context.blueprint
		then
			local rank = SMODS.Ranks[context.other_card.base.value].key

			if rank == "King" then
				local beeCount = 0
				for i = 1, #G.jokers.cards do
					if
						G.jokers.cards[i]:is_bee()
					then
						beeCount = beeCount + 1
					end
				end
	
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * beeCount
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{
						message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult_mod * beeCount} }),
						colour = G.C.MULT,
					}
	
				)
			end
		end

		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
    end
}

SMODS.Joker {
	key = 'beesknees',
	loc_txt = {
		name = 'Bee\'s Knees',
		text = {
            "After you play a hand, this gains {X:mult,C:white} X#1# {} Mult",
			"for each {C:attention}Bee Joker{} you currently have",
			"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { extra = 0.1, x_mult = 1 , bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	pos = { x = 0, y = 3 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.extra, card and card.ability.extra.x_mult, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.after
		and not context.before			
		and not context.blueprint
		and not context.repetition
		then
			local beeCount = 0
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]:is_bee()
				then
					beeCount = beeCount + 1
				end
			end
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.extra * beeCount
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } }) }
			)
			return nil, true	
		end

		if context.joker_main then
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } }),
				Xmult_mod = card.ability.extra.x_mult,
			}
		end
    end
}

SMODS.Joker {
	key = 'beehive',
	loc_txt = {
		name = 'Beehive',
		text = {
            "When round ends,",
			"create #1# {C:attention}Jimbee{}"
		}
	},
	config = { extra = { jimbeeCount = 1, bee = true, bold = 1} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 0, y = 0 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.jimbeeCount, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.blueprint
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		then
			for i = 1, card.ability.extra.jimbeeCount do				
				local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
				card:add_to_deck()
				G.jokers:emplace(card)								
			end

			return {message = 'Created!', colour = G.C.FILTER,}
		end
    end
}

----------------------------------------------
------------MOD CODE END----------------------