--- STEAMODDED HEADER
--- MOD_NAME: Bee-latro
--- MOD_ID: Beelatro
--- MOD_AUTHOR: [InspectorB]
--- MOD_DESCRIPTION: This Mod adds BEES!
--- PREFIX: bee
--- DEPENDENCIES:Cryptid>=0.5.3<=0.5.3c

----------------------------------------------
------------MOD CODE -------------------------
---
---
---



function Card:is_bee()
	local check = false

	--self.ability.extra ~= nil and 
	if not is_number(self.ability.extra) and self.ability.extra ~= nil and self.ability.extra.bee then
		check = true
	return check

	end
end

function Get_random_bee_card()
    -- Define standard cards (each appears once per cycle)
    local bee_cards = {
        "j_bee_jimbee", "j_bee_ctrlplusbee", "j_bee_beebeedagger", "j_bee_spellingbee",
        "j_bee_ballofbees", "j_bee_kingbee", "j_bee_beehive", "j_bee_jollybee",
        "j_bee_bigbee", "j_bee_larva", "j_bee_honeycomb", "j_bee_weebee",
        "j_bee_honeypot", "j_bee_nostalgic_jimbee"
    }

    -- Define rare cards with their individual frequency (1 in X cycles)
    local rare_cards = {
        {name = "j_bee_beesknees", chance = 3},
        {name = "j_bee_queenbee", chance = 3},
        {name = "j_bee_hivemind", chance = 5},
        {name = "j_bee_benson", chance = 100}
    }

    -- Check if the player has a Showman Joker
    local has_showman = next(find_joker("Showman")) ~= nil

    -- Function to check if a card is already in the player's hand
    local function is_in_hand(card_name)
        for _, card in ipairs(G.jokers.cards) do
            if card and card.key == card_name then
                return true
            end
        end
        return false
    end

    -- Generate a fresh pool of Bee Jokers every time the function is called
    local available_bee_cards = {}

    -- Add standard cards if they haven't been used or held (unless Showman exists)
    for _, card in ipairs(bee_cards) do
        if has_showman or (not G.GAME.used_jokers[card] and not is_in_hand(card)) then
            table.insert(available_bee_cards, card)
        end
    end

    -- Add rare cards with their probability
    for _, rare in ipairs(rare_cards) do
        if math.random(rare.chance) == 1 then
            if has_showman or (not G.GAME.used_jokers[rare.name] and not is_in_hand(rare.name)) then
                table.insert(available_bee_cards, rare.name)
            end
        end
    end

    -- Ensure there is at least one card in the pool
    if #available_bee_cards == 0 then
        for _, card in ipairs(bee_cards) do
            table.insert(available_bee_cards, card)
        end
    end

    -- Shuffle the available cards
    for i = #available_bee_cards, 2, -1 do
        local j = math.random(i)
        available_bee_cards[i], available_bee_cards[j] = available_bee_cards[j], available_bee_cards[i]
    end

    -- Select a random card
    local chosen_card = available_bee_cards[1]

    return create_card(nil, G.pack_cards, nil, nil, true, true, chosen_card, nil)
end

----------Defining Atlases------------------
SMODS.Atlas {
	key = "beeatlas",
	path = "beeatlas.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "beepackatlas",
	path = "beepackatlas.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

----------Defining Boosterpacks------------------
SMODS.Booster {
	key = "bee_1",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 0, y = 0 },
	order = 5,
	config = { choose = 1, extra = 2 },
	cost = 4,
	weight = 2 * (0.5), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	loc_txt = {
		name = "Bee Pack",
		text = {
			"Choose {C:attention}#1#{} of",
			"up to {C:attention}#2# Beelatro Jokers{}",
		},
	},
	group_key = "k_bee_pack",
}

SMODS.Booster {
	key = "bee_alt",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 0, y = 1 },
	order = 5,
	config = { choose = 1, extra = 2 },
	cost = 4,
	weight = 2 * (0.5), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	loc_txt = {
		name = "Bee Pack",
		text = {
			"Choose {C:attention}#1#{} of",
			"up to {C:attention}#2# Beelatro Jokers{}",
		},
	},
	group_key = "k_bee_pack",
}

SMODS.Booster {
	key = "bee_2",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 1, y = 0 },
	order = 6,
	config = { choose = 1, extra = 4 },
	cost = 6,
	weight = 2 * (0.4), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	loc_txt = {
		name = "Jumbo Bee Pack",
		text = {
			"Choose {C:attention}#1#{} of",
			"up to {C:attention}#2# Beelatro Jokers{}",
		},
	},
	group_key = "k_bee_pack",
}

