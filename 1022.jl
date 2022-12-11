function signalstrength(filename="1022sample2.txt"; X0 = 1, keycycles = 20:40:220)
	X, cycle, strength = (X0, 1, 0)
	isinteresting = in(keycycles)
	history = Int[]
	
	for command in eachline(filename)
		op, num = match(r"^([a-z]+)\s*([\-0-9]*)", command).captures
		offset = (op=="noop") ? 1 : 2
		for tick in cycle:(cycle+offset-1)
			push!(history, X)
			isinteresting(tick) && (strength += tick*X)
		end
		if op == "addx"
			num = parse(Int, num)
			X += num
		end
		cycle += offset
	end
	history, strength
end

function draw(history; width = 40)
	screen = ""
	for (cycle, position) in enumerate(history)
		cursor = mod(cycle-1, width)
		out = in(cursor, (position-1:position+1)) ? "#" : "."
		screen *= out
		(cursor == (width-1)) && (screen *= "\n")
	end
	screen
end

history, strength = signalstrength("1022.txt")
draw(history)