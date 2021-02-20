# Struct that contains all the information sent by the slave to the master at each iteration.
struct IterationResult
    # Heap of possible candidate Points chosen among best
    nextCand::MinHeap
    # Number of distances calculated by the node
    distCount::Int64
    # Data left after the current iteration
    leftData::Int64
    # Active data left after the current iteration
    leftActiveData::Int64
    # Time spent for the current iteration
    time::Int64


    IterationResult() = new(MinHeap(), 0, 0, 0, 0)
    IterationResult(heap::Heap, distCount::Int64, leftData::Int64, leftActiveData::Int64, time::Int64) = new(heap,distCount,leftData,leftActiveData,time)
end
