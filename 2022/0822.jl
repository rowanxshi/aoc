function readin(filepath="0822sample.txt")
	width = length(first(eachline(filepath)))
	io = open(filepath, "r")
	trees = Int[]
	for tree in readeach(io, Char)
		isspace(tree) && continue
		push!(trees, parse(Int, tree))
	end
	close(io)
	reshape(trees, width, :)
end

function isvisible(tree::Int, trees::AbstractVector)
	covered = any(≥(tree), trees)
	!covered
end

function nswe(i::CartesianIndex, trees::Matrix{Int})
	(row, col) = Tuple(i)
	nrows, ncols = size(trees)
	
	((row-1):-1:1, col), ((row+1):nrows, col), (row, (col-1):-1:1), (row, (col+1):ncols)
end

function visibles(trees::Matrix{Int})
	count(CartesianIndices(trees)) do i
		any(nswe(i, trees)) do direction
			isvisible(trees[i], trees[direction...])
		end
	end
end

function visibletrees(tree::Int, trees::AbstractVector)
	score = 0
	for othertree in trees
		score += 1
		(othertree ≥ tree) && break
	end
	return score
end

function bestscenic(trees::Matrix{Int})
	relevant = CartesianIndices(trees)[2:end-1, 2:end-1]
	maximum(relevant) do i
		prod(nswe(i, trees)) do direction
			visibletrees(trees[i], trees[direction...])
		end
	end
end

readin("0822.txt") |> visibles
readin("0822.txt") |> bestscenic