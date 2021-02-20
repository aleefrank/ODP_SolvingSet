# Struct that represents a series of information sent by the slave to the master
struct DataInfo
    # Name of the dataset
    datasetName::String
    # Dataset cardinality
    datasetSize::Int64
    # Point dimension
    pointDim::Int64

    DataInfo() = new("", 0, 0)
    DataInfo(s::String, ds::Int64, pd::Int64) = new(s, ds, pd)
end
