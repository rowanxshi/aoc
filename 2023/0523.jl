function parse_nums(range_str = "50 98 2")
	[parse(Int, m.match) for m in eachmatch(r"[0-9]+", range_str)]
end
function parse_map(map_str)
	ranges = split(map_str, "\n")
	[parse_nums(range) for range in ranges[2:end]]
end
function parse_almanac(filepath = "0523sample")
	raw = split(readchomp(filepath), "\n\n")
	parse_nums(first(raw)), [parse_map(map_str) for map_str in raw[2:end]]
end

function map(start, ranges)
	for range in ranges
		destination, source, range_length = range
		if start ∈ source:(source+range_length-1)
			return start - source + destination
		end
	end
	start
end
function chain_maps(maps, start)
	for ranges in maps
		start = map(start, ranges)
	end
	start
end
function lowest_location((seeds, maps))
	minimum(seeds) do seed
		chain_maps(maps, seed)
	end
end

lowest_location(parse_almanac("0523input"))
