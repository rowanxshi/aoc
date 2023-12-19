function subgame_possible(subgame; total = (12, 13, 14))
	all(subgame .≤ total)
end
function parse_colour(subgame_str, colour = "red")
	m = match(Regex("([0-9]*) $colour"), subgame_str)
	hasproperty(m, :captures) ? parse(Int, first(m.captures)) : 0
end
function parse_subgame(subgame_str)
	[
		parse_colour(subgame_str, "red"),
		parse_colour(subgame_str, "green"),
		parse_colour(subgame_str, "blue"),
	]
end
function game_possible(game_str)
	all((subgame_possible ∘ parse_subgame), eachsplit(game_str, ';'))
end
function game_number(game_str)
	parse(Int, first(match(r"Game ([0-9]*):", game_str).captures))
end
function sum_games(lines)
	sum(lines) do game_str
		if game_possible(game_str)
			game_number(game_str)
		else
			0
		end
	end
end

function game_power(game_str)
	prod(mapreduce(parse_subgame, (x, y) -> max.(x, y), eachsplit(game_str, ';')))
end
function sum_powers(lines)
	sum(lines) do game_str
		game_power(game_str)
	end
end

sum_games(eachline(chomp("0223input")))
sum_powers(eachline(chomp("0223sample")))
