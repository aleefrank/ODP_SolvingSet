using DataStructures

# Struct representing a heap abstraction.
abstract type Heap end

# Struct representing the heap of nearest neighbors of a Point
mutable struct NN <: Heap
    # Ordered tree-like data structure, used to represent in a decreasing order the distances of the neighbours of the Point
    valtree::BinaryMaxHeap{Float64}
    # Maximum capacity of the heap
    capacity::Int64
    # Weight of the point, as the sum of the distances between the point and his neighbourhood
    weight::Float64
    function NN(k::T) where T<:Int64
        if k < 0
            error("Invalid cardinality (< 0)")
        end
        new(BinaryMaxHeap{Float64}(),k, 0.)
    end

    function NN()
        new(BinaryMaxHeap{Float64}(),0, 0.)
    end
end

function Base.show(io::IO, obj::NN)
    print(string(obj.valtree))
end


# Data structure representing the solution set
mutable struct MinHeap <: Heap
    # Ordered tree-like data structure, sorted by increasing point weight
    valtree::BinaryMinHeap
    # Minimum capacity of the heap
    capacity::Int64

    # Init MinHeap with min capacity = n
    function MinHeap(n::N) where {N<:Int64}
        if n < 0
            error("Invalid cardinality (< 0)")
        end
        new(BinaryMinHeap{Point}(),n)
    end
    function MinHeap()
        new(BinaryMinHeap{Point}(),0)
    end
end

function Base.show(io::IO, obj::Heap)
    print(string(obj.valtree))
end

# Insert the input distance into NN if the heap is not full, or if this distance is lower than the first element of the tree. The total weight is updated accordingly.
function updateMin(h::NN, d::Float64)
    if (length(h.valtree) < h.capacity)
        push!(h.valtree, d)
        h.weight += d
        return
    elseif d < top(h.valtree)
        h.weight -= pop!(h.valtree)
        push!(h.valtree,d)
        h.weight += d
        return
    end
end

# Insert the input element into MinHeap, if the heap is not full, or if the element’s weight is higher than the first element of the tree.
function updateMax(h::MinHeap, el::Element)
    if (length(h.valtree) < h.capacity)
        push!(h.valtree, el)
        return
    elseif el.nn.weight > top(h.valtree).nn.weight
        pop!(h.valtree)
        push!(h.valtree, el)
        return
    end
end

# get the first element of MinHeap
function getMin(h::MinHeap)
    return isempty(h.valtree) ? 0. : top(h.valtree).nn.weight
end
