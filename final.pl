:- dynamic(blocked/2).

%roads
road(kandy, katugastota, 5.4).
road(kandy, peradeniya, 6.1).
road(kandy, tennakumbura, 7.7).
road(kandy, ampitiya, 5.2).
road(kandy, kundasale, 7.0).
road(kandy, getambe, 5.5).
road(kandy, mahaiyawa, 2.5).
road(katugastota, mahaiyawa, 2.0).


%Blocked Road(s)
blocked(kandy, kundasale).

% heuristic(Location, Goal, EstimatedDistance)
% --- Goal: gampola ---
heuristic(kandy, gampola, 20).
heuristic(peradeniya, gampola, 15).
heuristic(katugastota, gampola, 25).
heuristic(kundasale, gampola, 30).
heuristic(pilimathalawa, gampola, 10).
heuristic(gelioya, gampola, 12).
heuristic(kadugannawa, gampola, 8).
heuristic(mawilmada, gampola, 30).
heuristic(matale, gampola, 35).
heuristic(digana, gampola, 35).
heuristic(teldeniya, gampola, 40).
heuristic(tennakumbura, gampola, 22).
heuristic(ampitiya, gampola, 25).
heuristic(getambe, gampola, 18).
heuristic(mahaiyawa, gampola, 22).
heuristic(gampola, gampola, 0).

% --- Goal: mahaiyawa ---
heuristic(kandy, mahaiyawa, 2).
heuristic(katugastota, mahaiyawa, 1.5).
heuristic(peradeniya, mahaiyawa, 7).
heuristic(tennakumbura, mahaiyawa, 9).
heuristic(ampitiya, mahaiyawa, 6).
heuristic(kundasale, mahaiyawa, 8).
heuristic(getambe, mahaiyawa, 6).
heuristic(mahaiyawa, mahaiyawa, 0).

% --- Goal: kandy ---
heuristic(kandy, kandy, 0).
heuristic(katugastota, kandy, 5.4).
heuristic(peradeniya, kandy, 6.1).
heuristic(tennakumbura, kandy, 7.7).
heuristic(ampitiya, kandy, 5.2).
heuristic(kundasale, kandy, 7.0).
heuristic(getambe, kandy, 5.5).
heuristic(mahaiyawa, kandy, 2.5).

% --- Goal: katugastota ---
heuristic(kandy, katugastota, 5.4).
heuristic(katugastota, katugastota, 0).
heuristic(peradeniya, katugastota, 10.0).
heuristic(tennakumbura, katugastota, 12.0).
heuristic(ampitiya, katugastota, 9.0).
heuristic(kundasale, katugastota, 12.0).
heuristic(getambe, katugastota, 8.0).
heuristic(mahaiyawa, katugastota, 2.0).

% --- Goal: peradeniya ---
heuristic(kandy, peradeniya, 6.1).
heuristic(katugastota, peradeniya, 10.0).
heuristic(peradeniya, peradeniya, 0).
heuristic(tennakumbura, peradeniya, 8.0).
heuristic(ampitiya, peradeniya, 8.0).
heuristic(kundasale, peradeniya, 10.0).
heuristic(getambe, peradeniya, 8.0).
heuristic(mahaiyawa, peradeniya, 7.0).

% --- Goal: tennakumbura ---
heuristic(kandy, tennakumbura, 7.7).
heuristic(katugastota, tennakumbura, 11.0).
heuristic(peradeniya, tennakumbura, 8.0).
heuristic(tennakumbura, tennakumbura, 0).
heuristic(ampitiya, tennakumbura, 9.0).
heuristic(kundasale, tennakumbura, 12.0).
heuristic(getambe, tennakumbura, 10.0).
heuristic(mahaiyawa, tennakumbura, 9.0).

% --- Goal: ampitiya ---
heuristic(kandy, ampitiya, 5.2).
heuristic(katugastota, ampitiya, 9.0).
heuristic(peradeniya, ampitiya, 8.0).
heuristic(tennakumbura, ampitiya, 9.0).
heuristic(ampitiya, ampitiya, 0).
heuristic(kundasale, ampitiya, 6.0).
heuristic(getambe, ampitiya, 8.0).
heuristic(mahaiyawa, ampitiya, 6.0).

