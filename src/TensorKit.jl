# TensorKit.jl
#
# Main file for module TensorKit, a Julia package for working with
# with tensors, tensor operations and tensor factorizations

module TensorKit

# Exports
#---------
# Types:
export VectorSpace, Field, ElementarySpace, InnerProductSpace, EuclideanSpace # abstract vector spaces
export ComplexSpace, CartesianSpace, GeneralSpace, RepresentationSpace, ZNSpace # concrete spaces
export CompositeSpace, ProductSpace # composite spaces
export Sector, Irrep
export Abelian, SimpleNonAbelian, DegenerateNonAbelian, SymmetricBraiding, Bosonic, Fermionic, Anyonic # sector properties
export Parity, ZNIrrep, U1Irrep, SU2Irrep, FermionParity, FermionNumber, FermionSpin # specific sectors
export FusionTree
export IndexSpace, TensorSpace, AbstractTensorMap, AbstractTensor, TensorMap, Tensor # tensors and tensor properties
export TruncationScheme
export SpaceMismatch, SectorMismatch, IndexError # error types

# general vector space methods
export space, dual, dim, dims
# methods for sectors and properties thereof
export sectortype, fusiontype, braidingtype, sectors, Nsymbol, Fsymbol, Rsymbol, Bsymbol, frobeniusschur
export Trivial, ZNSpace, SU2Irrep, U1Irrep # Fermion
export fusiontrees, braid, repartition

# some unicode
export ⊕, ⊗, ×, ℂ, ℝ, ←, →
export ℤ₂, ℤ₃, ℤ₄, U₁, SU₂
export RepresentationSpace, ℤ₂Space, ℤ₃Space, ℤ₄Space, U₁Space, SU₂Space

# tensor operations: To be done
# export tensorcopy, tensoradd, tensortrace, tensorcontract, tensorproduct
# export tensorcopy!, tensoradd!, tensortrace!, tensorcontract!, tensorproduct!

# tensor factorizations
export leftorth, rightorth, leftnull, rightnull, leftorth!, rightorth!, leftnull!, rightnull!, svd!
export permuteind, fuseind, splitind, permuteind!, fuseind!, splitind!

# truncation schemes
export notrunc, truncerr, truncdim, truncspace

# tensor maps
export domain, codomain

# Imports
#---------
using Base: tuple_type_head, tuple_type_tail, tuple_type_cons, tail, front, setindex
using Base: ImmutableDict

if VERSION <= v"0.6.0"
    include("auxiliary/product.jl")
    using .Product.product
else
    using Base: Iterators.product
end

if VERSION < v"0.7.0-DEV.843"
    Base.@pure Base.Val(N) = Val{N}
end

if VERSION < v"0.7.0"
    Base.eye(s::Tuple{Integer,Integer}) = eye(s...)
    Base.eye(::Type{T}, s::Tuple{Integer,Integer}) where {T} = eye(T, s...)
end

if VERSION < v"0.7.0-DEV.1415"
    const adjoint = Base.ctranspose
    const adjoint! = Base.ctranspose!
else
    import Base: adjoint, adjoint!
end

import TensorOperations

# Auxiliary files
#-----------------
include("auxiliary/auxiliary.jl")
include("auxiliary/linalg.jl")
include("auxiliary/stridedview.jl")

# Exception types:
#------------------
abstract type TensorException <: Exception end

# Exception type for all errors related to sector mismatch
struct SectorMismatch{S<:Union{Void,String}} <: TensorException
    message::S
end
SectorMismatch()=SectorMismatch{Void}(nothing)
Base.show(io::IO, ::SectorMismatch{Void}) = print(io, "SectorMismatch()")

# Exception type for all errors related to vector space mismatch
struct SpaceMismatch{S<:Union{Void,String}} <: TensorException
    message::S
end
SpaceMismatch()=SpaceMismatch{Void}(nothing)
Base.show(io::IO, ::SpaceMismatch{Void}) = print(io, "SpaceMismatch()")

# Exception type for all errors related to invalid tensor index specification.
struct IndexError{S<:Union{Void,String}} <: TensorException
    message::S
end
IndexError()=IndexError{Void}(nothing)
Base.show(io::IO, ::IndexError{Void}) = print(io, "IndexError()")

# Tensor product operator
#-------------------------
⊗(a, b, c, d...)=⊗(a, ⊗(b, c, d...))

# Definitions and methods for superselection sectors (quantum numbers)
#----------------------------------------------------------------------
include("sectors/sectors.jl")

# Definitions and methods for vector spaces
#-------------------------------------------
include("spaces/vectorspaces.jl")

# Constructing and manipulating fusion trees and iterators thereof
#------------------------------------------------------------------
include("fusiontrees/fusiontrees.jl")

# # Definitions and methods for tensors
# #-------------------------------------
# import TensorOperations
# intentionally shadow original TensorOperation methods for StridedArray objects

# define truncation schemes for tensors
include("tensors/truncation.jl")
# general definitions
include("tensors/abstracttensor.jl")
include("tensors/tensor.jl")
include("tensors/adjoint.jl")

end
