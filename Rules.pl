premise(Prems, Proofs, [Line, Conclusion, Name]) :-
    contains(Proofs, [Line, Conclusion, Name]),
    contains(Prems, Conclusion).

impel(I1, I2, _, Proofs, [Line, Conclusion, Name]) :-
    conclusion(Proofs, [Line, Conclusion, Name], I1, Requirement),
    conclusion(Proofs, [Line, Conclusion, Name], I2, imp(Requirement, Conclusion)).

assumption(_, Proofs, [Line, Conclusion, Name]) :-
    box_of(Proofs, [Line, Conclusion, Name], Box),
    not(Box = Proofs),
    until(Box, [Line, Conclusion, Name], Sublist),
    all_match(Sublist, [_, _, assumption]).

copy(I, _, Proofs, [Line, Conclusion, Name]) :-
    conclusion(Proofs, [Line, Conclusion, Name], I, Conclusion).

impint(I1, I2, _, Proofs, [Line, imp(C1, C2), Name]) :-
    box(Proofs, [Line, imp(C1, C2), Name], I1, I2, Box),
    first_proof(Box, [_, C1, _]),
    last_proof(Box, [_, C2, _]).

negel(I1, I2, _, Proofs, [Line, cont, Name]) :-
    conclusion(Proofs, [Line, cont, Name], I2, neg(X)),
    conclusion(Proofs, [Line, cont, Name], I1, X).

negint(I1,I2,_,Proofs, [Line,neg(C1),Name]) :-
    box(Proofs, [Line,neg(C1),Name],I1,I2,Box),
    first_proof(Box,[_,C1,_]),
    last_proof(Box,[_,cont,_]).
    
negnegel(I1,_,Proofs, [Line,C1,Name]) :-
    conclusion(Proofs, [Line,C1,Name],I1,neg(neg(C1))).
    
negnegint(I1,_,Proofs, [Line,neg(neg(C1)),Name]) :-
    conclusion(Proofs, [Line,neg(neg(C1)),Name], I1,C1).

orel(I1, I2, I3, I4, I5, _, Proofs, [Line, Conclusion, Name]) :-
    box(Proofs, [Line, Conclusion, Name], I2, I3, Box1),
    first_proof(Box1, [_, C1, _]),
    box(Proofs, [Line, Conclusion, Name], I4, I5, Box2),
    first_proof(Box2, [_, C2, _]),
    proof(Proofs, [Line, Conclusion, Name], I1, [_, or(C1, C2), _]),
    last_proof(Box1, [_, Conclusion, _]),
    last_proof(Box2, [_, Conclusion, _]).

andint(I1, I2, _, Proofs, [Line, and(C1,C2), Name] ):-
    proof(Proofs, [Line, and(C1,C2), Name], I1, [_, C1, _]),
    proof(Proofs, [Line, and(C1,C2), Name], I2, [_, C2, _]).
    
pbc(I1, I2, _, Proofs, [Line, C1, Name]) :-
    box(Proofs, [Line, C1, Name], I1, I2, Box),
    first_proof(Box, [_, neg(C1), _]),
    last_proof(Box, [_, cont, _]).

   
andel1(I1, _, Proofs, [Line, Conclusion, Name]) :-
    proof(Proofs, [Line, Conclusion, Name], I1, [_, and(Conclusion, _), _]).
   
andel2(I1, _, Proofs, [Line, Conclusion, Name]) :-
    proof(Proofs, [Line, Conclusion, Name], I1, [_, and(_, Conclusion), _]).
    

lem(_, _, [_, or(C1, neg(C1)), _]).
=======

contel(I1,_,Proofs,[Line,Conclusion,Name]):-
    conclusion(Proofs,[Line,Conclusion,Name],I1,cont).


mt(I1, I2, _, Proofs, [Line, neg(C1), Name]) :-
    conclusion(Proofs, [Line, neg(C1), Name], I1, imp(C1,C2)),
    conclusion(Proofs, [Line, neg(C1), Name], I2, neg(C2)).
