function readin(filepath="1122sample.txt")
    raw = read(filepath, String)
    monkeys = []
    for monkey in eachsplit(raw, "\n\n")
        items = match(r"Starting items: (.*)", monkey).captures |> first
        op = match(r"Operation: new = (.*)", monkey).captures |> first
        test = match(r"Test: divisible by (.*)", monkey).captures |> first
        istest = match(r"If true:.*([0-9]+?)", monkey).captures |> first
        isnttest = match(r"If false:.*([0-9]+?)", monkey).captures |> first

        items = parse.(Int, getproperty.(eachmatch(r"[0-9]+", items), :match))
        op = Meta.parse("old -> $op")
        op = eval(op)
        test = parse.(Int, test)
        istest = parse.(Int, istest)+1
        isnttest = parse.(Int, isnttest)+1
        testparams = (test, istest, isnttest)

        monkey = (; items, op = @eval($op), testparams)
        push!(monkeys, monkey)
    end
    monkeys
end

isdivisible(num, denom) = iszero(mod(num, denom))
div3(x) = div(x, 3)

function turn!(imonkey, monkeys; manage_worry = div3)
    monkey = monkeys[imonkey]
    for item in monkey[:items]
        worry = monkey[:op](item)
        worry = manage_worry(worry)
        istest = isdivisible(worry, monkey[:testparams][1])
        goesto = istest ? monkey[:testparams][2] : monkey[:testparams][3]
        push!(monkeys[goesto][:items], worry)
    end
    empty!(monkey[:items])
    monkeys
end

function round!(monkeys, inspections = zeros(Int, length(monkeys)); manage_worry = div3)
    for imonkey in eachindex(monkeys)
        inspections[imonkey] += length(monkeys[imonkey][:items])
        turn!(imonkey, monkeys; manage_worry)
    end
    monkeys, inspections
end

function rounds!(monkeys, n::Integer = 20, inspections = zeros(Int, length(monkeys)); manage_worry = div3)
    for _ in 1:n
        round!(monkeys, inspections; manage_worry)
    end
    monkeys, inspections
end

function monkeyprimes(monkeys)
    ((first(monkey[:testparams]) for monkey in monkeys)..., )
end

monkeybusiness(inspections) = sort(inspections, rev=true)[1:2] |> prod

monkeys = readin("1122.txt")
monkeys, inspections = rounds!(monkeys)
monkeybusiness(inspections)

monkeys = readin("1122.txt")
monkeys, inspections = rounds!(monkeys, 10_000; manage_worry = x -> mod(x, prod(monkeyprimes(monkeys))))
monkeybusiness(inspections)