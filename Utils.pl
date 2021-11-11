/**
 * list(+List : list).
 *
 * Succeeds if List is in fact a list.
 *
 * @param List the object to check if its a list.
 */
list([_|_]).

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
 * flatten(+List : list, -Res : list).
 *
 * Flattens List.
 *
 * @param List the list to flatten.
 * @param Res the flattened list.
 */
flatten(List, Res) :- flatten(List, [], Res).
flatten([], ACC, ACC).
flatten([H|T], ACC, RES) :-
    append(ACC, H, NEW),
    flatten(T, NEW, RES).

/**
 * len(+List : list, ?Size : integer).
 *
 * Succeeds if the List length equals Size.
 *
 * @param List the list to count the length for.
 * @param Size the size of the list.
 */
len(List, Size) :-
    flatten(List, Flattened),
    len(Flattened, 0, Size).
len([], Size, Size).
len([_|T], Index, Size) :-
    Next is Index+1,
    len(T, Next, Size).

/**
 * is_box(+Box : list).
 *
 * Succeeds if Box is a list, and is not a proof.
 *
 * @param Box the potential box.
 */
is_box(Box) :-
    list(Box),
    not(is_proof(Box)).

/**
 * is_proof(+Proof : list).
 *
 * Succeeds if the Proof is a list of length 3, with the first element being a integer.
 *
 * @param Proof the potential proof.
 */
is_proof([Line|[_|[_|[]]]]) :-
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
 * natural_order(+List : list).
 *
 * Succeeds if all the elements in the list are numbers, and fall in their natural ordering from low to high.
 *
 * @param List the list to check the natural ordering for.
 */
natural_order([_|[]]).
natural_order([H|[N|T]]) :-
    number(H),
    number(N),
    H<N,
    natural_order([N|T]).

/**
 * contains(+List : list, ?Element : any).
 *
 * Succeeds if List contains Element.
 *
 * @param List the list to check in.
 * @param Element the element to find in the list, or match.
 */
contains([H|T], H).
contains([H|T], E) :-
        contains(T, E).

/**
 * deep_contains(+List : list, ?Element : any).
 *
 * Succeeds if List, or any sublists in List, contains Element.
 *
 * @param List the list to check in, will check any sublists.
 * @param Element the element to find, or match.
 */
deep_contains([H|T], H).
deep_contains([H|T], E) :-
        deep_contains(H, E) ;
        deep_contains(T, E).

/**
 * last(+List : list, ?Element : any).
 *
 * Succeeds if the last element in List equals Element.
 *
 * @param List the list to get the last element from.
 * @param Element the last element.
 */
last([H|[]], H).
last([H|T], E) :-
        last(T, E).
