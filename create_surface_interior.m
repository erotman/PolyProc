
function [gid_map_surf, gid_map_int, grain_rodV_surf, grain_rodV_int, numElement_surf, numElement_int, comp_mean_surf, comp_mean_int, grain_coord_surf, grain_coord_int] = create_surface_interior(gid_map, grain_rodV, numElement, comp_mean, grain_coord, TotalSurf)
    
gid_map_surf = gid_map;
gid_map_int = gid_map;
grain_rodV_surf = zeros(size(TotalSurf, 1),3);
grain_rodV_int = zeros(size(numElement, 1)-size(TotalSurf, 1), 3);
numElement_surf = zeros(size(TotalSurf, 1), 2);
numElement_int = zeros(size(numElement, 1)-size(TotalSurf, 1), 2);
comp_mean_surf = zeros(size(TotalSurf, 1));
comp_mean_int = zeros(size(numElement, 1)-size(TotalSurf, 1));
grain_coord_surf = zeros(size(TotalSurf, 1));
grain_coord_int = zeros(size(numElement, 1)-size(TotalSurf, 1));

i=1;
surfIndex = 1;
intIndex = 1;
while(i<=size(numElement, 1))
    if(ismember(numElement(i,1), TotalSurf))
        gid_map_int=gid_map_int.*(gid_map_int ~= numElement(i,1));
        grain_rodV_surf(surfIndex, :) = grain_rodV(i,:);
        comp_mean_surf(surfIndex) = comp_mean(i);
        numElement_surf(surfIndex, :) = numElement(i,:);
        grain_coord_surf(surfIndex, :) = grain_coord(i,:);
        surfIndex = surfIndex+1;
    else
        gid_map_surf = gid_map_surf.*(gid_map_surf ~= numElement(i,1));
        grain_rodV_int(intIndex, :) = grain_rodV(i,:);
        comp_mean_int(intIndex) = comp_mean(i);
        numElement_int(intIndex, :) = numElement(i,:);
        grain_coord_int(intIndex, :) = grain_coord(i,:);
        intIndex = intIndex+1;
    end
    i=i+1
end