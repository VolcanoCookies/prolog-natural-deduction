verify(File) :-
    validate(File).

/**
 * validate(+Input : file).
 *
 * Loads the required Utils.pl and Rules.pl file,
 * Then reads the premises, goals, and proofs from the given Input.
 * First it validates all lines in the proofs, and then it checks that the goals are met.
 *
 * Succeeds if all lines are valid and the goals are met.
 *
 * @param Input the file to validate.
 */
validate(Input) :-
    load_files(['./Utils.pl', './Rules.pl']),
    see(Input),
    read(Prems), read(Goal), read(Proofs),
    seen,
    validate(Prems, Proofs, Proofs),
    check_goal(Goal, Proofs).

/**
 * validate(+Prems : list, +Proofs : list, +[Line|Next] : list).
 *
 * Succeeds if there are no more lines, and all previous lines were valid.
 * If the Line is a box, open the box and validate that first, before going onto Next.
 *
 * @param Prems all our premises.
 * @param Proofs all our proofs.
 * @param [Line|Next] the current line we are on, and the next element in the list.
 */
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

/**
 * log(+Proof : proof, +Valid : boolean).
 *
 * Writes the proof in a nice format, along with if its valid or not.
 * Does not actually check if its valid or not, just gets that information in its parameteres.
 *
 * @param Proof the proof to print.
 * @param Valid if the proof is valid.
 */
log([Line, Conclusion, Name], Valid) :-
    format('~t~a~2|  ~w~t~15+ ~w~t~t~15+  ~t~a~8|~n', [Line, Conclusion, Name, Valid]).

/**
 * valine(+Prems : line, +Proofs : line, +Proof : proof).
 *
 * Succeeds if Proof is a valid proof.
 *
 * We have to check if the name of our proof is a functor, and if the functor is one of the allowed methods that we have defined in Rules.pl.
 * We call the name with its arguments, plus our premises, proofs, and the current proof we are on.
 *
 * @param Prems all ours premises.
 * @param Proofs all our proofs.
 * @param Proof the proof we are currently on.
 */
valine(Prems, Proofs, [Line, Conclusion, Name]) :-
    functor(Name, F, _),
    contains([premise, assumption, copy, andint, andel1, andel2, orint1, orint2, orel, impint, impel, negint, negel, contel, negnegint, negnegel, mt, pbc, lem], F),
    call(Name, Prems, Proofs, [Line, Conclusion, Name]).
