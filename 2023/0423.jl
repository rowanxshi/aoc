function all_numbers(numbers_str)
	[parse(Int, m.match) for m in eachmatch(r"[0-9]+", numbers_str)]
end
function parse_card(card_str = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
	winning = match(r":([ 0-9]+)\|", card_str).captures |> first
	scratch = match(r"\|([ 0-9]+)$", card_str).captures |> first
	count(∈(all_numbers(winning)), all_numbers(scratch))
end
function card_value(matches)
	iszero(matches) ? 0. : 2^(matches - 1)
end

function N_cards(cards = chomp("0423sample"))
	last_card = last(eachline(cards))
	card_number = match(r"Card ([0-9]+):", last_card).captures |> first
	parse(Int, card_number)
end
function geminio(cards = chomp("0423sample"))
	card_copies = ones(Int, N_cards(cards))
	for (i_card, card_str) in enumerate(eachline(cards))
		matches = parse_card(card_str)
		card_copies[(i_card+1):(i_card+matches)] .+= card_copies[i_card]
	end
	card_copies |> sum
end

sum(card_value ∘ parse_card, eachline(chomp("0423input")))
geminio(chomp("0423input"))
