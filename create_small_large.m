
function [gid_map_small, gid_map_large, grain_rodV_small, grain_rodV_large, numElement_small, numElement_large, comp_mean_small, comp_mean_large, grain_coord_small, grain_coord_large] = create_small_large(gid_map, grain_rodV, numElement, comp_mean, grain_coord, sizeThresh)

numElement_small = [0,0;0,0]
numElement_large = [0,0;0,0]

i=1;
smallI = 1;
largeI = 1;
while(i<size(numElement, 1))
    if(numElement(i,2)<=sizeThresh)
        numElement_small(smallI, :) = numElement(i,:);
        smallI = smallI + 1;
    else
        numElement_large(largeI, :) = numElement(i,:);
        largeI = largeI + 1;
    end
    i=i+1
end

gid_map_small = gid_map;
gid_map_large = gid_map;
grain_rodV_small = zeros(size(numElement_small, 1),3);
grain_rodV_large = zeros(size(numElement, 1)-size(numElement_small, 1), 3);
comp_mean_small = zeros(size(numElement_small, 1));
comp_mean_large = zeros(size(numElement, 1)-size(numElement_small, 1));
grain_coord_small = zeros(size(numElement_small, 1),3);
grain_coord_large = zeros(size(numElement, 1)-size(numElement_small, 1), 3);

i=1;
smallIndex = 1;
largeIndex = 1;
while(i<=size(numElement, 1))
    if(ismember(numElement(i,1), numElement_small(:,1)))
        gid_map_large=gid_map_large.*(gid_map_large ~= numElement(i,1));
        grain_rodV_small(smallIndex, :) = grain_rodV(i,:);
        comp_mean_small(smallIndex) = comp_mean(i);
        numElement_small(smallIndex, :) = numElement(i,:);
        grain_coord_small(smallIndex, :) = grain_coord(i,:);
        smallIndex = smallIndex+1;
    else
        gid_map_small = gid_map_small.*(gid_map_small ~= numElement(i,1));
        grain_rodV_large(largeIndex, :) = grain_rodV(i,:);
        comp_mean_large(largeIndex) = comp_mean(i);
        numElement_large(largeIndex, :) = numElement(i,:);
        grain_coord_large(largeIndex, :) = grain_coord(i,:);
        largeIndex = largeIndex+1;
    end
    i=i+1
end