# Food Delivery Route Finding System 🛵📍

An Artificial Intelligence Mini-Project developed in Prolog that determines the best routes for a food delivery system using classical search algorithms. 

This system compares different pathfinding algorithms to evaluate and extract the most optimal path (shortest distance) between cities in the delivery network.

## 🧠 Algorithms Implemented
This project implements three fundamental AI search algorithms from scratch to find routes across the road network:

1. **Depth-First Search (DFS):** Explores as far as possible along each branch before backtracking. Useful for exhaustive search but does not guarantee the shortest path.
2. **Breadth-First Search (BFS):** Explores all neighbor nodes at the present depth before moving on to the nodes at the next depth level. Guarantees the shortest path in terms of the *number of edges*, but not necessarily distance.
3. **A* Search (A-Star):** An informed search algorithm that uses heuristics (estimated distance to the goal) combined with the actual distance traveled. This is optimized to find the most cost-effective path efficiently. Includes advanced features like a `ClosedList` and Cycle Prevention for optimal graph searching.

## 🛠️ Prerequisites
To run this code, you will need a Prolog compiler. 
* We recommend **SWI-Prolog**. You can download it here: [https://www.swi-prolog.org/](https://www.swi-prolog.org/)

## 🚀 How to Run

1. Open your terminal or command prompt.
2. Navigate to the project directory.
3. Start SWI-Prolog and load the file by running:
   ```bash
   swipl -s final.pl
   ```
4. Once inside the Prolog interactive terminal (`?-`), you can query the system.

### Finding Routes
To find paths and compare all algorithms between two cities, use the `show_all_paths/2` predicate:

```prolog
?- show_all_paths(kandy, mahaiyawa).
```

This command will output:
- All paths found by **DFS** (with distances)
- All paths found by **BFS** (with distances)
- The optimal path found by **A***
- The **Overall Shortest Route** out of all combined results

### Example Output
```text
DFS results
Path= [kandy,katugastota,mahaiyawa]
 cost= 7.4
Path= [kandy,mahaiyawa]
 cost= 2.5

BFS results
Path= [kandy,mahaiyawa]
 cost= 2.5
Path= [kandy,katugastota,mahaiyawa]
 cost= 7.4

A* results
Path= [kandy,mahaiyawa]
 cost= 2.5

===== OVERALL SHORTEST ROUTE =====
Path: [kandy,mahaiyawa]
Distance: 2.5 km
```

## 🗂️ Adding New Data

### Adding Roads
You can expand the delivery network by adding new `road/3` facts at the top of `final.pl`:
```prolog
% road(CityA, CityB, DistanceInKm)
road(kandy, peradeniya, 6.1).
```
The system automatically treats all roads as bidirectional.

### Adding Heuristics for A*
For A* to work efficiently, it requires a "heuristic" (an estimate of the straight-line distance from a city to the goal). If you want to search for paths to a specific goal (e.g., `mahaiyawa`), ensure heuristic facts exist for that goal:
```prolog
% heuristic(CurrentCity, GoalCity, EstimatedDistance)
heuristic(kandy, mahaiyawa, 2).
heuristic(katugastota, mahaiyawa, 1.5).
```

## 🎓 Academic Context
This project was developed for **COU4303 Artificial Intelligence** (Level 04, Semester 2) at The Open University of Sri Lanka (OUSL).
