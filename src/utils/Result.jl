# Struct representing the final result
mutable struct Result
    # Result header - utility for printResult
    header::String
    # Array of initial dataset points
    dataset::Vector
    # Size of dataset
    dataset_size::Int64
    # Array of solvingSet points
    solvingSet::Vector
    # Size of solvingSet
    solvingSet_size::Int64
    # Array of solution points
    solution::Vector
    # Array of candidate points for each iteration
    itC::Vector
    # Array of solving set for each iteration
    itS::Vector
    # Number of distances calculated by the algorithm
    distCount::Int64


    time::Int64

    Result() = new(Vector(),Vector(),Vector(),Vector(),Vector(), 0, 0)
    Result(header::String, dataset::Vector, solvingSet::Vector, solution::Vector, itC::Vector,itS::Vector,distCount::Int64, time::Int64) = new(header, dataset, length(dataset),solvingSet,length(solvingSet),solution,itC,itS,distCount,time)
end

function getReport(r::Result)
    tmp = "\n\n"*r.header*'\n'
    tmp *= "_____________________________________\n\n"
    tmp *= "|D|\t|S|\t#d (bilions)\n"
    tmp *= "_____________________________________\n\n"
    tmp*= string(r.dataset_size)*'\t'string(r.solvingSet_size)*'\t'*string(r.distCount)*'\n'
    tmp *= "_____________________________________\n\n"
    return tmp
end

function getReport(v::Vector{Result})
    tmp = "\n\n"*v[1].header*'\n'
    tmp *= "_____________________________________\n\n"
    tmp *= "|D|\t|S|\t#d (bilions)\n"
    tmp *= "_____________________________________\n\n"
    for r in v
        tmp*= string(r.dataset_size)*'\t'string(r.solvingSet_size)*'\t'*string(r.distCount)*'\n'
    end
    tmp *= "_____________________________________\n\n"
    return tmp
end
