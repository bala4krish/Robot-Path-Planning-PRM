# Robot-Path-Planning-PRM
Path planning using probabilistic road maps

Matlab implementation of path planning using probabilistic road maps with a directed graph for a given 2D discretized static map of an environment with obstacles to find the minimum cost path between the arbitrary start and goal locations. This is achieved by finding valid edges (straight lines) between the vertices (the random points) and creating directed graph for shortest path calculation.

## Colors
Turquoise - start point <br />
Amber - goal point <br />
Yellow - random generated points <br />
Red - valid edges of the shortest path <br />
Dark Blue - Unoccupied cells <br />
Skyblue - obstacles <br />


![PRM](https://user-images.githubusercontent.com/56740627/71428820-3c2e4480-2691-11ea-8fe9-71f5fb5b105e.jpg)
