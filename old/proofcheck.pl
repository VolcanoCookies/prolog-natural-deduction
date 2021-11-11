validate(Input) :-
    see(Input),
    read(Prems), read(Goal), read(Proofs),
    seen,
    nb_setval(prems, Prems),
    nb_setval(proofs, Proofs),
    validate(Prems, Proofs, Proofs),
    check_goal(Goal, Proofs).

validate(_, _, []).
validate(Prems, Proofs, [is_box(Proof)|Next]) :-
    validate([Prems| ])
validate(Prems, Proofs, [Proof|Next]) :-
    (valine(Prems, Proofs, Proof) ->
        log(Proof, 'Valid') ;
        log(Proof, 'Invalid')),
    validate(Prems, Proofs, Next).

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
    call(Name, Prems, Proofs, Line, Conclusion) ;
    call(Name, Conclusion).
    
valine(Prems, Proofs, E) :- writef('Unmatched line: %p\n', [E]), fail.



premise(Prems, _, _, Conclusion) :-
    contains(Prems, Conclusion).

impel(I1, I2, Conclusion) :-
    conclusion(I2, imp(Requirement, Conclusion)),
    conclusion(I1, Requirement).

copy(I, Conclusion) :-
    conclusion(I, Conclusion).


% Helper methods to easily get parts of a proof at line N
% Get a proof by the line index
proof(Line, Proof) :-
    nb_getval(proofs, [H|T]),
    get(Proofs, Line, Proof).

proof(Goal, Line, Proof, [Proof|_]).
proof(Goal, Curr, Proof, [[H]|T]) :-
    (SubGoal is Goal-Curr,
    proof(SubGoal, 0, Proof, H)) ;
    (len(H, Len),
    Next is Curr+Len+1,
    proof(Goal, Next, Proof, T)).



proof(Line, Curr, [H|T]) :-

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
