# Structure representing an instance of a Master side problem.
# Contains the configuration of the execution parameters and other management parameters, the final solving set and the final solution

mutable struct MasterInstance
    # n parameter
    n::Int64
    # k parameter
    k::Int64
    # m parameter
    m::Int64
    # Distance function type, used by the Slave to calculate distance betweeen 2 points
    dist::String
    # Slave dataset cardinality info
    datasetSize::Int64
    # Point dimension
    pointDim::Int64
    # Set containing the Solving Set
    solvingSet::Set{Point}
    # Heap containing the final Solution
    solution::Heap

    # Default costructor
    MasterInstance() = new(0, 0, 0, "", 0, 0, Set{Point}(), MinHeap())

    function MasterInstance(n::Int64, k::Int64, m::Int64, dist::String, dataset_size::Int64, solvingSet::Set{Point}, solution::Heap)
        new(n, k, m, dist, datasetSize, pointDim, Set{Point}(), MinHeap())
    end
end

# Factory method that creates a master instance from a configuration
function createMasterInstance(cfg::MasterConfiguration)
    masterInstance = MasterInstance()
    masterInstance.n = cfg.n
    masterInstance.k = cfg.k
    masterInstance.m = cfg.m
    masterInstance.dist = cfg.dist
    return masterInstance
end

# Factory method that creates a master instance
function createMasterInstance()
    return MasterInstance()
end
