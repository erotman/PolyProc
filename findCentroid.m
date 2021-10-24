function findCentroid(absData, gid_map, numElement, grain_coord, grain_rodV, comp_mean, fileName)

[xSpace, ySpace, zSpace] = meshgrid(1:size(absData,1), 1:size(absData, 2), 1:size(absData, 3));
xSpace = permute(xSpace, [2,1,3]);
ySpace = permute(ySpace, [2,1,3]);
zSpace = permute(zSpace, [2,1,3]);

xMean = sum(sum(sum(xSpace)))/(sum(sum(sum(xSpace~=0))));
yMean = sum(sum(sum(ySpace)))/(sum(sum(sum(ySpace~=0))));
zMean = sum(sum(sum(zSpace)))/(sum(sum(sum(zSpace~=0))));

distList = zeros(size(grain_coord, 1));
i=1;
while(i<=size(grain_coord, 1))
    distList(i) = sqrt((grain_coord(i,1)-xMean).^2+(grain_coord(i,2)-yMean).^2);
    i=i+1
end
distList_LT100 = distList.*(distList<100);
distList_100to200 = distList.*(distList<200 & distList>=100);
distList_200to300 = distList.*(distList<300 & distList>=200);
distList_300to400 = distList.*(distList>=300 & distList<400);
distList_GT400 = distList.*(distList>=400);

distList = distList(:,1);
distList_LT100 = distList_LT100(:,1);
distList_100to200 = distList_100to200(:,1);
distList_200to300 = distList_200to300(:,1);
distList_300to400 = distList_300to400(:,1);
distList_GT400 = distList_GT400(:,1);

grain_coord_LT100 = zeros(sum(distList_LT100 ~= 0), 3);
grain_coord_100to200 = zeros(sum(distList_100to200 ~= 0), 3);
grain_coord_200to300 = zeros(sum(distList_200to300 ~= 0), 3);
grain_coord_300to400 = zeros(sum(distList_300to400 ~= 0 ), 3);
grain_coord_GT400 = zeros(sum(distList_GT400 ~= 0), 3);

numElement_LT100 = zeros(sum(distList_LT100 ~= 0), 2);
numElement_100to200 = zeros(sum(distList_100to200 ~= 0), 2);
numElement_200to300 = zeros(sum(distList_200to300 ~= 0), 2);
numElement_300to400 = zeros(sum(distList_300to400 ~= 0 ), 2);
numElement_GT400 = zeros(sum(distList_GT400 ~= 0), 2);

grain_rodV_LT100 = zeros(sum(distList_LT100 ~= 0), 3);
grain_rodV_100to200 = zeros(sum(distList_100to200 ~= 0), 3);
grain_rodV_200to300 = zeros(sum(distList_200to300 ~= 0), 3);
grain_rodV_300to400 = zeros(sum(distList_300to400 ~= 0 ), 3);
grain_rodV_GT400 = zeros(sum(distList_GT400 ~= 0), 3);

comp_mean_LT100 = zeros(sum(distList_LT100 ~= 0), 1);
comp_mean_100to200 = zeros(sum(distList_100to200 ~= 0), 1);
comp_mean_200to300 = zeros(sum(distList_200to300 ~= 0), 1);
comp_mean_300to400 = zeros(sum(distList_300to400 ~= 0 ), 1);
comp_mean_GT400 = zeros(sum(distList_GT400 ~= 0), 1);

gid_map_LT100 = gid_map;
gid_map_100to200 = gid_map;
gid_map_200to300 = gid_map;
gid_map_300to400 = gid_map;
gid_map_GT400 = gid_map;

