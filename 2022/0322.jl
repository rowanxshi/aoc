function readin(filepath="0322sample.txt")
	rucksacks = NTuple{2, String}[]
	for rucksack in eachline(filepath)
		push!(rucksacks, (rucksack[1:Int(end/2)], rucksack[Int(end/2 + 1):end]))
	end
	rucksacks
end

priority(x) = x - (islowercase(x) ? 'a' : 'A') + 1

function priorities1(rucksacks)
	order = priorityorder()
	sum(rucksacks) do (left, right)
		shared = first(∩(left, right))
		priority = findfirst(shared, order)
	end
end

function priorities2(rucksacks)
	order = priorityorder()
	sum(Iterators.partition(rucksacks, 3)) do group
		badge = first(∩(prod.(group)...))
		priority = findfirst(badge, order)
	end
end

readin("0322.txt") |> priorities1
readin("0322.txt") |> priorities2