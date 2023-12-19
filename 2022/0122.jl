function readin(filepath = "0122sample.txt")
	raw = read(filepath, String) |> chomp
	
	elves = NTuple[]
	for elf in eachsplit(raw, "\n\n")
		elf = parse.(Int, (eachsplit(elf, '\n')..., ))
		push!(elves, elf)
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