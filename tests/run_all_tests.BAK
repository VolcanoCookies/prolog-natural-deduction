% For sicstus: use_module(library(lists)).  before consulting the file.

run_all_tests() :-
    run_all_tests('../proofcheck.pl').

run_all_tests(ProgramToTest) :-
    directory_files('./valid', [_|[_|ValidFiles]]),
    directory_files('./invalid', [_|[_|InvalidFiles]]),
    catch(consult(ProgramToTest),
          B,
          (write('Could not consult \"'), write(ProgramToTest),
           write('\": '), write(B), nl, halt)),
    working_directory(_, './valid'),
    all_valid_ok(ValidFiles),
    working_directory(_, './invalid'),
    all_invalid_ok(InvalidFiles),
%    all_valid_ok(['valid01.txt', 'valid02.txt', 'valid03.txt',
%                  'valid04.txt', 'valid05.txt', 'valid06.txt',
%                  'valid07.txt', 'valid08.txt', 'valid09.txt',
%                  'valid10.txt', 'valid11.txt', 'valid12.txt',
%                  'valid13.txt', 'valid14.txt', 'valid15.txt',
%                  'valid16.txt', 'valid17.txt', 'valid18.txt',
%                  'valid19.txt', 'valid20.txt', 'valid21.txt']),
%    all_invalid_ok(['invalid01.txt', 'invalid02.txt', 'invalid03.txt',
%                    'invalid04.txt', 'invalid05.txt', 'invalid06.txt',
%                    'invalid07.txt', 'invalid08.txt', 'invalid09.txt',
%                    'invalid10.txt', 'invalid11.txt', 'invalid12.txt',
%                    'invalid13.txt', 'invalid14.txt', 'invalid15.txt',
%                    'invalid16.txt', 'invalid17.txt', 'invalid18.txt',
%                    'invalid19.txt', 'invalid20.txt', 'invalid21.txt',
%                    'invalid22.txt', 'invalid23.txt', 'invalid24.txt',
%                    'invalid25.txt', 'invalid26.txt', 'invalid27.txt',
%                    'invalid28.txt']),
    halt.



all_valid_ok([]).
all_valid_ok([Test | Remaining]) :-
    write(Test), 
    (verify(Test), write(' passed');
    write(' failed. The proof is valid but your program rejected it!')),
    nl, all_valid_ok(Remaining).

all_invalid_ok([]).
all_invalid_ok([Test | Remaining]) :-
    write(Test), 
    (\+verify(Test), write(' passed');
    write(' failed. The proof is invalid but your program accepted it!')),
    nl, all_invalid_ok(Remaining).