% --- Goal: kundasale ---
heuristic(kandy, kundasale, 7.0).
heuristic(katugastota, kundasale, 12.0).
heuristic(peradeniya, kundasale, 10.0).
heuristic(tennakumbura, kundasale, 12.0).
heuristic(ampitiya, kundasale, 6.0).
heuristic(kundasale, kundasale, 0).
heuristic(getambe, kundasale, 9.0).
heuristic(mahaiyawa, kundasale, 8.0).

% --- Goal: getambe ---
heuristic(kandy, getambe, 5.5).
heuristic(katugastota, getambe, 8.0).
heuristic(peradeniya, getambe, 8.0).
heuristic(tennakumbura, getambe, 10.0).
heuristic(ampitiya, getambe, 8.0).
heuristic(kundasale, getambe, 9.0).
heuristic(getambe, getambe, 0).
heuristic(mahaiyawa, getambe, 6.0).


list_blocked :-
    forall(
        blocked(A, B),
        (write(A-B), nl)
    ).

%Helps Prolog to understand bidirectional roads and avoid blocked roads
connected(A,B,D):-
    road(A,B,D), \+blocked(A,B).

connected(A,B,D):-
    road(B,A,D), \+blocked(B,A).

%DFS

dfs_path(Start, Goal, Path, Cost):-
	dfs_travel(Start, Goal, [Start], RevPath, 0, Cost),
	reverse(RevPath, Path).

dfs_travel(Node, Node, Path, Path, Cost, Cost).
dfs_travel(Current, Goal, Visited, Path, CostSoFar, Cost):-
	connected(Current, Next, StepCost),
	\+ member(Next, Visited),
	NewCost is CostSoFar + StepCost,
	dfs_travel(Next, Goal, [Next|Visited], Path, NewCost, Cost).

%BFS

bfs(Start, Goal, Path, Cost):-
	bfs_queue([[Start]], Goal, RevPath),
	reverse(RevPath, Path),
	path_cost(Path,Cost).

bfs_queue([[Goal|Rest]|_], Goal, [Goal|Rest]).
bfs_queue([[Current|Rest]|Other], Goal, Path) :-
	findall([Next,Current|Rest],
	(connected(Current, Next, _),
	\+ member(Next, [Current|Rest])),
	NewPaths),
	append(Other, NewPaths, Updated),
	bfs_queue(Updated, Goal, Path).


%path cost finder

path_cost([_],0).
path_cost([A,B|Rest],Cost):-
	connected(A,B,D),
	path_cost([B|Rest],CostRest),
	Cost is D + CostRest.




astar(Start, Goal, Path, Cost):-
    %This will be find the heuristic value from the facts and assign it to variable "H"
    heuristic(Start, Goal, H),
    %(OpenList,ClosedList,Goal,Path,Cost)
    a_star_recursion([[H, 0, [Start]]],[],Goal, ReversedPath, Cost),
    %Arrange the path from start to end
    reverse(ReversedPath,Path).

%The basecase for A* recursion search
%This whole base case is acting like a if statement connected with 'and' operators.
%Even if one part connected with ',' fails, the whole base case return false.
%So the base case get true only if CurrentCity equals to Goal otherwise it will keep recursing
a_star_recursion([[_, G, [CurrentCity | PastCities]] | _], _ClosedList, Goal, FinalPath, FinalCost) :-
    CurrentCity = Goal,
    FinalPath = [CurrentCity | PastCities],
    FinalCost = G.

%If the base case is failed, this will be executed
a_star_recursion([[_, G, [CurrentCity | PastCities]] | RestOfOpenList], ClosedList, Goal, FinalPath, FinalCost) :-
    %To avoid the time waste by checking already visited city, we check whether it visited or not using the closed list.
    ( \+ member(CurrentCity, ClosedList) ->
        % --- IF NOT VISITED: Expand it ---
        %This line of code will add the CurrentCity to the ClosedList, it helps algorithm not to visit already visited city again.
        NewClosedList = [CurrentCity|ClosedList],
        expand_node(CurrentCity, G, PastCities, Goal, NewPaths),
        %CombinedList is the name assigned for the list created by combining two lists.
        append(NewPaths, RestOfOpenList, CombinedList),
        %This sort predicate will sort the combined list and name it as SortedOpenList
        sort(CombinedList,SortedOpenList),
        %Calling the a_star_recursion again to function this as a loop
        a_star_recursion(SortedOpenList, NewClosedList, Goal, FinalPath, FinalCost)
    ;
        % --- ELSE (ALREADY VISITED): Skip it and keep searching ---
        a_star_recursion(RestOfOpenList, ClosedList, Goal, FinalPath, FinalCost)
    ).

