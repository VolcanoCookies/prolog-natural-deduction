/**
 * premise(+Prems : list, +Proofs : list, +Proof : proof).
 *
 * Succeeds if Prems contains Proof.
 *
 * @param Prems all our premises.
 * @param Proofs all our proofs.
 * @param Proof the proof we are on currently.
 */
premise(Prems, _, [_, Conclusion, _]) :-
    contains(Prems, Conclusion).

/**
 * premise(+Prems : list, +Proofs : list, +Proof : proof).
 *
 * Succeeds if Proof is in a box, and all proofs before it in the same box are assumptions.
 *
 * @param Prems all our premises.
 * @param Proofs all our proofs.
 * @param Proof the proof we are on currently.
 */
assumption(_, Proofs, [Line, Conclusion, Name]) :-
    box_of(Proofs, [Line, Conclusion, Name], Box),
    not(Box = Proofs),
    until(Box, [Line, Conclusion, Name], Sublist),
    all_match(Sublist, [_, _, assumption]).

/**
 * premise(+I : int, +Prems : list, +Proofs : list, +Proof : proof).
 *
 * Succeeds if the conclusion on the line we are copying is the same as the current conclusion.
 *
 * @param I the line we are copying.
 * @param Prems all our premises.
 * @param Proofs all our proofs.
 * @param Proof the proof we are on currently.
 */
copy(I, _, Proofs, [Line, Conclusion, Name]) :-
    conclusion(Proofs, [Line, Conclusion, Name], I, Conclusion).

andint(I1, I2, _, Proofs, [Line, and(C1, C2), Name] ):-
    proof(Proofs, [Line, and(C1,C2), Name], I1, [_, C1, _]),
    proof(Proofs, [Line, and(C1,C2), Name], I2, [_, C2, _]).

andel1(I1, _, Proofs, [Line, Conclusion, Name]) :-
    proof(Proofs, [Line, Conclusion, Name], I1, [_, and(Conclusion, _), _]).

andel2(I1, _, Proofs, [Line, Conclusion, Name]) :-
    proof(Proofs, [Line, Conclusion, Name], I1, [_, and(_, Conclusion), _]).

orint1(I1, _, Proofs, [Line, or(C1, _), Name]) :-
    conclusion(Proofs, [Line, or(C1, _), Name], I1, C1).

orint2(I1, _, Proofs, [Line, or(_, C1), Name]) :-
    conclusion(Proofs, [Line, or(_, C1), Name], I1, C1).

orel(I1, I2, I3, I4, I5, _, Proofs, [Line, Conclusion, Name]) :-
    box(Proofs, [Line, Conclusion, Name], I2, I3, Box1),
    first_proof(Box1, [_, C1, _]),
    box(Proofs, [Line, Conclusion, Name], I4, I5, Box2),
    first_proof(Box2, [_, C2, _]),
    proof(Proofs, [Line, Conclusion, Name], I1, [_, or(C1, C2), _]),
    last_proof(Box1, [_, Conclusion, _]),
    last_proof(Box2, [_, Conclusion, _]).

impint(I1, I2, _, Proofs, [Line, imp(C1, C2), Name]) :-
    box(Proofs, [Line, imp(C1, C2), Name], I1, I2, Box),
    first_proof(Box, [_, C1, assumption]),
    last_proof(Box, [_, C2, _]).

impel(I1, I2, _, Proofs, [Line, Conclusion, Name]) :-
    conclusion(Proofs, [Line, Conclusion, Name], I1, Requirement),
    conclusion(Proofs, [Line, Conclusion, Name], I2, imp(Requirement, Conclusion)).

negint(I1, I2, _, Proofs, [Line, neg(C1), Name]) :-
    box(Proofs, [Line, neg(C1), Name], I1, I2, Box),
    first_proof(Box, [_, C1, _]),
    last_proof(Box, [_, cont, _]).

negel(I1, I2, _, Proofs, [Line, cont, Name]) :-
    conclusion(Proofs, [Line, cont, Name], I2, neg(X)),
    conclusion(Proofs, [Line, cont, Name], I1, X).

contel(I1, _, Proofs, [Line, Conclusion, Name]):-
    conclusion(Proofs, [Line, Conclusion, Name], I1, cont).

negnegint(I1, _, Proofs, [Line, neg(neg(C1)), Name]) :-
    conclusion(Proofs, [Line, neg(neg(C1)), Name], I1, C1).

negnegel(I1, _, Proofs, [Line, C1, Name]) :-
    conclusion(Proofs, [Line, C1, Name], I1, neg(neg(C1))).

mt(I1, I2, _, Proofs, [Line, neg(C1), Name]) :-
    conclusion(Proofs, [Line, neg(C1), Name], I1, imp(C1,C2)),
    conclusion(Proofs, [Line, neg(C1), Name], I2, neg(C2)).

pbc(I1, I2, _, Proofs, [Line, C1, Name]) :-
    box(Proofs, [Line, C1, Name], I1, I2, Box),
    first_proof(Box, [_, neg(C1), _]),
    last_proof(Box, [_, cont, _]).

lem(_, _, [_, or(C1, neg(C1)), _]).
