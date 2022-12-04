function readin(filepath="0422sample.txt")
	pairs = NTuple{2, typeof(1:2)}[]
	for pair in eachline(filepath)
		pair = replace(pair, ',' => '-')
		pair = split(pair, '-')
		pair = parse.(Int, pair)
		push!(pairs, (pair[1]:pair[2], pair[3]:pair[4]))
	end
	pairs
end

function contains(pairs)
	count(pairs) do (left, right)
		(left ⊆ right) || (right ⊆ left)
	end
end

function overlaps(pairs)
	count(pairs) do (left, right)
		!isempty(intersect(left, right))
	end
end

readin("0422.txt") |> contains
readin("0422.txt") |> overlaps