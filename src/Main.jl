using ArgParse
using BenchmarkTools

include("configurations\\MasterConfiguration.jl")
include("master\\ODP_MasterAlgorithm.jl")
include("utils\\Result.jl")

include("utils\\PlotsUtils.jl")



function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "n"
            help = "n dededede"
            arg_type = Int
            required = true
        "k"
            help = "k dededede"
            arg_type = Int
            required = true
        "m"
            help = "m dededede"
            arg_type = Int
            required = true
        "port"
            help = "Server port"
            arg_type = Int
            default = 10000
        "dist"
            help = "Distance function"
            arg_type = String
            default = "square"
        "conn_type"
            help = "Connection type"
            arg_type = String
            default = "tcp"
    end
    return parse_args(s)
end
function main()
    # @show parsed_args = parse_commandline()
    # println("Parsed args:")
    # for (arg,val) in parsed_args
    #     print("  $arg  =>  ")
    #     show(val)
    #     println()
    # end

    #  Setting up Slave
    filepath1 = "datasets\\make_moons100k.txt"
    filepath2 = "datasets\\make_moons100k.txt"
    filepath3 = "datasets\\make_moons100k.txt"
    filepath4 = "datasets\\make_moons100k.txt"

    generateNewFile = false

    args_conf_slave = [filepath1, generateNewFile]

    if args_conf_slave[2]
        args_conf_slave[1] = "datasets\\test3.txt"
        rndMatrix = map(x->300000.0+x*(1000),rand(10000,2))
        rndMatrix3 = map(x->3000.0+x*(1005),rand(100,2))
        rndMatrix2 = map(x->3000.0+x*(1002),rand(100,2))

        foo = [rndMatrix, rndMatrix2, rndMatrix3]
        A = reduce(vcat,foo)

        generatePoints(filepath1, A)
    end

    filepath1 = args_conf_slave[1]


    #  Setting up Master
    args_conf_master = [20,6,6,"euclidean"]
    n = args_conf_master[1]
    k = args_conf_master[2]
    m = args_conf_master[3]
    dist = args_conf_master[4]

    config1 = MasterConfiguration(100, 20, 20, dist)


    masterAlg1 = getMasterAlgorithm(config1)


    result1 = runODPAlgorithm(masterAlg1, filepath1)
    result2 = runODPAlgorithm(masterAlg1, filepath2)
    result3 = runODPAlgorithm(masterAlg1, filepath3)
    result4 = runODPAlgorithm(masterAlg1, filepath4)

    r = Result[result1,result2,result3,result4]


    return r

end

r = main()

# Print report..
print(getReport(r))

# Plotting..
display(plotSets("Dataset", r[4].dataset, r[4].solution, ["Dataset","solution"]))

c1 = 1
for i in r
    display(plotSets("Dataset"*string(count), i.dataset, i.solvingSet, i.solution, ["Dataset","SolvingSet","solution"]))
    global c1+=1
end

#-----------------------------------------------------------
# ()|D|, |S|) - plot
x = Vector{Int64}()
y1 = Vector{Int64}()
for i in r
    push!(x,i.dataset_size)
    push!(y1,i.solvingSet_size)
end
display(plot(x, y1, title = "Scaling analysis of the ODP solving sets sizes", label = "|S| -> n=100 k=20", marker=[:o], c=[:orange], legend=:right))

# (|D|, execution time in seconds) - plot
y2 = [21.04, 39.5, 90.45,207.5]
display(plot(x, y2, title = "Scaling analysis of the execution times", label = "time(s) -> n=100 k=20", marker=[:o], c=[:red], legend=:right))

# for i in 1:length(result1.itC)
#     plt = plotSets("Iteration#"*string(i), result1.dataset, result1.itS[i], result1.itC[i], ["Dataset","SolvingSet","Cand"])
#     display(plt)
# end
# plotSets(result1.dataset, result1.solvingSet, result1.solution, ["Dataset","SolvingSet","solution"])
#
# plotSets("Full Dataset",result1.dataset, ["Dataset"])
#plotSets("Solution", result1.solvingSet, result1.solution, ["SolvingSet","solution"])
