%---------------------------------------------------------------------------------
 
 
% --- The function 'myPRM_PP' computes straight line paths that are availbale between  
% --- all the probabilistic random points thrown in the knownMap and return
% --- the least path (minPath) between any arbitrary start and goal points by creating
% --- a directed graph of the points & using the shortest path algorithm.
 
%---------------------------------------------------------------------------------

function minPath = myPRM_PP(knownMap, start, goal, maxTries)

% minPath - the minimum path between start & goal along the random points
% start - start point
% goal - goal point
% maxTries - no of random points thrown on the knownMap
% knownMap - given map
 
knownMap(2,2) = 0;                                      % reset the two points in knownMap if they come occupied
knownMap(18,37) = 0;

[N,M] = size(knownMap);                                 % obtain the size of knownMap

rp = zeros(maxTries,2);                                 % rp is random points generation
for i = 1 : maxTries
    rp(i,:)= [randi(N), randi(M)];
    k = rp(i,:);                                        % k is temporary variable storing rp
    while knownMap(k(1),k(2)) ~= 0                      % if the generated random point is obstacle,
        rp(i,:)= [randi(N), randi(M)];                  % then generate a new point
        k = rp(i,:);
    end
end

% vertices that includes start point random points and goal point.
verts = [start;rp;goal];                       
edges = [];                                             % empty array for storing edges (straigh lines)                                  
temps = [];                                             % temporary array for creating path in map

for j = 1 : length(verts)                               % loop for checking path availability
    for k = j+1 : length(verts)
        q = 0;                                          % variable to indictae when there's not a path a
        t = [];                                         % temporary variable to creating path in map
        v1 = verts(j,:);                                % get the first vertex
        v2 = verts(k,:);                                % get the second vertex 

        m = (v2(2) - v1(2))/(v2(1) - v1(1));            % slope of straight line
        
        delx = abs(v1(1) - v2(1));                      % difference in x distance
        dely = abs(v1(2) - v2(2));                      % difference in y distance
 
        if delx > dely || delx == dely                  % condition check to move in x or y direction
            iter1 = [v1(1), v2(1)];                     % iterator1
            iter2 = [v1(2), v2(2)];                     % iterator2
            if iter1(1) > iter1(2)                      % decrement if the first value of iter1 > iter2 & increment otherwise
                l= -1;
            else
                l = 1;
            end
            for i = iter1(1):l: iter1(2)                % loop between the iterators with step l
                fprintf("loop x \n");
                v = round((i - iter1(1))*m + iter2(1)); % value of y when iterated in x direction
                if knownMap(i,v) ~= 0                   % if the new point (i,v) is an obstacle, 
                    fprintf("No path exist\n");         % then no path exist, so break from loop
                    q = 1;                              % set the temporary variable
                    break                               % break from loop
                else
                    t = [t;[i,v]];                      % update the variable t for a valid 
                    fprintf('(x,y) = (%d,%d)\n',i,v);   % step movement in path
                end
            end
        else
            iter1 = [v1(2), v2(2)];                     % iterator1
            iter2 = [v1(1), v2(1)];                     % iterator2
            if iter1(1) > iter1(2)                      % decrement if the first value of iter1 > iter2 & increment otherwise
                l= -1;
            else
                l = 1;
            end
            for i = iter1(1) : l : iter1(2)             % loop between the iterators with step l
                fprintf("loop y \n");
                v = round((i - iter1(1))/m + iter2(1)); % value of x when iterated in y direction
                if knownMap(v,i) ~= 0                   % if the new point (v,i,) is an obstacle,
                    fprintf("No path exist\n");         % then no path exist, so break from loop
                    q = 1;                              % set the temporary variable
                    break                               % break from loop
                else
                    t = [t;[v,i]];                      % update the variable t for a valid 
                    fprintf('(x,y) = (%d,%d)\n',v,i);   % step movement in path
                end
            end
        end
        if q ~= 1                                       % when there was no break (i.e. when there's
            edge = [j,k];                               % a valid path between two vertices then create
            edges = [edges;edge];                       % edge between those two vertices
            temps = [temps; t];                         % update this variable to use in representing
        end                                             % the path between the two vertices in the map
    end
end

% for a = 1 : length(temps)                             % represent path between the two vertices in the map
%     temp = temps(a,:);
%     knownMap(temp(1),temp(2)) = 15;                   % turquoise color to represent the path in the map 
% end                                                   % between two random points

k = verts(1,:);                                         % temporary variable to obtaining the start point
knownMap(k(1),k(2)) = 2;                                % represent a different color (turquoise) for start point

for i = 2 : length(verts)-1                     
    k = verts(i,:);
    knownMap(k(1),k(2)) = 4;                            % yellow color to represent the random ponts in the map 
end
k = verts(end,:);                                       % temporary variable to obtaining the goal point
knownMap(k(1),k(2)) = 3;                                % represent a different color (amber) for goal point

fprintf('\n')
disp("vertices = ");                                    % print the vertices
disp(verts)
s = edges(:,1)';                                        % variable to create directed graph
t = edges(:,2)';                                        % variable to create directed graph
G = digraph(s,t);                                       % creating directed graph
minPath = shortestpath(G,1,maxTries+2);                 % finding the shortest path in the graph 
if isempty(minPath) == 1                                % between start node 1 & goal node 32
    fprintf("No path exist between start & goal points"); % print no path exist when minPath is empty
end

% arrays for storing x,y,z values to plot lines over the surf plot
x = [];
y = [];
z = [];

% unpack values from the shortest path edges
for i = 1 : length(minPath)
    j = verts(minPath(i),:);
    x = [x ; j(2)];
    y = [y ; j(1)];
    if i == 1
        z = [z;2];
    elseif i == length(minPath)
        z = [z;3];
    else
        z = [z;4];
    end
end


% surface plot of the given map with the start, random points, goal point
% and all the shortest path
surf(knownMap)                                  
view(2)                                                 % top view
hold on 
plot3(x+0.5,y+0.5,z, "r-*", 'LineWidth',1.5, 'MarkerEdgeColor','k') % plot min cost path at mid-points
title('Path Planning - PRM')
hold off

end
