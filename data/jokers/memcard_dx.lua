SMODS.Joker {
    key = "dxmemcard",
    name = "Deluxe Memory Card",
    atlas = 'maggitsmiscatlas',
    pos = {
        x = 0,
        y = 2,
    },
    rarity = 'buf_spc',
    cost = 8,
    unlocked = true,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = false,
	in_pool = false,
    config = {
		mcount = 0,
		tsuit = "-",
		trank = "-",
		extra = { cards = {} }
    },
    loc_txt = {set = 'Joker', key = 'j_buf_dxmemcard'},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = 'Other', key = 'special_info'}
        return {
            vars = {
					card.ability.mcount,
					card.ability.tsuit, 
					card.ability.trank
			}
        }
    end,
	set_ability = function(self, card, initial, delay_sprites)
            local W = card.T.w
			local H = card.T.h
            local scale = 1
            card.children.center.scale.y = 1.174*card.children.center.scale.x
            card.T.h = H*scale/1.174*scale
            card.T.w = W*scale
    end,
    calculate = function(self, card, context)
		-- MEMORIZE FIRST SCORING CARD
		if context.before and not context.blueprint then
			if card.ability.mcount < 16 then  --limits to 16 cards memorized
				card.ability.mcount = card.ability.mcount + 1 
				card.ability.extra.cards[card.ability.mcount] = context.scoring_hand[1]  -- [UPDATE]:changed from local variable to table value, in order to store card edition and/or enhancement.
				local _card = context.scoring_hand[1]
				local underscore_pos = string.find(SMODS.Suits[_card.base.suit].key, "_")  -- Checks for mod prefixes in suit keys and removes them from printed string
				if underscore_pos then
					card.ability.tsuit = string.sub(SMODS.Suits[_card.base.suit].key, underscore_pos + 1)  
				else
					card.ability.tsuit = SMODS.Suits[_card.base.suit].key  -- [UPDATE] Now uses SMODS functionality to improve mod compatibility
				end
				card.ability.trank = SMODS.Ranks[_card.base.value].key..' of '
				return {
					message = localize('buf_memory'),
					colour = G.C.GREEN 
				}
			elseif card.ability.mcount >= 16 then
				return {
					message = localize('buf_memfull'),
					colour = G.C.RED
				}
			end
		end
		
		-- CONVERT INTO MEMORIZED CARDS WHEN SELLING
		if context.selling_self and #G.hand.cards ~= 0 and not context.blueprint then
			local j = math.min((card.ability.mcount), #G.hand.cards) -- prevents getting a crash if memorized cards > cards in hand
			if j > 0 then
				for i = 1, j do
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
						local hcard = G.hand.cards[i]
						local mcard = card.ability.extra.cards[i]
						copy_card(mcard, hcard)
						G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);G.hand.cards[i]:flip(); -- Animation stuff
						return true 
					end }))
				end
			else
				return true
			end
		end
    end,
	
	-- HIDE JOKER IN COLLECTION (THANKS, EREMEL) --
	inject = function(self)
		SMODS.Joker.super.inject(self)
		G.P_CENTER_POOLS.Joker[#G.P_CENTER_POOLS.Joker] = nil
	end
	
}