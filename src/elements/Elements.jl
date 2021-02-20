# Struct representing a point abstraction.
abstract type Element end

include("Heaps.jl")

# mutable struct Candidate{S<:String, C<:Array{Float64,1}, W<:Float64} <: Element
#     id::S
#     coords::C
#     weight::W
# end
# Candidate() = Candidate("", Array{Float64,1}(), 0.)
# Candidate(s::String) = Candidate(s, Array{Float64,1}(), 0.)

# Struct that represents the point, complete with heap of nearby points.
mutable struct Point <: Element
    # Point id
    id::String
    # Point coordinates
    coords::Vector{Float64}
    # Heap of nearest neighbors
    nn::NN
    # If true, the point is marked as active
    active::Bool
end

Point() = Point("", Vector{Float64}(), NN(), true)
Point(k::Int64) = Point("", Vector{Float64}(), NN(k), true)
Point(s::String) = Point(s, Vector{Float64}(), NN(), true)
Point(s::String, coords::Vector{Float64}) = Point(s, coords, NN(), true)
Point(s::String, coords::Vector{Float64}, k::Int64) = Point(s, coords, NN(k), true)

isActive(el::Element) = return el.active
getDimension(this::Element) = return length(this.coords)

# toCandidate(p::Point) = Candidate(p.id, p.coords, p.weight)

# Element compare by weight
Base.isless(a::Element,b::Element) = isless(a.nn.weight,b.nn.weight)


function Base.show(io::IO, obj::Element)
    println(string(obj.id), " | ", string(obj.coords), " | ", string(obj.nn.weight))
end
