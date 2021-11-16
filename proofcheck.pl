verify(File) :-
    validate(File).

validate(Input) :-
    load_files(['../Utils.pl', '../Rules.pl']),
    see(Input),
    read(Prems), read(Goal), read(Proofs),
    seen,
    validate(Prems, Proofs, Proofs),
    check_goal(Goal, Proofs).

% Depth tells us how many boxes we can open.
validate(_, _, []).
validate(Prems, Proofs, [Box|Next]) :-
    is_box(Box),
    validate(Prems, Proofs, Box),
    validate(Prems, Proofs, Next).
validate(Prems, Proofs, [Proof|Next]) :-
    is_proof(Proof),
    valine(Prems, Proofs, Proof),
    validate(Prems, Proofs, Next).

/**
 * check_goal(+Goal : goal, +Proofs : list).
 *
 * Succeeds if the goal is met in our proofs.
 *
 * @param Goal the goal to find.
 * @param Proofs the proofs to find the goal in.
 */
check_goal(Goal, Proofs) :-
    last(Proofs, [_, Goal, _]).

% Log a line in the proof, and write if its valid or not.
log([Line, Conclusion, Name], Valid) :-
    format('~t~a~2|  ~w~t~15+ ~w~t~t~15+  ~t~a~8|~n', [Line, Conclusion, Name, Valid]).

% Below we validate the different rules
% Validate one line, since we will be writing logs of functions for all the names, we have a overload to only use the name and conclusion
valine(Prems, Proofs, [Line, Conclusion, Name]) :-
    functor(Name, F, _),
    contains([premise, assumption, copy, andint, andel1, andel2, orint1, orint2, orel, impint, impel, negint, negel, contel, negnegint, negnegel, mt, pbc, lem], F),
    call(Name, Prems, Proofs, [Line, Conclusion, Name]).
