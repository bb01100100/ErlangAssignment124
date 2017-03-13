% Course: Future Learn - Functional programming in Erlang
% Assignment:  1.24
% Author: Kel Graham
-module(assignment124).
-export([perimeter/1, area/1, hypot/2, enclose/1, shape_test/0, sum/1, bit_test/0]).

% ############################################################################## 
% Functions
% ############################################################################## 


% Calculate the perimeter of a square
perimeter({square, Width, Height}) ->
	(Width+Height)*2;

% Calculate perimeter of right-angled triangle
perimeter({triangle, Width, Height}) ->
	% Assumes right-angled triangle
	%(Width + Height) + math:sqrt(Width*Height).
	Width + Height + hypot(Width, Height);


% Calculate the perimeter of triangle, given three sides
perimeter({triangle, A, B, C}) ->
	% Assumes three sides given
	A+B+C;

perimeter({circle, D}) ->
	D * math:pi().

% Calculate the hypotenuse of a right-angled triangle (exported for convenience)
hypot(Width,Height) ->
	math:sqrt( math:pow(Width,2) + math:pow(Height,2) ).

% Calculate the area of a square
area({square, Width, Height}) ->
	Width*Height;

% Calculate the area of a right-angled triangle
area({triangle, Width, Height}) ->
	% Right angle triangle
	(Width*Height)/2;

% Calculate the area of a triangle given three sides
area({triangle, A, B, C}) ->
	% Area = heron's method
	S = perimeter({triangle,A,B,C})/2,
	math:sqrt(S * (S-A) * (S-B) * (S-C));
	
area({circle, D}) ->
	math:pi() * math:pow(D/2,2).

% ##############################################################################
% Return the smallest *enclosing* rectangle of the shape.
% ##############################################################################

enclose({square, A, B}) ->
	{square, A, B};


% Right-angled triangle
enclose({triangle, A, B}) ->
	{square, A, B};

% Acute triangle, three sides given
enclose({triangle, A, B, C}) ->
	% We know the area wil be 2x the triangle's area
	Area=area({triangle, A, B, C}),
	LongestSide=lists:max([A,B,C]),
	OtherSide=2*Area / LongestSide,
	{square, OtherSide, LongestSide};

enclose({circle, D}) ->
	{square, D, D}.


shape_test() ->
	Square = {square, 3, 3},
	Triangle = {triangle, 3, 4, 5},
	Circle = {circle, 3},

	12 = perimeter(Square),
	12 = perimeter(Triangle),
	9.42477796076938 = perimeter(Circle),

	9 = area(Square),
	6.0 = area(Triangle),
	7.0685834705770345 = area(Circle),

	{square, 3, 3} = enclose(Square),
	{square, 2.4, 5} = enclose(Triangle),
	{square, 3, 3} = enclose(Circle),

	io:format("all tests passed~n").



% ##############################################################################
% Sum the bits of a positive integer
% ##############################################################################

sum(N) when N>0 ->
	BaseTwo = math:log2(N) - trunc(math:log2(N)) =:= 0.0, 
	sumHead(0, N, BaseTwo);

sum(0) -> 0.


sumHead(_, _, true) -> 
	% If the head is log2(N) then all the other bits are 0, so just return 1
	1;

sumHead(_, N, BaseTwo) -> lists:sum(sumP([], N, BaseTwo)).

sumP(Subtotal, 0, _) -> Subtotal;
sumP(Subtotal, 1, _) -> Subtotal ++ [1];

sumP(Subtotal, N, true) when N>1 ->
	BaseTwo = math:log2(N-1) - trunc(math:log2(N-1)) =:= 0.0,
	sumP(Subtotal ++ [1], N-1, BaseTwo);

sumP(Subtotal, N, false) when N>1 ->
	BaseTwo = math:log2(N-1) - trunc(math:log2(N-1)) =:= 0.0,
	sumP(Subtotal ++ [0], N-1, BaseTwo).


bit_test() ->
	1 = sum(8),
	3 = sum(7),
	io:format("all bit tests passed~n").