SMODS.Booster {
	key = "bee_3",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 2, y = 0 },
	order = 7,
	config = { choose = 2, extra = 5 },
	cost = 8,
	weight = 2 * (0.3), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	loc_txt = {
		name = "Mega Bee Pack",
		text = {
			"Choose {C:attention}#1#{} of",
			"up to {C:attention}#2# Beelatro Jokers{}",
		},
	},
	group_key = "k_bee_pack",
}

----------Defining Jokers------------------

SMODS.Joker {
	key = 'jimbee',
	loc_txt = {
		name = 'Jimbee',
		text = {
            "{C:mult}+#1#{} Mult",
			"{C:inactive}This counts as",
			"{C:inactive}a Bee Joker"
		}
	},
	config = { extra = { mult = 4, bee = true, bold = 1} },
	rarity = 1,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
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
            "This has {C:mult}+#2#{} Mult for each {C:attention}bolded{} word",
			"or number your {C:attention}Bee Jokers{} have",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 1, y = 1 },
	pools = {["Bee"] = true},
	cost = 5,
	blueprint_compat = true,
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
            "destroy Joker to the right if its not a ",
        	"{C:attention}Bee Joker{} to create #1# {C:attention}Jimbee{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
    rarity = 2,
    cost = 8,
	config = { extra = {jimbeeCount = 3, bee = true, bold = 4} },
    atlas = "beeatlas",
	pools = {["Bee"] = true},
    blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(100,card.ability.extra.jimbeeCount), card and card.ability.extra.bee, card and card.ability.extra.bold }	}
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
			and not G.jokers.cards[my_pos + 1]:is_bee()
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
			for i = 1, math.min(100,card.ability.extra.jimbeeCount) do
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
			"{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { chips = 0, chip_mod = 5, bee = true, bold = 4} },
	rarity = 1,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 3, y = 0 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.chips, card and card.ability.extra.chip_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
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
			if card.ability.extra.chips > 0 then
				return {
					chip_mod = card.ability.extra.chips,
					message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
				}
			end
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
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 4} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 4, y = 0 },
	cost = 2,
	pools = {["Bee"] = true},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
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
			if card.ability.extra.mult > 0 then
				return {
					mult_mod = card.ability.extra.mult,
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				}
			end
		end
    end
}

