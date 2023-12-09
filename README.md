# SymplecticOctics
Data for the verification of proofs of the paper *Algebraic and symplectic curves of degree 8*. It contains the following files:
- `ConstructionSymplecticGroup`.
- `OcticInvolution`. Computation of the curves invariant by an involution. There are several auxiliary files in `files2`.
- `CheckCurveInvolution`. Check the singularity types for the curve computed in the previous file.
- `OcticAuto3`. Computation of the curves invariant by an automorphism of order 3.There are several auxiliary files in `files3`.
- `CheckCurveAuto3`. Check the singularity types for the curve computed in the previous file.
- `FundamentalGroupInvolution` and `Alternative2`. Computations of the fundamental group of the complement of the curves invariant by an involution.
- `FundamentalGroupAuto3` and `Alternative3`. Computations of the fundamental group of the complement of the curves invariant by automorphism of order 3.

  There is also a folder `functions` with auxiliary functions.

  Run [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/enriqueartal/SymplecticOctics/packages1/) to execute the notebooks (`Alternative2` and `Alternative3` need tools not yet included in this version of `Sagemath`).
