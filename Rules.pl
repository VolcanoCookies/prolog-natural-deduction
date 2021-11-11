premise(Prems, _, [_, Conclusion, _]) :-
    contains(Prems, Conclusion).

impel(I1, I2, _, Proofs, [Line, Conclusion, Name]) :-
    conclusion(Proofs, [Line, Conclusion, Name], I1, Requirement),
    conclusion(Proofs, [Line, Conclusion, Name], I2, imp(Requirement, Conclusion)).

assumption(_, _, _) :-
    nb_getval(depth, Depth),
    Depth>0.

copy(I, _, _, _, Conclusion) :-
    conclusion(I, Conclusion).

impint(I1, I2, _, Proofs, Line, imp(C1, C2)) :-
    deep_contains(Proofs, [[I1, C1, _]|T]),
    I1<I2,
    I2<Line,
    Line is I2+1,
    last([[I1, C1, _]|T], [I2, C2, _]).

negel(I1, I2, _, Proofs, Proof) :-
    trace,
    conclusion(Proofs, Proof, I2, neg(X)),
    conclusion(Proofs, Proof, I1, X),
    I1>I2.

orel(I1, I2, I3, I4, I5, _, Proofs, _, Conclusion) :-
    I2 is I1+1,
    I4 is I3+1,
    I1<I2,
    I2<I3,
    I3<I4,
    proof(Proofs, I1, or(X, Y)),

    conclusion(I1, or(X, Y)),
    deep_contains(Proofs, [[I2, X, assumption]|Next1]),
    last(Next1, [I3, cont, _]),
    deep_contains(Proofs, [[I4, Y, assumption]|Next2]),
    last(Next2, [I5, cont, _]).
