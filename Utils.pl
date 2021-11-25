/**
 * list(+List : list).
 *
 * Succeeds if List is in fact a list.
 *
 * @param List the object to check if its a list.
 */
is_list([]).
is_list([_|_]).

/**
 * all_match(+List : list, +Predicate : any).
 *
 * Succeeds if all elements in the list match the predicate provided.
 *
 * @param List the list to check in.
 * @param Predicate the predicate all elements in the list must match.
 */
all_match([], _).
all_match([Predicate|T], Predicate) :-
    all_match(T, Predicate).

/**
 * until(+List : list, +Element : any, -Sublist : list).
 *
 * Get all elements until Element from List. Fails if Element is not in List.
 *
 * Excluding Element.
 *
 * @param List the list to get a sublist of.
 * @param Element the element to go until.
 * @param Sublist the returned sublist, excludes Element.
 */
until(List, Element, Sublist) :-
    until(List, Element, [], Sublist).
until([Elm|_], Elm, Acc, Acc).
until([H|T], Elm, Acc, Sub) :-
    append(H, Acc, New),
    until(T, Elm, New, Sub).

/**
 * append(+List : list, +Element : any, -Result : list).
 *
 * Appends Element to the end of List, this works for both lists, and single objects.
 *
 * @param List the list to append Element to.
 * @param Element the element to append.
 * @param Result the resulting new list.
 */
append([], [L|LS], [L|LS]).
append([], L, [L]).
append([H|T], L, [H|R]) :-
      append(T, L, R).

/**
 * is_box(+Box : list).
 *
 * Succeeds if Box is a list where the first element is not a integer.
 *
 * @param Box the potential box.
 */
is_box([H|_]) :-
    not(integer(H)).

/**
 * is_proof(+Proof : list).
 *
 * Succeeds if the Proof is a list of length 3, with the first element being a integer.
 *
 * @param Proof the potential proof.
 */
is_proof([Line, _, _]) :-
    integer(Line).

/**
 * first_proof(+Proofs : List, ?Proof : Proof).
 *
 * Will enter boxes.
 *
 * Succeeds if the first valid proof in Proofs equals Proof.
 *
 * @param Proofs the proofs to look in.
 * @param Proof the proof to find, or match.
 */
first_proof([Proof|_], Proof) :-
    is_proof(Proof).
first_proof([Box|_], Proof) :-
    is_box(Box),
    first_proof(Box, Proof).

/**
 * last_proof(+Proofs : list, ?Proof : proofs).
 *
 * Succeeds if the last proof in Proofs equals Proof.
 *
 * @param Proofs the proofs to look in.
 * @param Proof the proof to find, or match.
 */
last_proof([Proof|[]], Proof) :-
    is_proof(Proof).
last_proof([Box|[]], Proof) :-
    is_box(Box),
    last_proof(Box, Proof).
last_proof([_|T], Proof) :-
    last_proof(T, Proof).

/**
 * contains(+List : list, ?Element : any).
 *
 * Succeeds if List contains Element.
 *
 * @param List the list to check in.
 * @param Element the element to find in the list, or match.
 */
contains([H|_], H).
contains([_|T], E) :-
    contains(T, E).

/**
 * deep_contains(+List : list, ?Element : any).
 *
 * Succeeds if List, or any sublists in List, contains Element.
 *
 * @param List the list to check in, will check any sublists.
 * @param Element the element to find, or match.
 */
deep_contains([H|_], H).
deep_contains([H|T], E) :-
    deep_contains(H, E) ;
    deep_contains(T, E).
    
/**
 * deep_contains_proof(+Proofs : list, ?Proof : proof).
 *
 * Succeeds if Proofs, or any boxes within, contains Proof.
 *
 * @param Proofs the proofs to look in.
 * @param Proof the proof to find.
 */
deep_contains_proof([Proof|_], Proof).
deep_contains_proof([H|_], Proof) :-
    not(is_proof(H)),
    deep_contains_proof(H, Proof).
deep_contains_proof([_|T], Proof) :-
    not(is_proof(T)),
    deep_contains_proof(T, Proof).

/**
 * last(+List : list, ?Element : any).
 *
 * Succeeds if the last element in List equals Element.
 *
 * @param List the list to get the last element from.
 * @param Element the last element.
 */
last([H|[]], H).
last([_|T], E) :-
    last(T, E).

