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

negel(I1, I2, _, Proofs, [Line, cont, Name]) :-
    conclusion(Proofs, [Line, cont, Name], I2, neg(X)),
    conclusion(Proofs, [Line, cont, Name], I1, X),
    I1>I2.

orel(I1, I2, I3, I4, I5, _, Proofs, [Line, Conclusion, Name]) :-
    box(Proofs, [Line, Conclusion, Name], I2, I3, Box1),
    first_proof(Box1, [_, C1, _]),
    box(Proofs, [Line, Conclusion, Name], I4, I5, Box2),
    first_proof(Box2, [_, C2, _]),
    proof(Proofs, [Line, Conclusion, Name], I1, [_, or(C1, C2), _]),
    last_proof(Box1, [_, Conclusion, _]),
    last_proof(Box2, [_, Conclusion, _]).
