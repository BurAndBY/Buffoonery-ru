SMODS.Joker {
    key = "rerollin",
    name = "Rerollin'",
    atlas = 'maggitsjokeratlas',
    pos = {
        x = 0,
        y = 3,
    },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        extra = 20, rcount = 0, needed = 5, numetal = true   
    },
    loc_txt = {
        name = "Rerollin'",
        text = {"Earn {C:money}$#1#{} for your",          
                "{C:attention}5th reroll{} each shop",
				"{C:inactive}(#3# rerolls required){}"}
    },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {set = 'Other', key = 'korny_info'}   --Credit original artwork author [Snakey] (adapted by me for balatro)
        return {
            vars = {card.ability.extra, card.ability.rcount, card.ability.needed}
        }
    end,
    calculate = function(self, card, context)
		if card.ability.rcount < 5 then
			if context.reroll_shop then
				card.ability.rcount = card.ability.rcount + 1
				card.ability.needed = 5 - card.ability.rcount
				if card.ability.rcount == 5 then 
					ease_dollars(card.ability.extra)
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Rerollin'", colour = G.C.GOLD})
				end
			end
		end
		if context.ending_shop then
			card.ability.rcount = 0
			card.ability.needed = 5
		end
    end
}