/**
 * proof(+Proofs : list, +From : proof, +Line : integer, -Proof : proof).
 *
 * Get a proof from a specific line, this will use the From argument to check if
 * the line we want can actually be reached from the From line.
 *
 * This will first open any boxes to find the line we want, and if we find it,
 * we then check if we can actually access it.
 *
 * We do this by first finding the line X we want using the Line variable, then
 * we check if we can reach From by only checking the lines after X, without
 * exiting any boxes.
 *
 * Example:
 * Say we wanted to find X, we thus have [X|N], with N being all the proofs
 * coming after X, bound to the box that X is in.
 * We now simply check if N contains our From line, if it does not, X cannot
 * be reached from From.
 *
 * @param Proofs the list of proofs we will check in.
 * @param From the proof we are at currently, used to check if we can access
 *        Proof.
 * @param Line the index of the line we want to get.
 * @param Proof the proof at line Line.
 */
proof([[Line, Conclusion, Name]|Next], From, Line, [Line, Conclusion, Name]) :-
    deep_contains(Next, From).
proof([Box|_], From, Line, Proof) :-
    is_box(Box),
    proof(Box, From, Line, Proof).
proof([_|Next], From, Line, Proof) :-
    proof(Next, From, Line, Proof).

/**
 * box(+Proofs : list, +From : proof, +Start : integer, +End : integer, -Box : box).
 *
 * Get a box that starts at line Start, and ends at line End. Proofs can only
 * refer to a box as a whole by referencing the Start and End line.
 *
 * This will first find the box that we want, and the check if we can actually
 * access it from the line From. (the line we are calling from).
 *
 * We do this by first finding the box X we want using the Start and End
 * variable, then we check if we can reach From by only checking the lines after
 * X, without exiting any boxes.
 *
 * Example:
 * Say we wanted to find X, we thus have [X|N], with N being all the proofs
 * coming after X, bound to the box that X is in.
 * We now simply check if N contains our From line, if it does not, X cannot
 * be reached from From.
 *
 * @param Proofs the proofs to find the box in.
 * @param From the line we are trying to find the box from.
 * @param Start the index of the first line in the box.
 * @param End the index of the last line in the box.
 * @param Box our box that we wanted to find.
 */
box([Box|Next], From, Start, End, Box) :-
    is_box(Box),
    first_proof(Box, [Start ,_ ,_]),
    last_proof(Box, [End, _, _]),
    deep_contains_proof(Next, From).
box([H|_], From, Start, End, Box) :-
    is_box(H),
    box(H, From, Start, End, Box).
box([_|T], From, Start, End, Box) :-
    box(T, From, Start, End, Box).

/**
 * box_of(+Proofs : list, +Proof : proof, -Box : box).
 *
 * Finds the box that contains the provided proof.
 *
 * @param Proofs the proofs to look in.
 * @param Proof the proof to find.
 * @param Box returns the list that contains the proof.
 */
box_of(Proofs, Proof, Box) :-
    box_of(Proofs, Proofs, Proof, Box).
box_of(Initial, Box, Proof, Box) :-
    contains(Box, Proof),
    contains(Initial, Box).
box_of(Box, Box, Proof, Box) :-
    contains(Box, Proof).
box_of(_, [H|_], Proof, Box) :-
    is_box(H),
    box_of(H, H, Proof, Box).
box_of(Initial, [_|T], Proof, Box) :-
    box_of(Initial, T, Proof, Box).

/**
 * conclusion(+Proofs : list, +From : proof, +Line : integer, -Conclusion : conclusion).
 *
 * Shortcut method for getting a conclusion at a specific line.
 * Calls proof(Proofs, From, Line, Proof) under the hood.
 *
 * @param Proofs the list of proofs we will check in.
 * @param From the proof we are at currently, used to check if we can access
 *        Proof.
 * @param Line the index of the line we want to get.
 * @param Conclusion the conclusion at line Line.
 *
 * @see proof(Proofs, From, Line, Proof).
 */
conclusion(Proofs, From, Line, Conclusion) :-
    proof(Proofs, From, Line, [_, Conclusion, _]).

/**
 * name(+Proofs : list, +From : proof, +Line : integer, -Name : name).
 *
 * Shortcut method for getting a name at a specific line.
 * Calls proof(Proofs, From, Line, Proof) under the hood.
 *
 * @param Proofs the list of proofs we will check in.
 * @param From the proof we are at currently, used to check if we can access
 *        Proof.
 * @param Line the index of the line we want to get.
 * @param Name the name at line Line.
 *
 * @see proof(Proofs, From, Line, Proof).
 */
name(Proofs, From, Line, Name) :-
    proof(Proofs, From, Line, [_, _, Name]).
