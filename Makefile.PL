use inc::Module::Install;
name 'Plack-Middleware-GTop-ProcMem';
all_from 'lib/Plack/Middleware/GTop/ProcMem.pm';

requires 'Plack';
requires 'GTop';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
