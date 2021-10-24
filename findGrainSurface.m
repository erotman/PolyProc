function [YSurf, XZEdge, TotalSurf] = findGrainSurface(gid_map, firstX, lastX, firstY, lastY, firstZ, lastZ, firstYThresh, lastYThresh)

firstX(firstX==0) = 1;
lastX(lastX==0) = size(gid_map, 1);
firstY(firstY==0) = 1;
lastY(lastY==0) = size(gid_map, 2);
firstZ(firstZ==0) = 1;
lastZ(lastZ==0) = size(gid_map, 3);

firstY_gid_map = ones(size(firstY));
ix=1;
while(ix<=size(gid_map,1))
    iz=1;
    while(iz<=size(gid_map,3))
        firstY_gid_map(ix, iz) = gid_map(ix, firstY(ix, iz), iz);
        iz=iz+1;
    end
    ix=ix+1
end

lastY_gid_map = ones(size(lastY));
ix=1;
while(ix<=size(gid_map,1))
    iz=1;
    while(iz<=size(gid_map,3))
        lastY_gid_map(ix, iz) = gid_map(ix, lastY(ix, iz), iz);
        iz=iz+1;
    end
    ix=ix+1
end


firstX_gid_map = ones(size(firstX));
iy=1;
while(iy<=size(gid_map,2))
    iz=1;
    while(iz<=size(gid_map,3))
        firstX_gid_map(iy, iz) = gid_map(firstX(iy, iz), iy, iz);
        iz=iz+1;
    end
    iy=iy+1
end


lastX_gid_map = ones(size(lastX));
iy=1;
while(iy<=size(gid_map,2))
    iz=1;
    while(iz<=size(gid_map,3))
        lastX_gid_map(iy, iz) = gid_map(lastX(iy, iz), iy, iz);
        iz=iz+1;
    end
    iy=iy+1
end

firstZ_gid_map = ones(size(firstZ));
ix=1;
while(ix<=size(gid_map,1))
    iy=1;
    while(iy<=size(gid_map,2))
        firstZ_gid_map(ix, iy) = gid_map(ix, iy, firstZ(ix, iy));
        iy=iy+1;
    end
    ix=ix+1
end


lastZ_gid_map = ones(size(lastZ));
ix=1;
while(ix<=size(gid_map,1))
    iy=1;
    while(iy<=size(gid_map,2))
        lastZ_gid_map(ix, iy) = gid_map(ix, iy, lastZ(ix, iy));
        iy=iy+1;
    end
    ix=ix+1
end

firstYSurf= unique(firstY_gid_map.*(firstY <= firstYThresh));
lastYSurf = unique(lastY_gid_map.*(lastY >= lastYThresh));

YSurf = unique([firstYSurf;lastYSurf]);


firstXSurf= unique(firstX_gid_map);
lastXSurf = unique(lastX_gid_map);
firstZSurf= unique(firstZ_gid_map);
lastZSurf = unique(lastZ_gid_map);

XZEdge = unique([firstXSurf;lastXSurf;firstZSurf;lastZSurf]);

TotalSurf = unique([YSurf;XZEdge]);

YSurf(1) = [];
XZEdge(1) = [];
TotalSurf(1) = [];

end




