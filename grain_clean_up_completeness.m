function [gid_map, rodV, comp, numElement, grain_rodV, grain_coord, grain_surface, adj, cs] = ...
                    grain_clean_up_completeness(gid_map, grain_size_mini, completeness_mini, rodV, comp, cs)

    gid_mask = gid_map;
    gid_mask(gid_mask == 0) = [];
    numElement = accumarray(gid_mask(:),1);
    numElement_in = [1:length(numElement)]';
    numElement = [numElement_in, numElement];
    numElement_in(numElement(:,2) >= grain_size_mini) = [];
    gid_map(ismember(gid_map,numElement_in)) = 0;
    
    % update adj and numElement
    numElement(numElement(:,2) < grain_size_mini,:) = [];
    adj = imRAG(gid_map);
    adj((adj(:,1) > adj(:,2)),:) = [];
    unique_gid = unique(adj);
    numElement(~ismember(numElement(:,1),unique(gid_map)),:) = [];          %was numElement(~ismember(numElement(:,1),unique_gid),:) = [];
    
    clear gid_mask numElement_in grain_size_mini
    fprintf('Volume thresholding is complete.\n')
    
    %% Clean up by Completeness Threshold
    
    comp_mean = zeros(length(numElement),1);
    % calculate completeness of grain (voxel average completeness)
    for i = 1:length(numElement(:,1))
        comp_mean(i) = mean(comp(gid_map==numElement(i,1)));
        placeMarker=i
    end
    % remove grains with low completeness
    untrust_grain = numElement((0<comp_mean & comp_mean<completeness_mini),1);
    gid_map(ismember(gid_map,untrust_grain))=0;
    numElement(ismember(numElement(:,1),untrust_grain),:)=[];
    
    % update adj
    adj = imRAG(gid_map);
    adj((adj(:,1) > adj(:,2)),:) = [];
    
    clear comp_mean i completeness_mini untrust_grain
    fprintf('Completeness thresholding is complete.\n')

    
    gid_map_copy = gid_map;
    gid_map_filled = imfill(logical(gid_map_copy),'holes');
    gid_map_copy(gid_map_filled==0) = -100;
    
    adj_interior = imRAG(gid_map_copy);
    grain_surface = adj_interior(adj_interior(:,1)==-100,2);   
    
    %% Update variables
    grain_rodV = zeros(length(numElement(:,1)),3);
    grain_coord = grain_rodV;
    % update grain-averaged Rodrigues vectors    
    for i = 1:length(numElement(:,1))
        placeMarker = i
        [x,y,z] = ind2sub(size(gid_map),find(gid_map==numElement(i,1)));
        grain_coord(i,:) = round(mean([x,y,z]));
        grain_rodV(i,1) = nanmean(rodV(sub2ind(size(rodV), ...
                1*ones(size(x)),x,y,z)));
        grain_rodV(i,2) = nanmean(rodV(sub2ind(size(rodV), ...
                2*ones(size(x)),x,y,z)));
        grain_rodV(i,3) = nanmean(rodV(sub2ind(size(rodV), ...
                3*ones(size(x)),x,y,z)));
    end
    
end
