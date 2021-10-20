YSurfOnly = YSurf;
i=1;
while(i<=size(YSurf, 1))
    if(ismember(YSurf(i), XZEdge))
        YSurfOnly(i)=0;
    end
    i=i+1;
end
YSurfOnly(YSurfOnly ==0) = [];
numElement_YSurfOnly_c2 = numElement(:,2);
gid_map_YSurfOnly = gid_map;
i = 1;
while(i<=size(numElement, 1))
    if(~ismember(numElement(i,1), YSurfOnly))
        numElement_YSurfOnly_c2(i) = 0;
        gid_map_YSurfOnly(gid_map == numElement(i,1)) = 0;
    end
    i=i+1
end
comp_mean_YSurfOnly = comp_mean;
grain_coord_YSurfOnly = grain_coord;
grain_rodV_YSurfOnly = grain_rodV;
comp_mean_YSurfOnly(numElement_YSurfOnly_c2 ==0, :) = [];
grain_coord_YSurfOnly(numElement_YSurfOnly_c2 ==0, :) = [];
grain_rodV_YSurfOnly(numElement_YSurfOnly_c2 == 0,:)=[];
numElement_YSurfOnly_c2(numElement_YSurfOnly_c2 == 0) = [];
numElement_YSurfOnly = zeros(size(YSurfOnly, 1),2);
numElement_YSurfOnly(:,1) = YSurfOnly;
numElement_YSurfOnly(:,2) = numElement_YSurfOnly_c2;
clear i numElement_YSurfOnly_c2;
