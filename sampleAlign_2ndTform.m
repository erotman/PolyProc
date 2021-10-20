function [firstY, n, rotRodV, affineRot] = sampleAlign_2ndTform(GrainId, firstYThresh)
%creates grid of lowest, non-zero y-coordinate for each (x,z) coordinate
%pair.
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
firstY = firstY.*(firstY <= firstYThresh);

%creates a nx3 matrix of the x,z, and y values
firstYList = [0,0,0;0,0,0];
listIndex = 1;
x=1;
while x <= size(firstY,1)
    z = 1;
    while z <= size(firstY,2)
        firstYList(listIndex, [1,2,3]) = [x,z,firstY(x,z)];
        z=z+1;
        listIndex = listIndex+1;
    end
    x=x+1
end
%runs a least-squares regression on data
n = fitNormal(firstYList,0);
%creates normal vector to the plane and finds the angles and rotations
%which transform the y vector to this vector.
nVec = vector3d(n(1),n(3),n(2));
yVec = vector3d(0,1,0);
ynangle = angle(yVec,nVec);
ynNorm = cross(nVec,yVec);
ynunitNorm = ynNorm./abs(ynNorm);
quatRot = axis2quat(ynunitNorm.x, ynunitNorm.y,ynunitNorm.z,ynangle);
[Rx,Ry,Rz] = Euler(quatRot);

% Rotation
    % Rotation about x axis
    Rotation_x = [1,0,0,0;0,cosd(Rx),sind(Rx),0;0,-sind(Rx),cosd(Rx),0;0,0,0,1];
    % Rotation about y axis
    Rotation_y = [cosd(Ry),0,-sind(Ry),0;0,1,0,0;sind(Ry),0,cosd(Ry),0;0,0,0,1];
    % Rotation about y axis
    Rotation_z= [cosd(Rz),sind(Rz),0,0;-sind(Rz),cosd(Rz),0,0;0,0,1,0;0,0,0,1];
    
% Euler rotation matrix
    rot_x = rotation('axis', xvector,'angle', -Ry*degree);
    rot_y = rotation('axis', yvector,'angle', -Rx*degree); % isosurface flips x & y axis
    rot_z = rotation('axis', zvector,'angle', -Rz*degree); % %mtex and matlab axis direction is opposite
    
    %rodrigues vectors
    rotRodV = Rodrigues(quatRot);
% Full transformation matrix
    
   affineRot = affine3d(Rotation_x*Rotation_y*Rotation_z);
end