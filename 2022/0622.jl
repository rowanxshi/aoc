readin(filepath="0622sample.txt") = read(filepath, String)

function marker(stream; chunklength = 4)
	@views for i in chunklength:length(stream)
		ii = (i-chunklength+1):i
		allunique(stream[ii]) && return i
	end
end

readin("0622.txt") |> markers
readin("0622.txt") |> stream-> marker(stream; chunklength = 14)