using Random
using Distances
using Plots

include("..\\elements\\Elements.jl")
include("..\\file_input\\FileLoaders.jl")
include("..\\configurations\\MasterConfiguration.jl")
include("..\\distances\\DistanceFunction.jl")
include("..\\instances\\MasterInstance.jl")
include("..\\slave\\ODP_SlaveAlgorithm.jl")
include("..\\net_elements\\DataInfo.jl")
include("..\\net_elements\\IterationResult.jl")
include("..\\utils\\Result.jl")


# Create algorithm master side.
mutable struct ODPMasterAlgorithm
    # MasterInstance
    instance::MasterInstance
    datasetName::String
    # Active points at the current iteration
    currentActivePoints::Int64

    # Heap representing the solution set
    solution::Heap
    # Solving Set
    solvingSet::Set{Point}

    # Set of candidate points
    C::Set{Point}

    # for future implementations
    #port::Int64
    #conntype::String


    # Default costructor
    ODPMasterAlgorithm(cfg::MasterConfiguration) = new(createMasterInstance(cfg),"",0, MinHeap(),Set{Point}(),Set{Point}())
    ODPMasterAlgorithm() = new()
end

# Factory method to create an ODPMasterAlgorithm instance from a configuration
function getMasterAlgorithm(cfg::MasterConfiguration)
    alg = ODPMasterAlgorithm()
    instance = createMasterInstance(cfg)
    alg.instance = instance
    alg.datasetName = ""
    alg.currentActivePoints = 0
    alg.solution = MinHeap()
    alg.solvingSet = Set{Point}()
    alg.C = Set{Point}()
    return alg
end



# Run the SolvingSet algorithm
function runODPAlgorithm(this::ODPMasterAlgorithm, filepath::String)

    # Initializing Result struct
    pltDataset = Array{Vector{Float64},1}()
    pltSolvingSet = Array{Vector{Float64},1}()
    pltSolution = Array{Vector{Float64},1}()
    dist_count = 0

    # Utilities to print current iteration candidate set and current iteration solving set
    iterationC = Array{Vector{Float64},1}()
    itC = []
    iterationS = Array{Vector{Float64},1}()
    itS = []
    iteration_counter = 0

    # Creating SolvingSet and Solution
    this.solvingSet = Set{Point}()
    this.solution = MinHeap(this.instance.n)
    # Init IterationResult
    iterationResult = IterationResult()

    # Lower bound of solution set
    minOut = .0
    # Active points at the current iteration
    currentActivePoints = 0

    # Create ODPSlaveAlgorithm from a path representing the dataset location
    slaveAlg = getSlaveAlgorithm(filepath)


    ### Sending configuration parameters to the Slave ###
    setParam(slaveAlg, this.instance.n, this.instance.k, this.instance.m, this.instance.dist)

    # Filling pltDataset
    for p in slaveAlg.instance.dataset
        push!(pltDataset, p.coords)
    end


    ###### Get dataset info from Slave ###
    datainfo = getDataInfo(slaveAlg)

    # Get dataset name
    datasetName = datainfo.datasetName
    this.datasetName = datainfo.datasetName
    # Get dataset point dimensions
    pointDim = datainfo.pointDim
    this.instance.pointDim = pointDim
    # Get dataset dimension
    datasetSize = datainfo.datasetSize
    currentActivePoints = datasetSize


    # Filling candidate Set with m random samples of dataset
    this.C = initCandidates(slaveAlg)
    #println("Dataset Name: ", string(datasetName), "\nDataset Dimension: ", string(datasetSize), "\nPoint Dimension: ", string(pointDim),"\n\nCurrent active Points = ", string(currentActivePoints))


    while (!isempty(this.C) && currentActivePoints>0)

        # Adding candidate points to the SolvingSet
        union!(this.solvingSet, this.C)

        # Asking the Slave to compute an iteration
        iterationResult = computeIteration(slaveAlg, this.C, minOut)

        # Retrieving data from the IterationResult
        dist_count += iterationResult.distCount
        currentActivePoints = iterationResult.leftActiveData
        #println("\nCurrent active Points = ", string(currentActivePoints))

        # Updating solution heap
        for q in this.C
            updateMax(this.solution,q)
        end

        # Updatinf solution's lower bound
        minOut = top(this.solution.valtree).nn.weight

        # Filling itC and itS for iteration plot
        if iteration_counter in [1,2,3,4]
            for x in this.C
                push!(iterationC, x.coords)
            end
            push!(itC, deepcopy(iterationC))
            setdiff!(iterationC, iterationC)

            for y in this.solvingSet
                push!(iterationS, y.coords)
            end
            push!(itS, deepcopy(iterationS))
            setdiff!(iterationS, iterationS)
        end


        # Extracting nextCand form IterationResult, and setting them as candidate points for the next itersation
        setdiff!(this.C, this.C)
        tmp = extract_all!(iterationResult.nextCand.valtree)
        union!(this.C,tmp)

        #println(iteration_counter)
        iteration_counter +=1

        if isempty(this.C)
            println("TERMINATION CONDITION SATISFIED: No more candiates..")
        end
        if currentActivePoints == 0
            println("TERMINATION CONDITION SATISFIED: No more active points..")
        end
    end


    # Filling pltSolvingSet for plotting
    for x in this.solvingSet
        push!(pltSolvingSet, x.coords)
    end

    # Filling pltSolution for plotting
    for x in extract_all!(this.solution.valtree)
        push!(pltSolution, x.coords)
    end


    res_header = "ODP <"*"D"*", "*string(this.instance.dist)*", "*string(this.instance.n)*", "*string(this.instance.k)*", "*string(this.instance.m)*">"

    res = Result(string(res_header), pltDataset, pltSolvingSet, pltSolution, itC, itS, dist_count, 0)

    return res
end
