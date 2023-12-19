function ispart(i_num, i_line, schematic)
	i_start = max(i_num.start-1, 1)
	i_stop = min(i_num.stop+1, length(schematic[i_line]))
	i_top = max(i_line-1, 1)
	i_bottom = min(i_line+1, length(schematic))

	any(i_top:i_bottom) do i
		chunk = schematic[i][i_start:i_stop]
		!isnothing(match(r"[^0-9\.]", chunk))
	end
end
function sum_parts(filepath = "0323sample")
	schematic = readlines(chomp(filepath))
	sum(enumerate(schematic)) do (i_line, line)
		i_nums = findall(r"[0-9]+", line)
		sum(i_nums; init = 0) do i_num
			if ispart(i_num, i_line, schematic)
				parse(Int, line[i_num])
			else
				0
			end
		end
	end
end

function gear_ratio(i_num, i_line, schematic)
	i_start = max(i_num-1, 1)
	i_stop = min(i_num+1, length(schematic[i_line]))
	i_top = max(i_line-1, 1)
	i_bottom = min(i_line+1, length(schematic))

	ratio = 1
	parts = sum(i_top:i_bottom) do i
		i_nums = findall(r"[0-9]+", schematic[i])
		count(i_nums) do j
			if !isdisjoint(j, i_start:i_stop)
				part = parse(Int, schematic[i][j])
				ratio *= part
				true
			else
				false
			end
		end
	end

	(parts == 2) ? ratio : 0
end

function sum_ratios(filepath = "0323sample")
	schematic = readlines(chomp(filepath))
	sum(enumerate(schematic)) do (i_line, line)
		sum(findall('*', line); init = 0) do i_num
			gear_ratio(i_num, i_line, schematic)
		end
	end
end

sum_parts("0323input")
sum_ratios("0323input")
