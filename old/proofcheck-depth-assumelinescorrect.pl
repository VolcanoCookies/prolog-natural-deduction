validate(Input) :-
    see(Input),
    read(Prems), read(Goal), read(Proofs),
    seen,
    nb_setval(prems, Prems),
    nb_setval(proofs, Proofs),
    validate(Prems, Proofs, 0, Proofs),
    check_goal(Goal, Proofs).

test(Input) :-
    see(Input),
    read(Prems), read(Goal), read(Proofs),
    seen,
    nb_setval(prems, Prems),
    nb_setval(proofs, Proofs),
    nb_setval(depth, 2),
nb_setval(line, 7),
    proof(5, X),
    writef('%t\n', [X]).

% Depth tells us how many boxes we can open.
validate(_, _, _, []).
validate(Prems, Proofs, Depth, [Proof|Next]) :-
    (is_box(Proof) -> (
        NewDepth is Depth+1,
        nb_setval(depth, NewDepth),
        validate(Prems, Proofs, NewDepth, Proof)) ;
        (nb_setval(depth, Depth),
        valine(Prems, Proofs, Proof))),
    validate(Prems, Proofs, Depth, Next).

check_goal(Goal, Proofs) :-
    last(Proofs, [_, Goal, _]) ->
        write('Goal met!\n') ;
        write('Goal unmet!\n').

% Log a line in the proof, and write if its valid or not.
log([Line, Conclusion, Name], Valid) :-
    format('~t~a~2|  ~w~t~15+ ~w~t~t~15+  ~t~a~8|~n', [Line, Conclusion, Name, Valid]).

% Below we validate the different rules
% Validate one line, since we will be writing logs of functions for all the names, we have a overload to only use the name and conclusion
valine(Prems, Proofs, [Line, Conclusion, Name]) :-
    nb_setval(line, Line),
    (call(Name, Prems, Proofs, Line, Conclusion) ->
        log([Line, Conclusion, Name], 'Valid') ;
        log([Line, Conclusion, Name], 'Invalid')).

%valine(Prems, Proofs, E) :- writef('Unmatched line: %p\n', [E]), fail.



premise(Prems, _, _, Conclusion) :-
    contains(Prems, Conclusion).

impel(I1, I2, _, _, _, Conclusion) :-
    conclusion(I2, imp(Requirement, Conclusion)),
    conclusion(I1, Requirement).

assumption(_, _, _, _) :-
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

negel(I1, I2, _, _, _, _) :-
    conclusion(I2, neg(X)),
    conclusion(I1, X),
    I1>I2.

orel(I1, I2, I3, I4, I5, _, Proofs, _, Conclusion) :-
I2 is I1+1,
I4 is I3+1,
I1<I2,
I2<I3,
I3<I4,

    conclusion(I1, or(X, Y)),
    deep_contains(Proofs, [[I2, X, _]|Next1]),
    last(Next1, [I3, cont, _]),
    deep_contains(Proofs, [[I4, Y, _]|Next2]),
    last(Next2, [I5, cont, _]).



% Helper methods to easily get parts of a proof at line N
% Get a proof by the line index
proof(Line, Proof) :-
    nb_getval(proofs, Proofs),
    proof(Line, 0, Proof, Proofs),
    nb_getval(line, CurrLine),
    check_index(CurrLine, Proof).

% Check that the current line is greater than the line the proof used is at
check_index(CurrentLine, [ProofLine, _, _]) :-
    CurrentLine>ProofLine.
% Get a proof, this will only get proofs from boxes X deep where X is our current depth from where we are requesting the proof
proof(Goal, _, [Goal, Conclusion, Name], [[Goal, Conclusion, Name]|_]).
proof(Goal, Depth, Proof, [[Line, _, _]|Next]) :-
    integer(Line),
    Goal>Line,
    proof(Goal, Depth, Proof, Next).
proof(Goal, Depth, Proof, [Box|Next]) :-
    is_box(Box),
    NewDepth is Depth+1,
    nb_getval(depth, MaxDepth),
    MaxDepth>=NewDepth,
    (proof(Goal, NewDepth, Proof, Box) ;
    proof(Goal, Depth, Proof, Next)).
    
% Get a conclusion by line
conclusion(Line, Conclusion) :-
    proof(Line, [_, Conclusion, _]).
% Get a name by line
name(Line, Name) :-
    proof(Line, [_, _, Name]).

% Check if an element exists in a list.
contains([H|T], H).
contains([H|T], E) :-
    contains(T, E).

% Check if an element exists in a list or any nested list.
deep_contains([H|T], H).
deep_contains([H|T], E) :-
    deep_contains(H, E) ;
    deep_contains(T, E).

% Get an element by index from a list, can also check if a element exists at an index.
get(List, Index, Elem) :-
    get(List, Index, 1, Elem).
get([H|_], Goal, Goal, H).
get([], _, _, []).
get([H|T], Goal, Curr, Elem) :-
    Next is Curr+1,
    get(T, Goal, Next, Elem).

last([H|[]], H).
last([H|T], E) :-
    last(T, E).

% When appending, if the other element is a list, do list appending.
append([], [L|LS], [L|LS]).
% When appending, of the other element is a singleton, do singleton appending.
append([], L, [L]).
% Append a list and another list, or single element.
append([H|T], L, [H|R]) :-
          append(T, L, R).

% Flatten a matrix into a list.
flatten(List, Res) :- flatten(List, [], Res).
flatten([], ACC, ACC).
flatten([H|T], ACC, RES) :-
    append(ACC, H, NEW),
    flatten(T, NEW, RES).

len(List, Size) :-
    flatten(List, Flattened),
    len(Flattened, 0, Size).
len([], Size, Size).
len([H|T], Index, Size) :-
    Next is Index+1,
    len(T, Next, Size).

is_box([[_, _, _]|_]).

natural_order([H|[]]).
natural_order([H|[N|_]]) :-
    number(H),
    number(N),
    H>N,
    natural_order([N|T]).
