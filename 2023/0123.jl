digits = (
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
)
digitswords = (
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"zero",
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine"
)
function finddigit(line; digits = digits)
	N = length(line)+1
	j = argmin(eachindex(digits)) do i_digit
		i = findfirst(digits[i_digit], line)
		j = isnothing(i) ? (N:N) : i
	end
	mod(j-1, 10)
end
function calibration_value(line; digits = digits)
	firstdigit = finddigit(line; digits)
	lastdigit = finddigit(reverse(line); digits = reverse.(digits))

	value = firstdigit*10 + lastdigit
end

sum(calibration_value, eachline(chomp("0123input")))
sum(line -> calibration_value(line; digits = digitswords), eachline(chomp("0123input")))
