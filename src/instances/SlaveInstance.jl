# Structure representing an instance of a Slave side problem.
# Contains the configuration of the execution parameters and other management parameters.

mutable struct SlaveInstance
    # n parameter
    n::Int64
    # k parameter
    k::Int64
    # m parameter
    m::Int64
    # Distance function, used to calculate distance betweeen 2 points
    dist::DistanceFunction
    # Slave dataset cardinality info
    datasetSize::Int64
    # Set representing the dataset local to the slave
    dataset::Set{Point}
    # Header of the dataset file
    idHeader::String
    # Dataset path, local to the slave
    path::String

    SlaveInstance() = new(0, 0, 0, DistanceFunction(), 0, Set{Point}(), "", "")
end

# Factory method that creates a master instance from a configuration
function createSlaveInstance(path::String)
    slaveInstance = SlaveInstance()
    slaveInstance.idHeader = getFileHeader(path)
    slaveInstance.path = path
    return slaveInstance
end

# Factory method that creates a slave instance
function createSlaveInstance()
    return SlaveInstance()
end

# Add a point to dataset
addPoint(this::SlaveInstance, p::Point) = push!(this.dataset, p)

# Add array of points to dataset
function addPoints(this::SlaveInstance, ps::Vector{Point})
    for p in ps
        addPoint(this,p)
    end
end

getDatasetName(this::SlaveInstance) = return this.idHeader


# Return dataset cardinality
getDatasetDimension(this::SlaveInstance) = return length(this.dataset)

# Return point dimension
getPointDimension(this::SlaveInstance) = return getDimension(first(this.dataset))

function loadDataset(this::SlaveInstance)
    points = NaN
    if getFileExtension(this.path)==".txt"
        points = loadFromDelimTxt(this.path, this.k, this.idHeader)
    end
    addPoints(this, points)
end
