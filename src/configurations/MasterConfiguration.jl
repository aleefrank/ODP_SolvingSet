# Defines the configuration of the Master.
# used in the creation of the master side algorithm.
# Allows the definition of algorithm parameters such as n, m, k, distance function

struct MasterConfiguration
    n::Int64
    k::Int64
    m::Int64

    # Distance function type, used by the Slave to calculate distance betweeen 2 points
    dist::String
    # report::Bool

    # for future implementations
    #port::Int64
    #conntype::String

    function MasterConfiguration(n::T, k::T, m::T, dist::S) where {T<:Int64, S<:String}
        new(n, k, m, dist)
    end
    MasterConfiguration() = new()
end
