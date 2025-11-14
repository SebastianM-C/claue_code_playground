#!/usr/bin/env julia

# Try to load packages from their downloaded locations
# This bypasses the normal Pkg system

println("Julia version: ", VERSION)
println("Testing symbolic packages...\n")

# Find the latest version of each package
function find_pkg_path(pkgname)
    pkg_dir = joinpath(homedir(), ".julia", "packages", pkgname)
    if isdir(pkg_dir)
        versions = readdir(pkg_dir)
        if !isempty(versions)
            return joinpath(pkg_dir, versions[end])
        end
    end
    return nothing
end

# Try to set up the environment to load packages
symutils_path = find_pkg_path("SymbolicUtils")
symbolics_path = find_pkg_path("Symbolics")
mtk_path = find_pkg_path("ModelingToolkit")

println("Found package paths:")
println("  SymbolicUtils: ", symutils_path)
println("  Symbolics: ", symbolics_path)
println("  ModelingToolkit: ", mtk_path)
println()

# Try using the depot packages (they should work if dependencies are met)
println("Attempting to load packages...")

try
    println("\n1. Testing SymbolicUtils:")
    using SymbolicUtils
    @variables x y
    expr = x + y
    println("   Created expression: ", expr)
    println("   ✓ SymbolicUtils loaded successfully!")
catch e
    println("   ✗ SymbolicUtils failed: ", e)
end

try
    println("\n2. Testing Symbolics:")
    using Symbolics
    @variables t α
    expr = α * t^2
    println("   Created expression: ", expr)
    println("   ✓ Symbolics loaded successfully!")
catch e
    println("   ✗ Symbolics failed: ", e)
end

try
    println("\n3. Testing ModelingToolkit:")
    using ModelingToolkit
    println("   ✓ ModelingToolkit loaded successfully!")
catch e
    println("   ✗ ModelingToolkit failed: ", e)
end
