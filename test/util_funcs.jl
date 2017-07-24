### ================================== ###

function get_lr_bounds(sp_mat)

    # M = size(sp_mat, 2)

    # l_bound = [zeros(Int,2) for i in 1:M]
    # h_bound = [zeros(Int,2) for i in 1:M]
    l_bound = Vector{Int}[]
    h_bound = Vector{Int}[]

    for i in 1:size(sp_mat, 2)

        # v_range = nzrange(sp_mat, i)

        r_vals = rowvals(sp_mat)[nzrange(sp_mat, i)]

        if isempty(r_vals) == false

            x = collect(extrema(r_vals))

            push!(l_bound, [x[1], i])
            push!(h_bound, [x[2], i])
        end

        # l_bound[i] = [x[1], i]
        # h_bound[i] = [x[2], i]

    end

    return l_bound, h_bound

end

### ================================== ###

function get_ud_bounds(sp_mat)

    l_bound = Vector{Int}[]
    h_bound = Vector{Int}[]

    for i in 1:size(sp_mat, 2)

        r_vals = rowvals(sp_mat)[nzrange(sp_mat, i)]

        if isempty(r_vals) == false

            x = collect(extrema(r_vals))

            push!(l_bound, [i, x[1]])
            push!(h_bound, [i, x[2]])
        end

    end

    return l_bound, h_bound

end
