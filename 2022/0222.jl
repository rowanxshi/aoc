function readin(filepath="0222sample.txt")
	games = NTuple{2, Int}[]
	for game in eachline(filepath)
		opponent = findfirst(==(game[1]), 'A':'C')
		self = findfirst(==(game[3]), 'X':'Z')
		push!(games, (opponent, self))
	end
	games
end

function score1(games)
	sum(games) do (opponent, self)
		istie = isequal(self, opponent)
		iswin = isone(mod(self - opponent, 3))
		self + 3*istie + 6*iswin
	end
end

function score2(games)
	sum(games) do (opponent, outcome)
		self = mod(opponent+outcome-2, 3)
		self = iszero(self) ? 3 : self
		(outcome-1)*3 + self
	end
end

readin("0222.txt") |> score1
readin("0222.txt") |> score2