
function grain_clean_up_continue(gid_map_new, iter, adj, noGrains, goodPairs, grain_rodV, misoriThresh, cs, saveFile)

    % Now the fun stuff: clustering operation
    while iter < size(adj,1)

        % Pick two touching grains in adj set
        i = adj(iter,1); % adj(quickInd,1);
        j = adj(iter,2); % adj(quickInd,2); 

        if ~ismember([i,j], goodPairs, 'rows')

            fprintf(' No. Grains = %d. Checking Grains %d and %d ... \n', ...
                    noGrains-1, i, j);

            % Compute their misorientation
            q1 = rodrigues2quat(vector3d(grain_rodV(i,:)));   % CHANGED from "rodrigues"
            o1 = orientation(q1, cs);
            q2 = rodrigues2quat(vector3d(grain_rodV(j,:)));
            o2 = orientation(q2, cs);
            misori = angle(o1,o2)/degree;

            % If their misorientation is less than pre-set value, then ...
            if misori < misoriThresh

                % (i) Combine the smaller grain into the larger 
                if sum(gid_map_new(:) == i) > sum(gid_map_new(:) == j)
                   gid_map_new(gid_map_new == j) = i;
                else
                   gid_map_new(gid_map_new == i) = j;
                end
                iter = 1;

                % (ii) Recompute the number of grains after clustering
                noGrains = noGrains - 1;

                % (iii) Recompute the grains that touch (adjacent grains)
                adj = imRAG(gid_map_new);
                adj((adj(:,1) > adj(:,2)),:) = [];

            else
                % Keep marching through the list of neighbors in adj
                iter = iter+1;
                goodPairs = [goodPairs; i,j];

            end

        else
            % Keep marching through the list of neighbors in adj
            iter = iter+1;
        end 
    end
    fprintf('Angular thresholding is complete. Number of grains = %d\n', noGrains-1);
    save(saveFile);
    
end
