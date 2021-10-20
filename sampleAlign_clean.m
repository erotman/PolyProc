function [firstY, n] = sampleAlign(GrainId)
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

% rowNum = 1;
% Bvector = zeros(size(firstY,2));
% while(rowNum <= size(firstY,1))
%     rowVec = firstY(rowNum,(firstY(rowNum,:)~=0))
%     linVec = ones(size(rowVec));
%     linVecI =1;
%     while linVecI <= size(linVec)
%         linVec(linVecI) = linVecI;
%         linVecI = linVecI+1;
%     end
%     p = polyfit(linVec,rowVec,1)
%     Bvector(rowNum) = p(1);
%     rowNum = rowNum+1;
% end
% Bmean = mean(Bvector);
data = [0,0,0;0,0,0];
dataI = 1;
x=1;
while x <= size(firstY,1)
    z = 1;
    while z <= size(firstY,2)
        data(dataI, [1,2,3]) = [x,z,firstY(x,z)];
        z=z+1;
        dataI = dataI+1;
    end
    x=x+1
end
n = fitNormal(data,0);
nVec = vector3d(n(1),n(3),n(2));
yVec = vector3d(0,1,0);
ynangle = angle(yVec,nVec);
ynNorm = cross(nVec,yVec);
ynunitNorm = ynNorm./abs(ynNorm)
quatRot = axis2quat(nVec.x, nVec.y,nVec.z,ynangle);
[Rx,Ry,Rz] = Euler(quatRot);
    Rotation_x = [1,0,0,0;0,cosd(Rx),sind(Rx),0;0,-sind(Rx),cosd(Rx),0;0,0,0,1];
    Rotation_y = [cosd(Ry),0,-sind(Ry),0;0,1,0,0;sind(Ry),0,cosd(Ry),0;0,0,0,1];
    Rotation_z= [cosd(Rz),sind(Rz),0,0;-sind(Rz),cosd(Rz),0,0;0,0,1,0;0,0,0,1];
    rot_x = rotation('axis', xvector,'angle', -Ry*degree);
    rot_y = rotation('axis', yvector,'angle', -Rx*degree); % isosurface flips x & y axis
    rot_z = rotation('axis', zvector,'angle', -Rz*degree); % %mtex and matlab axis direction is opposite
    rotRodv = Rodrigues(quatRot);
    
    affineRot = affine3d(Rotation_x*Rotation_y*Rotation_z);
end