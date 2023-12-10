def reducir(v):
    """
    For a non-zero vector, it returns a
    proportional vector where the first
    non-zero coordinate is 1.
    """
    a, b, c = v
    if a != 0:
        return v / a
    if b != 0:
        return v / b
    return v / c

def reducir3(v):
    """
    For a non-zero vector, it returns a
    proportional vector where the last
    non-zero coordinate is 1.
    """
    a, b, c = v
    if c != 0:
        return v / c
    if b != 0:
        return v / b
    return v / a

def cambio(A, f):
    """
    The matrix ``A`` represents a projective transformation
    and ``f`` is a homogeneous polynomial. It returns the
    pull-back of ``f`` by the transformation.
    """
    R = f.parent()
    v = A*vector(R.gens())
    sb = {vr: xa for vr, xa in zip(R.gens(), v)}
    g = f.subs(sb)
    return g

def proy(lista):
    """
    For a list ``lista`` of vectors defining
    a projective reference system it returns
    a matrix defining a projective transformation
    which sends the canonical reference system
    to ``lista``.
    """
    V1, V2, V3, V4 = lista
    cuerpo = V1.base_ring()
    H = cuerpo^3
    H4 = H.subspace_with_basis(lista[:3])
    v = H4.coordinate_vector(V4)
    return Matrix(lista[:3]).transpose() * diagonal_matrix(v)
    
def conica(R1, lst):
    """
    Given a ring ``R1`` in three variables and a list
    ``lst`` of 5 points in *general position*, it gives
    the equation of the unique conic through these points.
    """
    R0 = R1.base_ring()
    x, y, z = R1.gens()
    Rb = PolynomialRing(R0, 'b', 6)
    Rb1 = PolynomialRing(R0, R1.gens() + Rb.gens())
    VM = vector([x^i * y^j * z^(2 - i - j) for i in range(3) for j in range(3 - i)])
    VC = vector(Rb.gens())
    q = VC * VM.change_ring(Rb1)
    A = [q(x=V[0], y=V[1], z=V[2]) for V in lst]
    M = Matrix([[R0(_.coefficient({vr:1})) for vr in Rb1.gens()[3:]] for  _ in A])
    W = M.transpose().kernel().basis()[0]
    W = vector([R1(a) for a in W])
    return VM * W.change_ring(R1) 