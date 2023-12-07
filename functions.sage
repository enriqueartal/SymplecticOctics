def lvr(lst):
    """
    Given a list of polynomials, it returns the list of involved variables.
    """
    res = ()
    for _ in lst:
        res += _.variables()
    res = list(Set(res))
    res.sort()
    return res


def dct(i, vr, L):
    """
    Given a position ``i``, a variable ``vr``, and a list ``L`` of polynomials,
    it returns a tuple with the degree ``d`` of the polynomial ``L[i]`` in
    ``vr``, the degree of the coefficient of ``L[i]`` in ``vr^d``, its number
    of terms, and the number of remaining terms.
    """
    p = L[i]
    d = p.degree(vr)
    if d == 0:
        return None
    q = p.coefficient({vr: d})
    d1 = q.degree()
    nq = q.number_of_terms()
    np = p.number_of_terms() - nq
    return (d, d1, np, nq)


def pasoivar(L0, i, vr):
    """
    Given a a list ``L0`` of polynomials, a position ``i``,
    and a variable ``vr``, it computes de resultants of ``L0[i]`` with the
    other polynomials in the list with respect to ``vr``. It checks if these
    resultants contains a non-zero constant.
    """
    p = L0[i]
    La = L0[:i] + L0[i + 1:]
    L1 = [p.resultant(q, vr) for q in La]
    L1 = [_ for _ in L1 if _ != 0]
    if [p for p in L1 if p in QQ and p != 0]:
        print("No solution")
        return None
    else:
        print("Number of variables: ", len(lvr(L1)))
    return L1


def reducir_paso(Ls, i, vr):
    """
    Given a a list ``Ls`` of lists of polynomials, a position ``i``,
    and a variable ``vr``, it returns a news list of lists of polynomials
    with an additional list ``L1a`` and the list ``Lf`` of factors
    of the polynomials in ``L1a``.
    """
    print(dct(i, vr, Ls[-1]))
    L1 = pasoivar(Ls[-1], i, vr)
    if L1 is None:
        return None
    mcd = gcd(L1)
    mcdf = [_[0] for _ in mcd.factor()]
    L1a = []
    for p in L1:
        p = R0(p / mcd)
        for q in mcdf:
            while p / q in R0:
                p = R0(p / q)
        L1a.append(p)
    Ls.append(L1a)
    print("Number of equations", len(L1a))
    Lf = [[_[0] for _ in a.factor()] for a in L1a]
    if 0 in [len(_) for _ in Lf]:
        print("No solution")
        return None
    nf = list(Set([len(_) for _ in Lf]))
    for j, fcs in enumerate(Lf):
        if len(fcs) > 1:
            for k, p in enumerate(fcs):
                nt = p.number_of_terms()
                if nt < 4:
                    print(j, k, p)
                else:
                    print(j, k, 'number of terms: ', nt)
    return (Ls, L1a, Lf)


def nuevos(Ls, Lf):
    """
    Given a a list ``Ls`` of lists of polynomials and the list ``Lf``
    of factors of the last list of ``Ls``, it gives several lists
    of lists such that the last one contains only one factor. This is done
    to follow a tree of solutions.
    """
    res = []
    A = [list(range(len(u0))) for u0 in Lf]
    for v in cartesian_product(A):
        v0 = list(v)
        L = [_ for _ in Ls]
        L[-1] = [Lf[i][-1 - v0[i]] for i in range(len(Lf))]
        res.append(L)
    return res


@parallel
def rslt(p,q,vr):
    """
    A function to compute resultants in parallel
    """
    return p.resultant(q,vr)