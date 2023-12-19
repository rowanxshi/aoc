function readin(filepath="0522sample.txt")
	line = first(eachline(filepath))
	npiles = ceil(Int, length(line)/4)
	piles = ((Char[] for _ in 1:npiles)..., )
	
	lines = eachline(filepath)
	readpiles!(piles, lines)
	
	moves = Vector{NTuple{3, Int}}()
	readmoves!(moves, lines)
	
	piles, moves
end

function readpiles!(piles, lines)
	for line in lines
		isempty(line) && break
		for (pile, ipile) in zip(eachindex(piles), 2:4:length(line))
			!isspace(line[ipile]) && push!(piles[pile], line[ipile])
		end
	end
	pop!.(values(piles))
	reverse!.(values(piles))
end
function readmoves!(moves, lines)
	for line in lines
		matches = eachmatch(r"[0-9]+", line)
		move = ((parse(Int, m.match) for m in matches)..., )
		push!(moves, move)
	end
end

function move!((piles, moves))
	for move in moves
		for _ in 1:move[1]
			push!(piles[move[3]], pop!(piles[move[2]]))
		end
	end
	piles
end

function move9001!((piles, moves))
	for move in moves
		orig = piles[move[2]]
		dest = piles[move[3]]
		
		inds = eachindex(orig)[(end - move[1] + 1):end]
		
		@views append!(dest, orig[inds])
		deleteat!(orig, inds)
	end
end

function message((piles, moves); move!_fn = move!)
	move!_fn((piles, moves))
	prod(last.(piles))
end

readin("0522.txt") |> message
readin("0522.txt") |> x -> message(x; move!_fn = move9001!)