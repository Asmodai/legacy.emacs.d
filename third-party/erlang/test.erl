%% -*- erlang -*-
%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2009-2010. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%

%%%-------------------------------------------------------------------
%%% File    : test.erl
%%% Author  : Dan Gudmundsson <dan.gudmundsson@ericsson.com>
%%% Description :   Test emacs mode indention and font-locking
%%%                 this file is intentionally not indented.
%%%                 Copy the file and indent it and you should end up with test.erl.indented
%%% Created :  6 Oct 2009 by Dan Gudmundsson <dan.gudmundsson@ericsson.com>
%%%-------------------------------------------------------------------

%% Start off with syntax highlighting you have to verify this by looking here 
%% and see that the code looks alright

-module(test).
-compile(export_all).

%% Module attributes should be highlighted

-export([t/1]).
-record(record1, {a, 
		  b, 
		  c
		 }).
-record(record2, {
	  a,
	  b
	 }).

-record(record3, {a = 8#42423 bor
		      8#4234,
		  b = 8#5432 
		      bor 2#1010101
		  c = 123 +
		      234,
		  d}).

-record(record4, {
	  a = 8#42423 bor
	      8#4234,
	  b = 8#5432 
	      bor 2#1010101
	  c = 123 +
	      234,
	  d}).


-define(MACRO_1, macro).
-define(MACRO_2(_), macro).

-spec t(integer()) -> any().

-type ann() :: Var :: integer(). 
-type ann2() :: Var :: 
	    'return' 
	  | 'return_white_spaces' 
	  | 'return_comments'
	  | 'text' | ann(). 
-type paren() :: 
	(ann2()). 
-type t1() :: atom(). 
-type t2() :: [t1()]. 
-type t3(Atom) :: integer(Atom). 
-type t4() :: t3(foobar). 
-type t5() :: {t1(), t3(foo)}. 
-type t6() :: 1 | 2 | 3 | 
	      'foo' | 'bar'. 
-type t7() :: []. 
-type t71() :: [_]. 
-type t8() :: {any(),none(),pid(),port(),
	       reference(),float()}. 
-type t9() :: [1|2|3|foo|bar] | 
	      list(a | b | c) | t71(). 
-type t10() :: {1|2|3|foo|t9()} | {}. 
-type t11() :: 1..2. 
-type t13() :: maybe_improper_list(integer(), t11()). 
-type t14() :: [erl_scan:foo() | 
		%% Should be highlighted
		term() |
		bool() |
		byte() |
		char() |
		non_neg_integer() | nonempty_list() |
		pos_integer() |
		neg_integer() |
		number() |
		list() |
		nonempty_improper_list() | nonempty_maybe_improper_list() |
		maybe_improper_list() | string() | iolist() | byte() |
		module() |
		mfa() 	|
		node() 	|
		timeout() |
		no_return() |
		%% Should not be highlighted
		nonempty_() | nonlist() | 
		erl_scan:bar(34, 92) | t13() | m:f(integer() | <<_:_*16>>)].


-type t15() :: {binary(),<<>>,<<_:34>>,<<_:_*42>>,
		<<_:3,_:_*14>>,<<>>} | [<<>>|<<_:34>>|<<_:16>>|
					<<_:3,_:_*1472>>|<<_:19,_:_*14>>| <<_:34>>|
					<<_:34>>|<<_:34>>|<<_:34>>]. 
-type t16() :: fun(). 
-type t17() :: fun((...) -> paren()). 
-type t18() :: fun(() -> t17() | t16()). 
-type t19() :: fun((t18()) -> t16()) |
	       fun((nonempty_maybe_improper_list('integer', any())|
		    1|2|3|a|b|<<_:3,_:_*14>>|integer()) ->
			  nonempty_maybe_improper_list('integer', any())|
			  1|2|3|a|b|<<_:3,_:_*14>>|integer()). 
-type t20() :: [t19(), ...]. 
-type t21() :: tuple(). 
-type t21(A) :: A. 
-type t22() :: t21(integer()). 
-type t23() :: #rec1{}. 
-type t24() :: #rec2{a :: t23(), b :: [atom()]}. 
-type t25() :: #rec3{f123 :: [t24() | 
			      1|2|3|4|a|b|c|d| 
			      nonempty_maybe_improper_list(integer, any())]}. 
