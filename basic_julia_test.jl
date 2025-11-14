#!/usr/bin/env julia

println("=" ^ 60)
println("Julia Basic Functionality Test")
println("=" ^ 60)
println()

println("Julia Version: ", VERSION)
println("Platform: ", Sys.MACHINE)
println("Number of threads: ", Threads.nthreads())
println()

println("Testing core Julia functionality...")
println()

# Test 1: Basic math
println("1. Basic arithmetic:")
result = 2 + 2
println("   2 + 2 = ", result)
@assert result == 4
println("   ✓ Pass")
println()

# Test 2: Arrays and linear algebra
println("2. Array operations:")
A = [1 2; 3 4]
b = [5, 6]
result = A * b
println("   ", A, " * ", b, " = ", result)
@assert result == [17, 39]
println("   ✓ Pass")
println()

# Test 3: Functions and closures
println("3. Functions:")
function fibonacci(n)
    n <= 1 && return n
    return fibonacci(n-1) + fibonacci(n-2)
end
result = fibonacci(10)
println("   fibonacci(10) = ", result)
@assert result == 55
println("   ✓ Pass")
println()

# Test 4: Types and structs
println("4. Custom types:")
struct Point{T}
    x::T
    y::T
end
p = Point(3.0, 4.0)
distance = sqrt(p.x^2 + p.y^2)
println("   Point(3.0, 4.0) distance from origin = ", distance)
@assert distance == 5.0
println("   ✓ Pass")
println()

# Test 5: Metaprogramming
println("5. Metaprogramming:")
expr = :(x + y)
println("   Expression: ", expr)
println("   Type: ", typeof(expr))
@assert expr.head == :call
println("   ✓ Pass")
println()

# Test 6: Standard library
println("6. Standard library (Statistics):")
using Statistics
data = [1, 2, 3, 4, 5]
μ = mean(data)
σ = std(data)
println("   Data: ", data)
println("   Mean: ", μ)
println("   Std: ", round(σ, digits=4))
@assert μ == 3.0
println("   ✓ Pass")
println()

# Test 7: Broadcasting
println("7. Broadcasting:")
v = [1, 2, 3, 4, 5]
result = v .^ 2
println("   ", v, " .^ 2 = ", result)
@assert result == [1, 4, 9, 16, 25]
println("   ✓ Pass")
println()

# Test 8: Multiple dispatch
println("8. Multiple dispatch:")
area(r::Real) = π * r^2
area(w::Real, h::Real) = w * h
circle_area = area(5.0)
rectangle_area = area(4.0, 6.0)
println("   Circle(r=5): ", round(circle_area, digits=2))
println("   Rectangle(4×6): ", rectangle_area)
@assert round(circle_area) == 79
@assert rectangle_area == 24
println("   ✓ Pass")
println()

println("=" ^ 60)
println("All basic tests passed! Julia is fully functional.")
println("=" ^ 60)
