# Struct representing the distance function used by the algorithm
struct DistanceFunction
    # String representing the distance type
    type::String

    # Default costructor
    DistanceFunction() = new("euclidean")
    DistanceFunction(s::String) = new(s)
end

# Used by the Slave to calculate distance betweeen 2 points' coordinates
function calculateDistance(f::DistanceFunction, a::Vector, b::Vector)
    if f.type=="sqeuclidean"
        return sqeuclidean(a,b)
    else
        return euclidean(a,b)
    end
end
