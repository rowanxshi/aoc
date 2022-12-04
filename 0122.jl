function readin(filepath = "0122sample.txt")
	raw = read(filepath, String) |> chomp
	raw = replace(raw, "\n\n" => '.')
	raw = split(raw, '.')
	
	elves = NTuple[]
	
	for elf in raw
		push!(elves, (parse.(Int, split(elf, "\n"))..., ))
	end
	elves
end

topelf(elves) = maximum(sum, elves)

function topthreeelves(elves)
	sums = sum.(elves)
	sort!(sums, rev = true)
	@views sum(sums[1:3])
end

readin("0122.txt") |> topelf
readin("0122.txt") |> topthreeelves