-type t99() ::
	{t2(),t4(),t5(),t6(),t7(),t8(),t10(),t14(),
	 t15(),t20(),t21(), t22(),t25()}. 
-spec t1(FooBar :: t99()) -> t99();
	(t2()) -> t2();
	(t4()) -> t4() when is_subtype(t4(), t24);
	(t23()) -> t23() when is_subtype(t23(), atom()),
			      is_subtype(t23(), t14());
	(t24()) -> t24() when is_subtype(t24(), atom()),
			      is_subtype(t24(), t14()),
			      is_subtype(t24(), t4()).

-spec over(I :: integer()) -> R1 :: foo:typen();
	  (A :: atom()) -> R2 :: foo:atomen();
	  (T :: tuple()) -> R3 :: bar:typen().

-spec mod:t2() -> any(). 

-spec handle_cast(Cast :: {'exchange', node(), [[name(),...]]} 
			| {'del_member', name(), pid()},
		  #state{}) -> {'noreply', #state{}}.

-spec handle_cast(Cast :: 
		    {'exchange', node(), [[name(),...]]} 
		  | {'del_member', name(), pid()},
		  #state{}) -> {'noreply', #state{}}.

-spec all(fun((T) -> boolean()), List :: [T]) ->
		 boolean() when is_subtype(T, term()). % (*)

-spec get_closest_pid(term()) -> 
			     Return :: pid()
				     | {'error', {'no_process', term()}
					| {'no_such_group', term()}}.

-opaque attributes_data() :: 
	  [{'column', column()} | {'line', info_line()} |
	   {'text', string()}] |  {line(),column()}.   
-record(r,{
	  f1 :: attributes_data(),
	  f222 = foo:bar(34, #rec3{}, 234234234423, 
			 aassdsfsdfsdf, 2234242323) :: 
		   [t24() | 1|2|3|4|a|b|c|d| 
		    nonempty_maybe_improper_list(integer, any())],
	  f333 :: [t24() | 1|2|3|4|a|b|c|d| 
		   nonempty_maybe_improper_list(integer, any())],
	  f3 = x:y(),
	  f4 = x:z() :: t99(),
	  f17 :: 'undefined',
	  f18 :: 1 | 2 | 'undefined',
	  f19 = 3 :: integer()|undefined,
	  f5 = 3 :: undefined|integer()}). 

-record(state, {
	  sequence_number = 1          :: integer()
	 }).


highlighting(X)			  % Function definitions should be highlighted
  when is_integer(X) ->	  % and so should `when' and `is_integer' be
    %% Highlighting
    %% Various characters (we keep an `atom' after to see that highlighting ends)
    $a,atom,			  % Characters should be marked
    "string",atom,		  % and strings
    'asdasd',atom,		  % quote should be atoms??
    'VaV',atom,
    'aVa',atom,
    '\'atom',atom,
    'atom\'',atom,
    'at\'om',atom,
    '#1',atom,

    $", atom,					% atom should be ok
    $', atom, 

    "string$", atom,  "string$", atom,  		% currently buggy I know...
    "string\$", atom,   				% workaround for bug above

    "char $in string", atom, 

    $[, ${, $\\, atom,
    ?MACRO_1,
    ?MACRO_2(foo),

    %% Numerical constants
    16#DD,					% AD Should not be highlighted
    32#dd,					% AD Should not be highlighted
    32#ddAB,				        % AD Should not be highlighted
    32#101,				        % AD Should not be highlighted
    32#ABTR,				        % AD Should not be highlighted

    %% Variables
    Variables = lists:foo(),
    _Variables = lists:foo(),                      % AD
    AppSpec = Xyz/2,
    Module42 = Xyz(foo, bar),
    Module:foo(),
    _Module:foo(),				% AD
    Foo???? = lists:reverse([tl,hd,tl,hd]),	% AD Should highlight Foo????
    _Foo???? = 42,				% AD Should highlight _Foo????

    %% Bifs
    erlang:registered(),
    registered(),
    hd(tl(tl(hd([a,b,c])))),
    erlang:anything(lists),
    %% Guards
    is_atom(foo), is_float(2.3), is_integer(32), is_number(4323.3),
    is_function(Fun), is_pid(self()), 
    not_a_guard:is_list([]),
    %% Other Types

    atom,			  % not (currently) hightlighted
    234234, 
    234.43,

    [list, are, not, higlighted],    
    {nor, is, tuple},
    ok.

%%%
%%%  Indentation
%%%

%%%  Left

%%   Indented

						%    Right


indent_basics(X, Y, Z) 
  when X > 42,
       Z < 13;
       Y =:= 4711 ->
    %% comments
						% right comments
    case lists:filter(fun(_, AlongName, 
			  B, 
			  C) ->
			      true
		      end, 
		      [a,v,b])
    of
	[] ->
	    Y = 5 * 43,
	    ok;
	[_|_] -> 
	    Y = 5 * 43,
	    ok
    end,
    Y,
    %% List, tuples and binaries
    [a, 
     b, c
    ],
    [ a, 
      b, c
    ],

    [
     a,
     b
    ],
    {a, 
     b,c
    },
    { a, 
      b,c
    },

    {
      a,
      b
    },

    <<1:8,
      2:8
    >>,
    <<
      1:8,
      2:8
    >>,
    << 1:8,
       2:8
    >>,

    (a,
     b,
     c
    ),

    ( a,
      b,
      c
    ),


    (
      a,
      b,
      c
    ),

    call(2#42423 bor 
	     #4234,
	 2#5432,
	 other_arg),
    ok;
indent_basics(Xlongname, 
	      #struct{a=Foo,
		      b=Bar}, 
	      [X|
	       Y]) ->
    testing_next_clause,
    ok;
indent_basics(					% AD added clause
  X, 						% not sure how this should look
  Y,
  Z)
  when
      X < 42, Z > 13;
      Y =:= 4711 ->
    foo;
indent_basics(X, Y, Z) when			% AD added clause
      X < 42, Z > 13;				% testing when indentation
      Y =:= 4711 ->
    foo;
indent_basics(X, Y, Z)				% AD added clause
  when						% testing when indentation
      X < 42, Z > 13;				% unsure about this one
      Y =:= 4711 ->
    foo.



indent_nested() ->
    [
     {foo, 2, "string"},
     {bar, 3, "another string"}
    ].


indent_icr(Z) -> 				% icr = if case receive
    %% If
    if Z >= 0 ->
	    X = 43 div 4,
	    foo(X);
       Z =< 10 ->
	    X = 43 div 4,
	    foo(X);
       Z == 5 orelse
       Z == 7 ->
	    X = 43 div 4,
	    foo(X);
       true ->
	    if_works
    end,
    %% Case
    case {Z, foo, bar} of
	{Z,_,_} ->
	    X = 43 div 4,
	    foo(X);
	{Z,_,_}	when
	      Z =:= 42 ->				% AD line should be indented as a when
	    X = 43 div 4,
	    foo(X);
	{Z,_,_}
	  when Z < 10 ->			% AD when should be indented
	    X = 43 div 4,
	    foo(X);
	{Z,_,_}
	  when					% AD when should be indented
	      Z < 10				% and the guards should follow when
	      andalso				% unsure about how though
	      true ->
	    X = 43 div 4,
	    foo(X)
    end,
    %% begin
    begin
	sune,
	X = 74234 + foo(8456) +
	    345 div 43,
	ok
    end,


    %% receive
    receive 
	{Z,_,_} ->
	    X = 43 div 4,
	    foo(X);
	Z ->
	    X = 43 div 4,
	    foo(X) 
    end,
    receive
	{Z,_,_} ->
	    X = 43 div 4,
	    foo(X);
	Z 					% AD added clause
	  when Z =:= 1 ->			% This line should be indented by 2
	    X = 43 div 4,
	    foo(X);
	Z when					% AD added clause
	      Z =:= 2 ->				% This line should be indented by 2
	    X = 43 div 4,
	    foo(X);
	Z ->
	    X = 43 div 4,
	    foo(X) 
    after infinity ->
	    foo(X),
	    asd(X),
	    5*43
    end,
    receive
    after 10 -> 
	    foo(X),
	    asd(X),
	    5*43
    end,
    ok.

indent_fun() ->
    %% Changed fun to one indention level
    Var = spawn(fun(X) 
		      when X == 2;
			   X > 10 -> 
			hello,
			case Hello() of 
			    true when is_atom(X) -> 
				foo;
			    false ->
				bar
			end;
		   (Foo) when is_atom(Foo), 
			      is_integer(X) ->
			X = 6* 45,
			Y = true andalso
			    kalle
		end),
    ok.

indent_try_catch() ->
    try
	io:format(stdout, "Parsing file ~s, ", 
		  [St0#leex.xfile]),
	{ok,Line3,REAs,Actions,St3} = 
	    parse_rules(Xfile, Line2, Macs, St2)
    catch
	exit:{badarg,R} ->
	    foo(R),
	    io:format(stdout, 
		      "ERROR reason ~p~n",
		      R);
	error:R 				% AD added clause
	  when R =:= 42 ->			% when should be indented
	    foo(R);
	error:R 				% AD added clause
	  when					% when should be indented
	      R =:= 42 ->				% but unsure about this (maybe 2 more)
	    foo(R);
	error:R when				% AD added clause
	      R =:= foo ->				% line should be 2 indented (works)
	    foo(R);
	error:R ->
	    foo(R),
	    io:format(stdout, 
		      "ERROR reason ~p~n",
		      R)
    after
	foo('after'),
	file:close(Xfile)
    end;
indent_try_catch() ->
    try
	foo(bar)
    of
	X when true andalso
	       kalle ->
	    io:format(stdout, "Parsing file ~s, ",
		      [St0#leex.xfile]),
	    {ok,Line3,REAs,Actions,St3} =
		parse_rules(Xfile, Line2, Macs, St2);
	X 					% AD added clause
	  when false andalso			% when should be 2 indented
	       bengt ->
	    gurka();
	X when					% AD added clause
	      false andalso				% line should be 2 indented
	      not bengt ->
	    gurka();
	X ->
	    io:format(stdout, "Parsing file ~s, ",
		      [St0#leex.xfile]),
	    {ok,Line3,REAs,Actions,St3} =
		parse_rules(Xfile, Line2, Macs, St2)
    catch
	exit:{badarg,R} ->
	    foo(R),
	    io:format(stdout, 
		      "ERROR reason ~p~n",
		      R);
	error:R ->
	    foo(R),
	    io:format(stdout, 
		      "ERROR reason ~p~n",
		      R)
    after
	foo('after'),
	file:close(Xfile),
	bar(with_long_arg,
	    with_second_arg)
    end;
indent_try_catch() ->
    try foo()
    after 
	foo(),
	bar(with_long_arg,
	    with_second_arg)
    end.

indent_catch() ->
    D = B +
	float(43.1),

    B = catch oskar(X),

    A = catch (baz + 
		   bax),
    catch foo(),

    C = catch B + 
	float(43.1),

    case catch foo(X) of
	A ->
	    B
    end,

    case
	catch foo(X)
    of
	A ->
	    B
    end,

    case
	foo(X)
    of
	A ->
	    catch B,
	    X
    end,

    try sune of
	_ -> foo
    catch _:_ -> baf
    end,

    try
	sune
    of
	_ ->
	    X = 5,
	    (catch foo(X)),
	    X + 10
    catch _:_ -> baf
    end,

    try
	(catch sune)
    of
	_ ->
            catch foo()  %% BUGBUG can't handle catch inside try without parentheses
    catch _:_ ->
	    baf
    end,

    try
	(catch exit())
    catch
	_ ->
	    catch baf()
    end,
    ok.

indent_binary() ->
    X = lists:foldr(fun(M) ->
			    <<Ma/binary, " ">>
		    end, [], A),
    A = <<X/binary, 0:8>>,
    B.


indent_comprehensions() ->
    %% I don't have a good idea how we want to handle this 
    %% but they are here to show how they are indented today.
    Result1 = [X || 
		  #record{a=X} <- lists:seq(1, 10),
		  true = (X rem 2)
	      ],
    Result2 = [X || <<X:32,_:32>> <= <<0:512>>,
		    true = (X rem 2)
	      ],

    Binary1 = << <<X:8>> || 
		  #record{a=X} <- lists:seq(1, 10),
		  true = (X rem 2)
	      >>,

    Binary2 = << <<X:8>> || <<X:32,_:32>> <= <<0:512>>,
			    true = (X rem 2)
	      >>,
    ok.

%% This causes an error in earlier erlang-mode versions.
foo() ->
    [#foo{
	foo = foo}].