SMODS.Joker {
	key = 'ballofbees',
	loc_txt = {
		name = 'Ball of Bees',
		text = {
            "When you play a {C:attention}Straight{},", 
            "create #1# {C:attention}Jimbee{} {C:inactive}(Must have room)",
			"When you play a {C:attention}Flush{},",
			"retrigger your {C:attention}Bee Jokers{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { beecount = 1, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pools = {["Bee"] = true},
	blueprint_compat = true,
	pos = { x = 4, y = 1 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(100, card.ability.extra.beecount), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.before and not context.debuff and (#G.jokers.cards + G.GAME.joker_buffer) < G.jokers.config.card_limit then
			if context.scoring_name == "Straight" then 
				for i = 1, math.min(100, card.ability.extra.beecount) do				
					local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
					card:add_to_deck()
					G.jokers:emplace(card)								
				end

			return {message = 'Bzzzzz! Bzzzzz!', colour = G.C.FILTER,}
			end
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
			"{C:inactive}(Granting {C:attention}+#2# {C:inactive}Joker Slots)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { slots = 2, bee = true, bold = 6, beeCount = 1, activeSlots = 0} },
	rarity = "cry_epic",
	atlas = 'beeatlas',
	blueprint_compat = false,
	pos = { x = 1, y = 0 },
	cost = 15,
	pools = {["Bee"] = true},
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
    end,
	-- cry_credits = {
	-- 	idea = {
	-- 		"InspectorB"
	-- 	},
	-- 	art = {
	-- 		"MarioFan597"
	-- 	},
	-- 	code = {
	-- 		"InspectorB"
	-- 	}
	}


SMODS.Joker {
	key = 'kingbee',
	loc_txt = {
		name = 'King Bee',
		text = {
            "This gains {C:mult}+#2#{} Mult for each {C:attention}Bee Joker{} ",
			"you have whenever a {C:attention}King{} is scored",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 1, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 0, y = 1 },
	cost = 5,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual
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
	key = 'queenbee',
	loc_txt = {
		name = 'Queen Bee',
		text = {
            "This gains {X:mult,C:white} X#1# {} Mult for each {C:attention}Bee Joker{} ",
			"you have whenever you score a {C:attention}Queen{}",
			"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { extra = 0.1, x_mult = 1 , bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 0, y = 2 },
	cost = 5,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.extra, card and card.ability.extra.x_mult, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual
		then
			local rank = SMODS.Ranks[context.other_card.base.value].key

			if rank == "Queen" then
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
			end
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
	config = { extra = { extra = 0.06, x_mult = 1 , bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 0, y = 3 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.extra, card and card.ability.extra.x_mult, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.after
		and not context.before			
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
			"create #1# {C:attention}Jimbee{}",
			"{C:inactive}(Must have room)"
		}
	},
	config = { extra = { jimbeeCount = 1, bee = false, bold = 1} },
	rarity = 1,
	pools = {["Bee"] = true},
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 2, y = 1 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(100, card.ability.extra.jimbeeCount), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		and (#G.jokers.cards + G.GAME.joker_buffer) < G.jokers.config.card_limit
		then
			for i = 1, math.min(100, card.ability.extra.jimbeeCount) do				
				local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
				card:add_to_deck()
				G.jokers:emplace(card)								
			end

			return {message = 'Created!', colour = G.C.FILTER,}
		end
    end
}

SMODS.Joker {
	key = 'jollybee',
	loc_txt = {
		name = 'Jollybee',
		text = {
            "If played hand contains a {C:attention}Pair{}, this gains",
			"{C:mult}+#2#{} Mult for each {C:attention}Bee Joker{} you have",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 5, y = 0 },
	cost = 5,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Pair']) then
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
					})
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
	key = 'larva',
	loc_txt = {
		name = 'Larva',
		text = {
            "In {C:attention}#1#{} rounds,", 
            "create a {C:attention}Holographic Jimbee",
			"{C:red,E:2}self destructs{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { rounds = 2, bee = true, bold = 2} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 3, y = 1 },
	cost = 0,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.rounds, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
		then
			card.ability.extra.rounds = card.ability.extra.rounds - 1
			if card.ability.extra.rounds > 0 then
				return {
					message = { localize("cry_minus_round") },
					colour = G.C.FILTER,
				}
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				local card = create_card(
					"Joker",
					G.jokers,
					nil,
					nil,
					nil,
					nil,
					"j_bee_jimbee"
				)
				card:set_edition({holo = true})
				card:add_to_deck()
				G.jokers:emplace(card)
				return {
					message = localize("k_extinct_ex"),
					colour = G.C.FILTER,
				}
			end
		end
	end,
}

SMODS.Joker {
	key = 'honeycomb',
	loc_txt = {
		name = 'Honeycomb',
		text = {
			"When round ends, ",
            "earn {C:money}#1#${} for each",
            "{C:attention}Bee Joker{} you have",
		}
	},
	config = { extra = { dollars = 3, bee = false, bold = 3} },
	rarity = 2,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 5, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.dollars,card and card.ability.extra.bee, card and card.ability.extra.bold} }
	end,



	calc_dollar_bonus = function (self, card)
				local beeCount = 0
					for i = 1, #G.jokers.cards do
						if
							G.jokers.cards[i]:is_bee()
						then
							beeCount = beeCount + 1
						end
					end

					if beeCount > 0 then
						return card.ability.extra.dollars * beeCount
					end
    		end
}

SMODS.Joker {
	key = 'benson',
	loc_txt = {
		name = 'Barry B. Benson',
		text = {
            "{C:attention}According{} to {C:attention}all{} known {C:attention}laws{} of {C:attention}aviation{}, there {C:attention}is{} no {C:attention}way{} a {C:attention}bee{} should {C:attention}be{} able {C:attention}to{} fly", 
			"{C:attention}Its{} wings {C:attention}are{} too {C:attention}small{} to {C:attention}get{} its {C:attention}fat{} little {C:attention}body{} off {C:attention}the{} ground",
			"{C:attention}The{} bee, {C:attention}of{} course, {C:attention}flies{} anyway {C:attention}because{} bees {C:attention}don't{} care {C:attention}what{} humans {C:attention}think{} is {C:attention}impossible{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},                     
	config = { extra = { bee = true, bold = 24} },
	rarity = 4,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 2, y = 2 },
	soul_pos = { x = 3, y = 2 },
	cost = 25,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if 
			context.before and not context.repetition and not context.individual and
			#G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
		then
			local editions = {
				{negative = true},
				{cry_astral = true},
				{polychrome = true},
				{cry_noisy = true},
				{cry_mosaic = true},
				{cry_glitched = true},
				{cry_oversat = true},
				{cry_blur = true},
				{cry_glass = true},
				{cry_gold = true},
				{holo = true},
				{foil = true}
			}

			local randomIndex = math.random(1, #editions)
			local selectedEdition = editions[randomIndex]

			local card = create_card(
					"Joker",
					G.jokers,
					nil,
					nil,
					nil,
					nil,
					"j_bee_jimbee"
				)
			
			card:set_edition(selectedEdition)
			card:add_to_deck()
			G.jokers:emplace(card)

			return {message = "You like jazz?",
			colour = G.C.FILTER}
		end
    end
}

SMODS.Joker {
	key = 'weebee',
	loc_txt = {
		name = 'Wee Bee',
		text = {
            "This gains {C:chips}+#2#{} Chips for each {C:attention}Bee Joker{}",
            "you have when each {C:attention}2{} is scored",
            "{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { chips = 0, chip_mod = 4, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 1, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.chips, card and card.ability.extra.chip_mod, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual
		then
			local rank = SMODS.Ranks[context.other_card.base.value].key

			if rank == "2" then
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
					message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.chip_mod * beeCount } }),
					colour = G.C.CHIPS,
				}
			)
		end
	end

	if context.joker_main then
		if card.ability.extra.chips > 0 then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'honeypot',
	loc_txt = {
		name = 'Honeypot',
		text = {
            "{C:mult}+#1#{} Mult",
            "{C:mult}-#3#{} Mult per round",
			"For each {C:attention}Bee Joker{} you have:",
			"{C:mult}+#2#{} Mult per round"
		}
	},
	config = { extra = { mult = 30, mult_mod = 5, mult_loss = 10, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 4, y = 2 },
	cost = 7,
	pools = {["Bee"] = true},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.mult_loss, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		then
			local beeCount = 0
			local mult_total_loss = 0
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]:is_bee()
				then
					beeCount = beeCount + 1
				end
			end
			card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_mod * beeCount) - card.ability.extra.mult_loss
			if card.ability.extra.mult > 0 and card.ability.extra.mult_mod * beeCount - card.ability.extra.mult_loss >= 0
			then
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{
						message = localize({ type = "variable", key = "a_mult", vars = { (card.ability.extra.mult_mod * beeCount) - card.ability.extra.mult_loss} }),
						colour = G.C.MULT
				}
			)
			else if card.ability.extra.mult > 0 and card.ability.extra.mult_mod * beeCount - card.ability.extra.mult_loss < 0
			then
				mult_total_loss = (card.ability.extra.mult_mod * beeCount) - card.ability.extra.mult_loss
				card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{message =  ""..mult_total_loss, colour = G.C.MULT}
			)
			--This part borrowed from SMOD Example Jokers
			else
				-- This part plays the animation.
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
				end
				}))
				return {
					message = 'Eaten!'
				}
			end
		end
	end
		
		if context.joker_main then
			if card.ability.extra.mult > 0 then
				return {
					mult_mod = card.ability.extra.mult,
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
					}
				end
		end	
end
}

SMODS.Joker {
	key = 'nostalgic_jimbee',
	loc_txt = {
		name = 'Nostalgic Jimbee',
		text = {
            "{C:mult}+#1#{} Mult",
			"Retrigger your {C:attention}Jimbee",
			"{C:inactive}This counts as",
			"{C:inactive}a Bee Joker"
		}
	},
	config = { extra = { mult = 4, bee = true, bold = 2} },
	rarity = 1,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 5, y = 2 },
	cost = 3,
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
		-- and context.other_card.ability.name == "j_bee_jimbee"
		if (context.retrigger_joker_check and not context.retrigger_joker and 
			(context.other_card.ability.name == "j_bee_jimbee" or context.other_card.ability.name == "j_bee_nostalgic_jimbee")) then
				return {
					message = localize("k_again_ex"),
					repetitions = 1,
					card = card,
				}
		end
    end
}

SMODS.Joker {
	key = 'grim_queen',
	loc_txt = {
		name = 'Grim Queen',
		text = {
            "For each {C:attention}Bee Joker{} you have,",
			"convert the leftmost scored card ",
			"into a {C:attention}Stone Card",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 4, bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = false,
	pools = {["Bee"] = true},
	pos = { x = 5, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if
			context.cardarea == G.jokers
			and context.before
			and not context.blueprint_card
			and not context.retrigger_joker
		then
			local beeCount = 0
			local converted = false
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]:is_bee()
				then
					beeCount = beeCount + 1
				end
			end

			for i = 1, #context.scoring_hand do	
			converted = true
			if beeCount < i then break end
			local _card = context.scoring_hand[i]
				local enhancement = "m_stone"
				if _card.ability.effect ~= "Stone Card" then
					_card:set_ability(G.P_CENTERS[enhancement], nil, true)
				end
				G.E_MANAGER:add_event(Event({
					delay = 0.6,
					func = function()	
						_card:juice_up()
						play_sound("tarot1")
						return true
					end,
				}))
			end

			if converted then
				return {message = 'Stoned!', colour = G.C.FILTER,}
			end
		end
    end
}
----------------------------------------------
------------MOD CODE END----------------------