i=1;
i_LT100=1;
i_100to200=1;
i_200to300=1;
i_300to400=1;
i_GT400=1;
while(i<=size(numElement, 1))
    if(distList_LT100(i)~=0)
        grain_coord_LT100(i_LT100,:) = grain_coord(i,:);
        numElement_LT100(i_LT100,:) = numElement(i,:);
        grain_rodV_LT100(i_LT100,:) = grain_rodV(i,:);
        comp_mean_LT100(i_LT100) = comp_mean(i);
        gid_map_100to200 = gid_map_100to200.*(gid_map_100to200 ~= numElement(i,1));
        gid_map_200to300 = gid_map_200to300.*(gid_map_200to300 ~= numElement(i,1));
        gid_map_300to400 = gid_map_300to400.*(gid_map_300to400 ~= numElement(i,1));
        gid_map_GT400 = gid_map_GT400.*(gid_map_GT400 ~= numElement(i,1));
        i_LT100 = i_LT100+1;
    else if(distList_100to200(i)~=0)
        grain_coord_100to200(i_100to200,:) = grain_coord(i,:);
        numElement_100to200(i_100to200,:) = numElement(i,:);
        grain_rodV_100to200(i_100to200,:) = grain_rodV(i,:);
        comp_mean_100to200(i_100to200) = comp_mean(i);
        gid_map_LT100 = gid_map_LT100.*(gid_map_LT100 ~= numElement(i,1));
        gid_map_200to300 = gid_map_200to300.*(gid_map_200to300 ~= numElement(i,1));
        gid_map_300to400 = gid_map_300to400.*(gid_map_300to400 ~= numElement(i,1));
        gid_map_GT400 = gid_map_GT400.*(gid_map_GT400 ~= numElement(i,1));
        i_100to200 = i_100to200+1;
    else if(distList_200to300(i)~=0)
        grain_coord_200to300(i_200to300,:) = grain_coord(i,:);
        numElement_200to300(i_200to300,:) = numElement(i,:);
        grain_rodV_200to300(i_200to300,:) = grain_rodV(i,:);
        comp_mean_200to300(i_200to300) = comp_mean(i);
        gid_map_LT100 = gid_map_LT100.*(gid_map_LT100 ~= numElement(i,1));
        gid_map_100to200 = gid_map_100to200.*(gid_map_100to200 ~= numElement(i,1));
        gid_map_300to400 = gid_map_300to400.*(gid_map_300to400 ~= numElement(i,1));
        gid_map_GT400 = gid_map_GT400.*(gid_map_GT400 ~= numElement(i,1));
        i_200to300 = i_200to300+1; 
    else if(distList_300to400(i)~=0)
        grain_coord_300to400(i_300to400,:) = grain_coord(i,:);
        numElement_300to400(i_300to400,:) = numElement(i,:);
        grain_rodV_300to400(i_300to400,:) = grain_rodV(i,:);
        comp_mean_300to400(i_300to400) = comp_mean(i);
        gid_map_LT100 = gid_map_LT100.*(gid_map_LT100 ~= numElement(i,1));
        gid_map_100to200 = gid_map_100to200.*(gid_map_100to200 ~= numElement(i,1));
        gid_map_200to300 = gid_map_200to300.*(gid_map_200to300 ~= numElement(i,1));
        gid_map_GT400 = gid_map_GT400.*(gid_map_GT400 ~= numElement(i,1));
        i_300to400 = i_300to400+1;
    else
        grain_coord_GT400(i_GT400,:) = grain_coord(i,:);
        numElement_GT400(i_GT400,:) = numElement(i,:);
        grain_rodV_GT400(i_GT400,:) = grain_rodV(i,:);
        comp_mean_GT400(i_GT400) = comp_mean(i);
        gid_map_100to200 = gid_map_100to200.*(gid_map_100to200 ~= numElement(i,1));
        gid_map_200to300 = gid_map_200to300.*(gid_map_200to300 ~= numElement(i,1));
        gid_map_300to400 = gid_map_300to400.*(gid_map_300to400 ~= numElement(i,1));
        gid_map_LT100 = gid_map_LT100.*(gid_map_LT100 ~= numElement(i,1));
        i_GT400 = i_GT400+1;
    end
    end
    end
    end
    i=i+1
end

distList_LT100(distList_LT100 == 0)=[];
distList_100to200(distList_100to200 == 0)=[];
distList_200to300(distList_200to300 == 0)=[];
distList_300to400(distList_300to400 == 0)=[];
distList_GT400(distList_GT400 == 0)=[];

clear i i_LT100 i_100to200 i_200to300 i_300to400 i_GT400 xSpace ySpace zSpace absDataCopy

save(fileName, '-v7.3')
end
