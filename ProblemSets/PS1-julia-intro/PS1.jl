#=
Adam Visokay
PS1
08/28/2020
=#

# load packages
using JLD2, Random, LinearAlgebra, Statistics, CSV,
DataFrames, FreqTables, Distributions, Kronecker, TexTables

# QUESTION 1

# (l) wrap all of the code for q1 into a function called q1().
function q1()
    # Set random seed
    Random.seed!(1234);

    # Create Normal and Uniform Distributions U[μ = -5, σ=10] and N[μ = -2, σ=15]
    u = Uniform(-5.0, 10.0);
    n = Normal(-2.0, 15.0);

    # (a) Initialize the following matrices:
    # (i) A dim[10x7] with Uniform Distribution
    A = rand(u, 10,7);
    # (ii) B dim[10x7] with Normal Distribution
    B = rand(n, 10,7);
    # (iii) C dim[5x7] with first 5 rows and 5 columns of A and last two columns
    # and first 5 rows of B
    C = [A[1:5, 1:5] B[1:5, 6:7]];
    # (iv) D dim[10x7] where Di,j = Ai,j if Ai,j less or equal to 0, or 0 otherwise
    D = [(x > 0) ? 0 : x for x in A];

    # (b) List number of elements of A
    length(A)

    # (c) List the number of unique elements of D
    length(unique(D))

    # (d) Use reshape() to create a new matrix, E, which is the 'vec' operator^2
    # applied to B. Is there an easier way to do this?
    E = reshape([x^2 for x in reshape(B, (length(B), 1))], (10,7));
    # an easier way might be
    E = B.^2;

    # (e) Create new array called F which is 3D and contains A in the first
    # column of the third dimension and B in the second column of the third dimension
    F = cat(A, B, dims = 3);

    # (f) Use the permutedims() function to twist F into F2x10x7 instead of F10x7x2
    F = permutedims(F, (3, 1, 2));

    # (g) Create new matrix G which is the Kroneger Product of B ⊗ C. What happens when
    # you try C ⊗ F?
    G = B ⊗ C;
    # C ⊗ F raises a MethodError: no method matching

    # (h) Save matrices A,B,C,D,E,F and G as a .jld file named matrixpractice
    #@save "matrixpractice.jld" A B C D E F G

    # (i) Save only the matrices A, B, C and D as a .jld file called firstmatrix
    #@save "firstmatrix.jld" A B C D

    # (j) Export C as a .csv file called Cmatrix
    C = convert(DataFrame, C)
    CSV.write("C:\\Users\\Adam\\Desktop\\Econ 6434 Structural Modeling\\fall-2020\\ProblemSets\\PS1-julia-intro\\Cmatrix", C)

    # (k) Export D as a tab-delimited .dat file called Dmatrix
    D = convert(DataFrame, D)
    CSV.write("C:\\Users\\Adam\\Desktop\\Econ 6434 Structural Modeling\\fall-2020\\ProblemSets\\PS1-julia-intro\\Dmatrix.dat", D)

    A, B, C, D = q1()
end

# QUESTION 2
# (a) Write a loop or comprehension that will compute the element-wise product
# of A and B named AB. Create matrix AB2 that accomplishes this task without looping.
AB2 = A.*B

# (b) Write a loop that creates a column vector called Cprime which contains only
# the elements of C that are between -5 and 5 (inclusive). Create Cprime2 doing the same without a loop.

Cprime = []
for i in convert(Matrix, C)
    if -5 <= i <= 5
        append!(Cprime, i)
    end
end
Cprime2 = [x for x in convert(Matrix, C) if -5 <= x <= 5]

#= (c) Using loops or comprehensions, create 3D array called X that is of dimensions
 [15169 x 6 x 5]. For all t, the columns of X should be (in order):
X = ones(10)

=#

X = nothing





# QUESTION 2
# reset workspace and load nlsw88.csv as a dataframe and save the result as nlsw88.jld.
function q3()
    # df = CSV.read("C:\\Users\\Adam\\Desktop\\Econ 6434 Structural Modeling\\fall-2020\\ProblemSets\\PS1-julia-intro\\nlsw88.csv")
    # @save "nlsw88.jld" df

    # (b) What percentage of the sample has never been married? What percentage are college grads?
    println(sum(x -> x == 1, df[!, :never_married]) / length(df[!, :never_married]) * 100, " percent of the sample has never been married.")
    println(sum(x -> x == 1, df[!, :collgrad]) / length(df[!, :collgrad]) * 100, " percent of the sample are college graduates.")

    # (c) use the tabulate command to report what percentage of the sample is in each race category.
    tabulate(df, :race)

    # (d) create a matrix called summarystats from describe function. How many grade observations are missing?
    summarystats = convert(Matrix, describe(df))

    # (e) show the joint distribution of industry and occupation using a cross-tabulation
    freqtable(df, :industry, :occupation)

    # (f) Tabulate the mean wage over industry and occupation categories.
    by(df, :industry, df -> mean(df.wage))
    by(df, :occupation, df -> mean(df.wage))

    # (g) Wrap in function called q3()
    q3()
end

# QUESTION 4
#(h) wrap function definition around the code for this problem and name it q4()
function q4()
    # (a) load firstmatrix.jld
    @load "firstmatrix.jld"

    # (b) Write a function matrixops that takes as inputs two matrices, A and B, and has 3 outputs:

    function matrixops(A, B)
        # This function takes in two matrices of the same size and returns the following:
        #  (i) element-by-element product of inputs, (ii) product of A'B, (iii) the sum of all elements of A + B

        #(e) if statement to evaluate if the inputs are of equal size
        if size(A) != size(B)
            error("inputs must have same size.")
        end

        return A .* B, A'B, sum(A + B)
    end

    # (d) Evaluate matrixops() using A and B from question (a) of problem 1.
    matrixops(A, B)

    # (f) Evaluate matrixops.m using C and D from question (a) of problem 1. What happens?
    matrixops.m(C, D)
    # error "type #matrixops has no field m"

    # (g) Evaluate matrixops using ttl_exp and wage from nlsw88.jld.
    convert(Array, df.ttl_exp)
    convert(Array, df.wage)

    matrixops(df.ttl_exp, df.wage)

    q4()
end
