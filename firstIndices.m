function [firstX, lastX, firstY, lastY, firstZ, lastZ] = firstIndices(GrainId)
firstX = zeros(size(GrainId, [2,3]));
iy=1;
while(iy<=size(GrainId,2))
    iz=1
    while(iz <= size(GrainId,3))
        ix = 1;
        while(ix <= size(GrainId,1)&&GrainId(ix,iy,iz)==0)
            ix = ix+1;
        end
        if(ix <= size(GrainId,1))
            firstX(iy, iz) = ix;
            ix=ix
        end
        iz=iz+1;
    end
    iy=iy+1;
end

lastX = zeros(size(GrainId, [2,3]));
iy = 1;
while(iy<=size(GrainId, 2))
    iz = 1;
    while(iz <= size(GrainId,3))
        ix = size(GrainId, 1);
        while(ix >= 1 && GrainId(ix,iy,iz)==0)
            ix = ix-1;
        end
        if(ix >= 1)
            lastX(iy, iz) = ix;
            ix=ix
        end
        iz=iz+1;
    end
    iy=iy+1;
end

firstY = zeros(size(GrainId, [1,3]));
ix = 1;
while(ix <=size(GrainId,1))
    iz = 1;
    while(iz <= size(GrainId,3))
        iy = 1;
        while(iy <= size(GrainId,2)&&GrainId(ix,iy,iz)==0)
            iy = iy+1;
        end
        if(iy <= size(GrainId,2))
            firstY(ix, iz) = iy;
            iy=iy
        end
        iz=iz+1;
    end
    ix=ix+1;
end

lastY = zeros(size(GrainId, [1,3]));
ix = 1;
while(ix <=size(GrainId,1))
    iz = 1;
    while(iz <= size(GrainId,3))
        iy = size(GrainId, 2);
        while(iy >= 1 && GrainId(ix,iy,iz)==0)
            iy = iy-1;
        end
        if(iy >= 1)
            lastY(ix, iz) = iy;
            iy=iy
        end
        iz=iz+1;
    end
    ix=ix+1;
end

firstZ = zeros(size(GrainId, [1,2]));
ix = 1;
while(ix <=size(GrainId,1))
    iy = 1;
    while(iy <= size(GrainId,2))
        iz = 1;
        while(iz <= size(GrainId,3)&&GrainId(ix,iy,iz)==0)
            iz = iz+1;
        end
        if(iz <= size(GrainId,3))
            firstZ(ix, iy) = iz;
            iz=iz
        end
        iy=iy+1;
    end
    ix=ix+1;
end

lastZ = zeros(size(GrainId, [1,2]));
ix = 1;
while(ix <=size(GrainId,1))
    iy = 1;
    while(iy <= size(GrainId,2))
        iz = size(GrainId, 3);
        while(iz >= 1 && GrainId(ix,iy,iz)==0)
            iz = iz-1;
        end
        if(iz >= 1)
            lastZ(ix, iy) = iz;
            iz=iz
        end
        iy=iy+1;
    end
    ix=ix+1;
end

end


