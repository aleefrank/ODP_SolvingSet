using DelimitedFiles

# Some file utils
function getFileExtension(filename)
    return filename[findlast(isequal('.'),filename):end]
end
function getFileHeader(filename)
    return filename[findlast(isequal('\\'),filename)+1:findlast(isequal('.'),filename)-1]
end

# Loads dataset points from a .txt file from the given path.
# Returns an array of points representing the dataset
function loadFromDelimTxt(filepath::String, k::Int64, idHeader::String)
    id = 0
    arrayPoints = Vector{Point}()
    io = open(filepath, "r")
    result = readdlm(filepath, '\t', Float64, '\n')

    for i in 1:size(result,1)
        push!(arrayPoints,Point(string(idHeader,id), result[i,:], k))
        id+=1
    end
    close(io)
    return arrayPoints
end

# Generate a .txt file containing a dataset starting from a matrix representing points. Used when input dataset is not provided
function generatePoints(filepath, matr)
    io = open(filepath, "w")

    for row in eachrow(matr)
        write(io, string(row[1], "\t", row[2]), '\n')
    end
    close(io)
end
