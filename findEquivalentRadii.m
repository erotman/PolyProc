function [equivalentRadii] = findEquivalentRadii(numElement, voxelSize)
%finds equivalent radii in micrometers, voxel size is the volume of a voxel in um^3
volume = numElement(:,2).*voxelSize;
equivalentRadii = zeros(size(numElement));
equivalentRadii(:,1) = numElement(:,1);

equivalentRadii(:,2) = (volume.*(3/4)./pi).^(1/3);

end