i = 1;
firstYGrains = zeros(size(firstY));
lastYGrains = zeros(size(firstY));
while(i < size(firstY, 1))
    j=1;
    while(j < size(firstY, 2))
        if(firstY(i,j))
            firstYGrains(i,j) = gid_map(i,firstY(i,j),j);
            lastYGrains(i,j) = gid_map(i,lastY(i,j),j);
        end
        j=j+1;
    end
    i=i+1
end
i=1;
grainSurfArea_YSurfOnly = zeros(size(numElement_YSurfOnly, 1));
while(i<=size(numElement_YSurfOnly, 1))
    grainSurfArea_YSurfOnly(i) = sum(sum(firstYGrains == YSurfOnly(i)))+sum(sum(lastYGrains == YSurfOnly(i)));
    i=i+1
end
clear i j;