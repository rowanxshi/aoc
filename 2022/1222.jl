function readin(filepath = "1222sample.txt")
 width = length(first(eachline(filepath)))
 io = open(filepath, "r")
 elevations = Int[]

 for cc in readeach(io, Char)
  isspace(cc) && continue
  push!(elevations, cc - 'a')
 end

 goal = findfirst(==('E' - 'a'), elevations)
 elevations[goal] = 'z' - 'a'

 start = findfirst(==('S' - 'a'), elevations)
 elevations[start] = 'a' - 'a'

 map = reshape(elevations, width, :) 
 CartesianIndices(map)[start], CartesianIndices(map)[goal], map
end

function directions(position, map)
 indices = CartesianIndices(map)
 cartfirst, cartlast = first(indices), last(indices)

 left = max(cartfirst, position + CartesianIndex(0, -1))
 right = min(cartlast, position + CartesianIndex(0, 1))
 up = max(cartfirst, position + CartesianIndex(-1, 0))
 down = min(cartlast, position + CartesianIndex(1, 0))

 dirs = (left, right, up, down)
end

function minpath(pathhead, goal, map; memo = Dict{CartesianIndex, Float64}())
 position = last(pathhead)

 # base case
 isequal(goal, position) && return get!(memo, goal, 0.0)

 dirs = Iterators.filter(directions(position, map)) do dir
  (map[dir] - map[position] ≤ 1) && !(dir ∈ pathhead)
 end
 isempty(dirs) && return Inf

 steps = 1 + minimum(dirs) do newposition
  (newposition ∈ pathhead) && return Inf
  minpath(push!(pathhead[:], newposition), goal, map; memo)
 end
end

start, goal, map = readin("1222.txt")

