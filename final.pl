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
heuristic(gampola, gampola, 0).

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


%A*





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
    write('1. find path'),
    read(choice),
    handle(choice).
    
