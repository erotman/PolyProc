function plotSliceViz(gid_map, grain_rodV, comp_mean, numElement)
    gid_map=permute(gid_map, [3,1,2]);
    i=1;
    while(i<=size(gid_map,3))
        slice_viz_with_comp_list(gid_map, numElement, 'completeness', comp_mean, 'slice', i);
        savefig(sprintf('completeness_10_12_y=%d', i))
        i=i+1
        clf;
    end
    i=1;
    while(i<=size(gid_map,3))
        slice_viz_with_comp_list(gid_map, numElement, 'size', numElement, 'slice', i);
        savefig(sprintf('size_10_12_y=%d', i))
        i=i+1
        clf;
    end
    i=1;
    while(i<=size(gid_map,3))
        slice_viz_with_comp_list(gid_map, numElement, 'orientation', grain_rodV, 'cubic', 'slice', i);
        savefig(sprintf('orientation_10_12_y=%d', i))
        i=i+1
        clf;
    end
end 