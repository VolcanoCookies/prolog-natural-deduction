% For sicstus: use_module(library(lists)).  before consulting the file.

run_all_tests_debug() :-
    run_all_tests('./Proofcheck - debug.pl').

run_all_tests() :-
    run_all_tests('./Proofcheck.pl').

run_all_tests(ProgramToTest) :-
    directory_files('./tests/valid', [_|[_|ValidFiles]]),
    directory_files('./tests/invalid', [_|[_|InvalidFiles]]),
    catch(consult(ProgramToTest),
          B,
          (write('Could not consult \"'), write(ProgramToTest),
           write('\": '), write(B), nl, halt)),
    all_valid_ok(ValidFiles),
    all_invalid_ok(InvalidFiles).

all_valid_ok([]).
all_valid_ok([Test | Remaining]) :-
    write(Test),
    atom_concat('./tests/valid/', Test, Path),
    (verify(Path), write(' passed');
    write(' failed. The proof is valid but your program rejected it!')),
    nl, all_valid_ok(Remaining).

all_invalid_ok([]).
all_invalid_ok([Test | Remaining]) :-
    write(Test),
    atom_concat('./tests/invalid/', Test, Path),
    (\+verify(Path), write(' passed');
    write(' failed. The proof is invalid but your program accepted it!')),
    nl, all_invalid_ok(Remaining).