%This predicate is for find new paths available from current city
expand_node(CurrentCity, G, PastCities, Goal, NewPaths) :-
    findall(
        
        [NewF, NewG, [NextCity, CurrentCity | PastCities]],
        (
            %This custom made predicate use for find the available roads leading to adjacent cities
            connected(CurrentCity, NextCity, Distance),
            \+ member(NextCity, [CurrentCity | PastCities]), % Prevent immediate loops
            NewG is G + Distance,
            heuristic(NextCity, Goal, H),
            NewF is NewG + H
        ),
        %The List name holding all the new paths found.
        NewPaths
    ).

%Display results

show_all_paths(Start, Goal):-
    nl, 
    write('DFS results'), nl,
	findall([Pdfs,Cdfs],dfs_path(Start, Goal, Pdfs, Cdfs), DfsPaths),
    display_paths(DfsPaths), nl,
    write('BFS results'), nl,
    findall([Pbfs,Cbfs],bfs(Start, Goal, Pbfs, Cbfs), BfsPaths),
    display_paths(BfsPaths), nl,
    write('A* results'), nl,
    findall([Pa,Ca], astar(Start, Goal, Pa, Ca), APaths),
    display_paths(APaths),

    %----------------------------------------------
    %need to study

    % Combine results from all algorithms
    append(DfsPaths, BfsPaths, TempPaths),
    append(TempPaths, APaths, AllPaths),

    % Find overall shortest path
    shortest_path(AllPaths, ShortestPath, ShortestCost),

    nl,
    write('===== OVERALL SHORTEST ROUTE ====='), nl,
    write('Path: '), write(ShortestPath), nl,
    write('Distance: '), write(ShortestCost), write(' km'), nl.

    %--------------------------------------------------




display_paths([]).
display_paths([[P,C]|Rest]) :-
	write('Path= '), write(P), nl,
	write(' cost= '), write(C), nl, nl,
	display_paths(Rest).


%-------------------------------------------------------
%need to study
% Find path with the smallest distance
shortest_path([[Path, Cost] | Rest], ShortestPath, ShortestCost) :-
    shortest_path(Rest, Path, Cost, ShortestPath, ShortestCost).

shortest_path([], Path, Cost, Path, Cost).

shortest_path([[Path, Cost] | Rest],
              CurrentPath, CurrentCost,
              ShortestPath, ShortestCost) :-

    ( Cost < CurrentCost ->
        NewPath = Path,
        NewCost = Cost
    ;
        NewPath = CurrentPath,
        NewCost = CurrentCost
    ),

    shortest_path(Rest,
                  NewPath,
                  NewCost,
                  ShortestPath,
                  ShortestCost).

%----------------------------------------------


%--------------Interface-----------------------

menu:-

    nl, write('====== Food Delivery Route Finding System ======='), nl,
    write('1. Find path: '), nl,
    write('2. Block a road: '), nl,
    write('3. Unblock a road: '), nl,
    write('4. View blocked roads: '), nl,
    write('5. Exit'), nl,
    nl, write('Enter your choice: '),
    read(Choice),
    handle(Choice).

handle(1):-
    nl, write('Enter start location: '),
    read(Start),
    nl, write('Enter destination: '),
    read(Goal),
    show_all_paths(Start, Goal), menu ; nl, write('invalid input'), !, nl,
    menu.

handle(2):-
    nl, write('Enter the starting location of the road to block: '),
    read(Start),
    nl, write('Enter the ending location of the road to block: '),
    read(End),
    assertz(blocked(Start, End)),
    assertz(blocked(End, Start)),
    nl, write(Start - End), write(': Road blocked successfully.'), nl,
    menu.

handle(3):-
    nl, write('Enter the starting location of the road to unblock: '),
    read(Start),
    nl, write('Enter the ending location of the road to unblock: '),
    read(End),
    retractall(blocked(Start, End)),
    retractall(blocked(End, Start)),
    nl, write(Start - End), write(': Road unblocked successfully.'), nl,
    menu.

handle(4):-
    nl, write('Blocked roads details:'), nl, nl,
    list_blocked,
    menu.

handle(5):-
    nl, write('Exiting the program. Goodbye!'), nl.

handle(_):-
    nl, write('Invalid choice. Please try again.'), nl,
    menu.


