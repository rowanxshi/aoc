function readin(filepath="0922sample.txt")
	directions = Complex[]
	for line in eachline(filepath)
		dir = first(line)
		dir = if (dir == 'R')
			1
		elseif (dir == 'L')
			-1
		elseif (dir == 'U')
			im
		elseif (dir == 'D')
			-im
		end
		steps = parse(Int, line[3:end])
		push!(directions, steps*dir)
	end
	directions
end

isimag(x) = isreal(im*x)

function movetail((H, T))
	lag = H-T
	# at most side by side
	(abs(lag) ≤ 1) && return T
	
	# diagonally adjacent
	if !isreal(lag) && !isimag(lag) && abs(lag) ≤ √(2)
		return T
	end
	
	T + sign(real(lag)) + sign(imag(lag))*im
end

function moverope!(rope, direction::Complex, path = Complex[])
	steps = Int(abs(direction))
	step = sign(direction)
	for _ in 1:steps
		rope[1] += step
		for iknot in 2:length(rope)
			subrope = (rope[iknot-1], rope[iknot])
			rope[iknot] = movetail(subrope)
			(iknot == length(rope)) && push!(path, rope[end])
		end
	end
	rope
end

function tailpositions(directions::Vector, rope = fill(1+im, 2); path = Complex[])
	for direction in directions
		moverope!(rope, direction, path)
	end
	path, rope
end
tailpositions(directions::Vector, nknots::Int; path = Complex[]) = tailpositions(directions, fill(1+im, nknots); path)

readin("0922.txt") |> tailpositions |> first |> unique |> length
readin("0922.txt") |> dirs -> tailpositions(dirs, 10) |> first |> unique |> length