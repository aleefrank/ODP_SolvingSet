using Plots

# Some plots utils, multiple dispatch is used.
function plotSets(title, set1, labels)
    x1 = Vector{Float64}()
    y1 = Vector{Float64}()
    for el in set1
        push!(x1, el[1])
        push!(y1, el[2])
    end
return scatter([x1], [y1], title=title, label = labels[1], legend=:outertopright, reuse = false)
end

function plotSets(title, set1, set2, labels)
    x1 = Vector{Float64}()
    y1 = Vector{Float64}()
    for el in set1
        push!(x1, el[1])
        push!(y1, el[2])
    end

    x2 = Vector{Float64}()
    y2 = Vector{Float64}()
    for el in set2
        push!(x2, el[1])
        push!(y2, el[2])
    end

    return scatter([x1,x2], [y1,y2], title=title, marker=[:o :square], c=[:skyblue2 :orange], label = [labels[1] labels[2]],legend=:outertopright, reuse = false)
end

function plotSets(title, set1, set2, set3, labels)
    x1 = Vector{Float64}()
    y1 = Vector{Float64}()
    for el in set1
        push!(x1, el[1])
        push!(y1, el[2])
    end

    x2 = Vector{Float64}()
    y2 = Vector{Float64}()
    for el in set2
        push!(x2, el[1])
        push!(y2, el[2])
    end

    x3 = Vector{Float64}()
    y3 = Vector{Float64}()
    for el in set3
        push!(x3, el[1])
        push!(y3, el[2])
    end

    return scatter([x1,x2,x3], [y1,y2,y3], title = title, marker=[:o :o :square], c=[:lightgray :orange :green], label = [labels[1] labels[2] labels[3]], legend=:outertopright, reuse = false)
end
