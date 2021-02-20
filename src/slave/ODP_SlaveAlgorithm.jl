# Slave part of the Algorithm
using Random

include("..\\elements\\Elements.jl")
include("..\\file_input\\FileLoaders.jl")
include("..\\configurations\\MasterConfiguration.jl")
include("..\\instances\\SlaveInstance.jl")


mutable struct ODPSlaveAlgorithm
    # Slave instance
    instance::SlaveInstance
    # Heap of candidate points sent to the Master for the next iteration
    nextCand::Heap
    # Number of distances calculated in the current iteration
    totDistCount::Int64
    # Number of active points left after the current iteration
    currentActive::Int64

    ODPSlaveAlgorithm() = new()
end

# Factory method to create an ODPSlaveAlgorithm instance
function getSlaveAlgorithm(path::String)
    alg = ODPSlaveAlgorithm()
    alg.instance = createSlaveInstance(path)
    alg.nextCand = MinHeap()
    alg.totDistCount = 0
    alg.currentActive = 0
    return alg
end

# Some dataset info methods
function getDataInfo(this::ODPSlaveAlgorithm)
    info = DataInfo(this.instance.idHeader, getDatasetDimension(this.instance), getPointDimension(this.instance))
    return info
end

function getDataset(this::ODPSlaveAlgorithm)
    return this.instance.dataset
end

# Invoked by the Master to send configuration parameters to the Slave.
# Set ODPSlaveAlgorithm configuration parameters and load dataset.
function setParam(this::ODPSlaveAlgorithm, n::Int64, k::Int64, m::Int64, dist::String)
    this.instance.n = n
    this.instance.k = k
    this.instance.m = m
    this.instance.dist = DistanceFunction(dist)
    # Create a dataset from file in path
    loadDataset(this.instance)
    # Initializing Points NN with Max k elements
    for p in this.instance.dataset
        p.nn = NN(this.instance.k)
        # filling plotDataset
        # push!(plotDataset, p.coords)
    end

    # Retrieve active points
    this.currentActive = getDatasetDimension(this.instance)
end

# Invoked by the Master.
# Chose an initial set of candidate Points, chosen at random from dataset
function initCandidates(this::ODPSlaveAlgorithm)
    count = this.instance.m
    collection = this.instance.dataset
    res = Set{Point}()
    rng = MersenneTwister()
    i = 0

    while i < count
        randElement = rand(rng, collection, 1)[1]
        if !(randElement in res)
            push!(res, randElement)
            i+=1
        end
    end

    return res
end

function cmpCandCand(this::ODPSlaveAlgorithm, C::Set{Point})
    distCount = 0
    tmpC = Set{Point}()
    for el in C
        push!(tmpC, el)
        # remove point from dataset
        setdiff!(this.instance.dataset, [el])
        this.currentActive-=1
    end

    cut = NaN
    for p in C
        for q in tmpC
            dist = 0.
            if p.id == q.id
                cut = q
                distCount+=1
            else
                dist = euclidean(p.coords, q.coords)
                distCount+=1
            end
            updateMin(p.nn, dist)

            if p.id != q.id
                updateMin(q.nn, dist)
            end
        end
        setdiff!(tmpC, [cut])
    end
    return distCount
end

function cmpDatasetCand(this::ODPSlaveAlgorithm, C::Set{Point}, lb::Float64)
    distCount = 0
    d = .0

    for p in this.instance.dataset
        for q in C
            if max(p.nn.weight, q.nn.weight) >= lb
                d = euclidean(p.coords, q.coords)
                distCount+=1

                updateMin(p.nn, d)
                updateMin(q.nn, d)
            end
        end

        if p.active && (p.nn.weight < lb)
            p.active = false
            this.currentActive-=1
        end

        if p.nn.weight > lb
            updateMax(this.nextCand, p)
        end
    end
    return distCount
end

# Invoked by the Master.
# Execute an algorithm iteration. Input: Heap of Candidate Points, solvingSet lower bound
function computeIteration(this::ODPSlaveAlgorithm, C::Set{Point}, lb::Float64)
    distCount = 0

    # First cycle -> Compare Cnod with himself and compute weights
    distCount += cmpCandCand(this, C)

    # Preparing candidate heap for next iteration
    this.nextCand = MinHeap(this.instance.m)

    # Second cycle -> Compare Dataset elements with Cnod, filling nextCand (candidate points for next iteration)
    distCount += cmpDatasetCand(this, C, lb)

    this.totDistCount += distCount

    # Contains all the information sent by the Slave to the Master at the end of an iteration.
    iterationResult = IterationResult(this.nextCand, this.totDistCount, getDatasetDimension(this.instance), this.currentActive, 0)

    return iterationResult
end
