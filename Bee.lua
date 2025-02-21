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
---

		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_jimbee", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_ctrlplusbee", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_beebeedagger", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_spellingbee", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_ballofbees", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_hivemind", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_kingbee", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_beesknees", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_beehive", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_jollybee", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_queenbee", nil)
		--return create_card(nil, G.pack_cards, nil, nil, true, true, "j_bee_larva", nil)

function Card:is_bee()
	local check = false

	--self.ability.extra ~= nil and 
	if not is_number(self.ability.extra) and self.ability.extra ~= nil and self.ability.extra.bee then
		check = true
	return check

	end
end

--todo Sometimes duplicate cards appear, although this seems to be an edge case for when you have all of the bee jokers. Will fix later.
function Get_random_bee_card()
    -- Define standard cards (each appears once per cycle)
    local bee_cards = {
        "j_bee_jimbee",
        "j_bee_ctrlplusbee",
        "j_bee_beebeedagger",
        "j_bee_spellingbee",
        "j_bee_ballofbees",
        "j_bee_kingbee",
        "j_bee_beesknees",
        "j_bee_beehive",
        "j_bee_jollybee",
        "j_bee_bigbee",
        "j_bee_larva",
        "j_bee_queenbee"
    }

    -- Define rare cards with their individual frequency (1 in X cycles)
    local rare_cards = {
        {name = "j_bee_hivemind", chance = 3} -- Appears once every 3 cycles
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

    -- Function to reset the Bee Joker pool
    local function reset_bee_pool()
        G.remaining_bee_cards = {}
        local added_cards = {} -- Tracks which cards have been added to prevent duplicates

        -- Add standard cards if not already found or held (unless Showman exists)
        for _, card in ipairs(bee_cards) do
            if not ((G.GAME.used_jokers[card] or is_in_hand(card)) and not has_showman) then
                table.insert(G.remaining_bee_cards, card)
                added_cards[card] = true
            end
        end

        -- Add rare cards with their probability, ensuring no duplicates in this cycle
        for _, rare in ipairs(rare_cards) do
            if math.random(rare.chance) == 1 and not ((G.GAME.used_jokers[rare.name] or is_in_hand(rare.name)) and not has_showman) then
                if not added_cards[rare.name] then
                    table.insert(G.remaining_bee_cards, rare.name)
                    added_cards[rare.name] = true
                end
            end
        end

        -- If after filtering, the pool is **still empty**, add all Bee Jokers back to prevent crashing
        if #G.remaining_bee_cards == 0 then
            for _, card in ipairs(bee_cards) do
                table.insert(G.remaining_bee_cards, card)
            end
        end

        -- Shuffle the list to ensure randomness per cycle
        for i = #G.remaining_bee_cards, 2, -1 do
            local j = math.random(i)
            G.remaining_bee_cards[i], G.remaining_bee_cards[j] = G.remaining_bee_cards[j], G.remaining_bee_cards[i]
        end
    end

    -- If no valid choices remain, reset the pool
    if not G.remaining_bee_cards or #G.remaining_bee_cards == 0 then
        reset_bee_pool()
    end

    -- If the pool somehow ended up empty, reset it again
    if #G.remaining_bee_cards == 0 then
        reset_bee_pool()
    end

    -- Select a random card and remove it from the available pool
    local chosen_card = table.remove(G.remaining_bee_cards)

    return create_card(nil, G.pack_cards, nil, nil, true, true, chosen_card, nil)
end

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

SMODS.Booster {
	key = "bee_1",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 0, y = 0 },
	order = 5,
	config = { choose = 1, extra = 2 },
	cost = 4,
	weight = 2 * (0.4), 
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
			"up to {C:attention}#2# Bee Jokers{}",
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
	weight = 2 * (0.3), 
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
			"up to {C:attention}#2# Bee Jokers{}",
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
		name = "Bee Pack",
		text = {
			"Choose {C:attention}#1#{} of",
			"up to {C:attention}#2# Bee Jokers{}",
		},
	},
	group_key = "k_bee_pack",
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
            "This has {C:mult}+#2#{} Mult for each ",
			"{C:attention}bolded{} word or number your {C:attention}Bee Jokers{} have",
			"{C:inactive}(Currently +#1# Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 4} },
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
            "destroy Joker to the right",
        	"to create #1# {C:attention}Jimbee{}",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
    rarity = 2,
    cost = 8,
	config = { extra = {jimbeeCount = 2, bee = true, bold = 2} },
    atlas = "beeatlas",
	pools = {["Bee"] = true},
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
			"",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { beecount = 1, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pools = {["Bee"] = true},
	blueprint_compat = true,
	pos = { x = 0, y = 3 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.beecount, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Straight']) then
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
			"you have whenever you score a {C:attention}King{}",
			"{C:inactive}(Currently +#1# Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 1, bee = true, bold = 4} },
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
	pos = { x = 3, y = 3 },
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
	config = { extra = { extra = 0.1, x_mult = 1 , bee = true, bold = 4} },
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
			"create #1# {C:attention}Jimbee{}"
		}
	},
	config = { extra = { jimbeeCount = 1, bee = false, bold = 1} },
	rarity = 1,
	pools = {["Bee"] = true},
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 3, y = 3 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.jimbeeCount, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
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

SMODS.Joker {
	key = 'jollybee',
	loc_txt = {
		name = 'Jollybee',
		text = {
            "Whenever you play a {C:attention}Pair,",
			"This gains {C:mult}+#2#{} Mult for each {C:attention}Bee Joker{} you have",
			"{C:inactive}(Currently +#1# Mult)",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 4} },
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
            "In {C:attention}#1#{} rounds, create a {C:attention}Holographic Jimbee",
			"{C:red,E:2}self destructs{}",
			"",
			"{C:inactive}This counts as a Bee Joker"
		}
	},
	config = { extra = { rounds = 2, bee = true, bold = 2} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 3, y = 3 },
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

----------------------------------------------
------------MOD CODE END----------------------