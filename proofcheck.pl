% [Line, and(X, Y), andint(I1, I2)]
% andint(I1, I2, and(X, Y)) :-
%     conclusion(I1, X),
%     conclusion(I2, Y).

validate(Input) :-
    load_files(['Utils.pl', 'Rules.pl']),
    see(Input),
    read(Prems), read(Goal), read(Proofs),
    seen,
    nb_setval(prems, Prems),
    nb_setval(proofs, Proofs),
    validate(Prems, Proofs, 0, Proofs),
    check_goal(Goal, Proofs).

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

/**
 * check_goal(+Goal : goal, +Proofs : list).
 *
 * Succeeds if the goal is met in our proofs.
 *
 * @param Goal the goal to find.
 * @param Proofs the proofs to find the goal in.
 */
check_goal(Goal, Proofs) :-
    last(Proofs, [_, Goal, _]) ->
        write('Goal met!\n') ;
        write('Goal not met!\n').

% Log a line in the proof, and write if its valid or not.
log([Line, Conclusion, Name], Valid) :-
    format('~t~a~2|  ~w~t~15+ ~w~t~t~15+  ~t~a~8|~n', [Line, Conclusion, Name, Valid]).

% Below we validate the different rules
% Validate one line, since we will be writing logs of functions for all the names, we have a overload to only use the name and conclusion
valine(Prems, Proofs, [Line, Conclusion, Name]) :-
    (call(Name, Prems, Proofs, [Line, Conclusion, Name]) ->
        log([Line, Conclusion, Name], 'Valid') ;
        log([Line, Conclusion, Name], 'Invalid')).
