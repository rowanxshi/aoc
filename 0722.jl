function readin(filepath="0722sample.txt")
	root = Dict{Union{String, Symbol}, Union{Int, Nothing, Dict, String}}()
	lines = eachline(filepath)
	first(lines)
	root[:parent] = nothing
	root[:pwd] = "/"
	currentdir = root
	for line in lines
		contains(line, r"^\$ ls") && continue
		if contains(line, r"^\$ cd")
			m = match(r"^\$ cd (.*)", line)
			changeto = first(m.captures)
			currentdir = (changeto == "..") ? currentdir[:parent] : currentdir[changeto]
		elseif contains(line, r"^dir ")
			subdir = typeof(currentdir)()
			subdir[:parent] = currentdir
			_, dirname = split(line, ' ')
			subdir[:pwd] = currentdir[:pwd]*dirname*"/"
			currentdir[String(dirname)] = subdir
		else
			size, filename = split(line, ' ')
			currentdir[String(filename)] = parse(Int, size)
		end
	end
	root, Dict{String, Int}()
end

function dirsize(dir::Dict, memo = nothing)
	if !isnothing(memo) && haskey(memo, dir[:pwd])
		return memo[dir[:pwd]]
	end
	size = sum(dir) do (key, value)
		(typeof(key) <: Symbol) && return 0
		(typeof(value) <: Real) && return value
		(typeof(value) <: Dict) && return dirsize(value, memo)
	end
	!isnothing(memo) && (memo[dir[:pwd]] = size)
	size
end

isntdir((key, value)) = (typeof(key) <: Symbol) || !(typeof(value) <: Dict)

function minidirs(dir::Dict, memo = nothing; cutoff = 100_000)
	sum(Iterators.filter(!isntdir, dir); init = 0) do (_, value)
		size = dirsize(value, memo)
		minidirs(value, memo; cutoff) + ((size ≤ cutoff) ? size : zero(size))
	end
end

function smallestdelete(dir, memo = nothing; mindelete)
	minimum(Iterators.filter(!isntdir, dir); init = Inf) do (_, value)
		size = min(dirsize(value, memo), )
		min(smallestdelete(value, memo; mindelete), (size ≥ mindelete) ? size : Inf)
	end
end

data = readin("0722.txt");
minidirs(data...)
smallestdelete(data...; mindelete = dirsize(data[1]) + 30_000_000 - 70_000_000)

#- / (dir)
#  - a (dir)
#    - e (dir)
#      - i (file, size=584)
#    - f (file, size=29116)
#    - g (file, size=2557)
#    - h.lst (file, size=62596)
#  - b.txt (file, size=14848514)
#  - c.dat (file, size=8504156)
#  - d (dir)
#    - j (file, size=4060174)
#    - d.log (file, size=8033020)
#    - d.ext (file, size=5626152)
#    - k (file, size=7214296)
