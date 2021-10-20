function [gid_map, rodV, comp, numElement, grain_rodV, grain_coord, adj, cs] = ...
                    grain_clean_up_tform(gid_map, rodV, comp, numElement, grain_rodV, grain_coord, adj, cs, varargin)
% grain_clean_up process DCT data set 
% to cluster subgrains into grains, 
% get rid of noise voxels, 
% and exclude untrustworthy grain.     
%==========================================================================
% FILENAME:          grain_clean_up.m
% DATE:              1 May, 2020     
% PURPOSE:           process DCT data set
%==========================================================================
%IN :
%    file_name  : (string) filename of hdf5 file (.h5)
%
%OPTIONAL0 : (string) specify the crystal structure for crystallographic analysis
%     crystal
%     |---'cubic' (default)
%     |---further_update  - to be updated
%OPTIONAL1 : in case of the inputting one of multiple time step data, 
%            and registration is needed
%    mask        : (logical, array) 3-dimensional data set, determining volume of interest
%                   default : no mask, all true
%    tform       : 
%     |---(1*1 affine3d) contains transformation matrix (voxel tranformation)
%          default : no registration on scalar data(no translation, no rotation)
%     |---(1*1 vector3d) contains rotation rodrigues vectors of each grain direction
%          default : no rotation on vector data
%
%    oriNote            : (str) specify orientation notation
%       notation types
%       |---'rodrigues' (default)
%       |---'euler'
%       |---further_update  - to be updated
%
%    misoriThresh       : (double) angular threshold
%                         default : 1
%    grain_size_mini    : (double) grain size threshold
%                         default : 1
%    completeness_mini  : (double) completeness threshold (value btw 0 & 1)
%                         default : 0.4
%OUT : 
%    gid_map    : (array of 3D dataset) cleaned up gid_map
%    rodV       : (array of 4D dataset) cleaned up rodrigues vectors
%    comp       : (array of 3D dataset) cleaned up completeness
%    numElement : n*2 array with (1st coloumn-gid) & (2nd column-numbner of volexs)
%    grain_rodV : n*3 array with rodrigues vectors of grains
%    grain_coord: n*3 array with center of mass coordination
%    grain_surface: n*1 array specifying surface touching grains
%    adj        : n*2 array shows grain adjacency in number ascending order
%    cs         : (crystalSymmetry) cell containing crystal structrue & symmetry information
%==========================================================================
%EXAMPLE 1 : dealing with multiple time steps, so tform & mask is ready
%           [gid_map, rodV, comp, numElement, grain_rodV, grain_coord, adj, cs]...
%              grain_clean_up('t2_1.h5',...
%              'crystal','cubic',...
%              'tform', tform_matrix_t2, rot_rod_t2, ...
%              'mask',gid_map_mask, ...
%              'threshold_ang',1,'threshold_vol',33,'threshold_comp',0.1);
%
%EXAMPLE 2 : dealing with single time step
%           [gid_map, rodV, comp, numElement, grain_rodV, grain_coord, adj, cs]...
%              grain_clean_up('t2_1.h5','threshold_ang',1,'threshold_vol',33,'threshold_comp',0.1);
%
%EXAMPLE 3 : with minimal input variable
%           [gid_map, rodV, comp, numElement, grain_rodV, grain_coord, adj, cs]...
%              grain_clean_up('t2_1.h5');
%
%==========================================================================

    
    %% Load data from defined directory
    

    
   %% Default values
   defaultCrystal = 'cubic';
   expectedCrystal = {'cubic','further_update'};
   defaultmask = zeros(size(gid_map))+1;
   defaultTform = affine3d([1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ;  0 0 0 1 ]);
   defaultRot = Rodrigues(rotation('axis',xvector,'angle',0*degree));
   defaultMisoriThresh = 1;
   defaultGrain_size_mini = 1;
   defaultCompleteness_mini = 0.1;
   
   %% Define Crystal Structure
    if any(strcmp(varargin,'crystal'))
        idx = find(strcmp(varargin,'crystal'))+1;
        crystal= expectedCrystal{strcmp(expectedCrystal, varargin{idx})};
    else
        crystal = defaultCrystal;
    end
    
    % define crystal structure & symmetry

    
    %% Define Transformation Matrix
    if any(strcmp(varargin,'tform'))
        idx = find(strcmp(varargin,'tform'))+1;
        tform = varargin{idx};
        rot_rod = varargin{idx+1};
    else
        tform = defaultTform;
        rot_rod = defaultRot;
    end
    
    %% Define Mask Matrix
    if any(strcmp(varargin,'mask'))
        idx = find(strcmp(varargin,'mask'))+1;
        mask = varargin{idx};
    else
        mask = defaultmask;
    end
    
    %% Define Threshold Values
    if any(strcmp(varargin,'threshold_ang'))
        idx = find(strcmp(varargin,'threshold_ang'))+1;
        misoriThresh = varargin{idx};
    else
        misoriThresh = defaultMisoriThresh;
    end
    
    if any(strcmp(varargin,'threshold_vol'))
        idx = find(strcmp(varargin,'threshold_vol'))+1;
        grain_size_mini = varargin{idx};
    else
        grain_size_mini = defaultGrain_size_mini;
    end
    
    if any(strcmp(varargin,'threshold_comp'))
        idx = find(strcmp(varargin,'threshold_comp'))+1;
        completeness_mini = varargin{idx};
    else
        completeness_mini = defaultCompleteness_mini;
    end

    fprintf('Thresholds are identified.\n')
    
    %% Convert input Orientation notation into Rodrigues vector format
    
    if exist('eulerAng','var')
        [~,l,m,n] = size(eulerAng);
        eulerAng_mtex=orientation.byEuler(reshape(eulerAng(1,:,:,:),l,m,n),reshape(eulerAng(2,:,:,:),l,m,n),reshape(eulerAng(3,:,:,:),l,m,n),cs);
        rodV_mtex = Rodrigues(eulerAng_mtex);
        rodV=zeros(3,l,m,n);
        rodV(1,:,:,:)=rodV_mtex.x;
        rodV(2,:,:,:)=rodV_mtex.y;
        rodV(3,:,:,:)=rodV_mtex.z;
    end
    
    %% Applying Transformation (translation + roatation) + Rodrigues update + Mask Matrix = Setting Region of Interest

    % Transformation (translation + rotation)
    
    % (1) apply scope mask to grain ID
    gid_map = imwarp(gid_map,tform,'OutputView',imref3d(size(mask)),'interp','nearest');
    gid_map = double(gid_map).*mask;
    
    % (2) apply scope mask to rodrigues vectors
    r1 = squeeze(rodV(1,:,:,:));
    r2 = squeeze(rodV(2,:,:,:));
    r3 = squeeze(rodV(3,:,:,:));
    r1 = imwarp(r1,tform,'OutputView',imref3d(size(mask)),'interp','nearest');
    r1 = double(r1).*mask;
    r2 = imwarp(r2,tform,'OutputView',imref3d(size(mask)),'interp','nearest');
    r2 = double(r2).*mask;
    r3 = imwarp(r3,tform,'OutputView',imref3d(size(mask)),'interp','nearest');
    r3 = double(r3).*mask;
    rodV = permute(cat(4,r1,r2,r3),[4,1,2,3]);
    
    clear r1 r2 r3
    
    % (3) apply scope mask to completeness
    comp = imwarp(comp,tform,'OutputView',imref3d(size(mask)),'interp','nearest');
    comp = double(comp).*mask;    

    
    % Rodrigues update
    
    % (4) apply rotation to each rodrigues elements
    denom = 1-(rodV(1,:,:,:).*rot_rod.x + rodV(2,:,:,:).*rot_rod.y + rodV(3,:,:,:).*rot_rod.z);
    rodV(1,:,:,:) = (  (rodV(1,:,:,:) + rot_rod.x) - ( rodV(2,:,:,:).*rot_rod.z - rodV(3,:,:,:).*rot_rod.y ) ) ./ denom;
    rodV(2,:,:,:) = (  (rodV(2,:,:,:) + rot_rod.y) - ( rodV(3,:,:,:).*rot_rod.x - rodV(1,:,:,:).*rot_rod.z ) ) ./ denom;
    rodV(3,:,:,:) = (  (rodV(3,:,:,:) + rot_rod.z) - ( rodV(1,:,:,:).*rot_rod.y - rodV(2,:,:,:).*rot_rod.x ) ) ./ denom;

    denom = 1-(grain_rodV(:,1).*rot_rod.x + grain_rodV(:,2).*rot_rod.y + grain_rodV(:,3).*rot_rod.z);
    grain_rodV(:,1) = (  (grain_rodV(:,1) + rot_rod.x) - ( grain_rodV(:,2).*rot_rod.z - grain_rodV(:,3).*rot_rod.y ) ) ./ denom;
    grain_rodV(:,2) = (  (grain_rodV(:,2) + rot_rod.y) - ( grain_rodV(:,3).*rot_rod.x - grain_rodV(:,1).*rot_rod.z ) ) ./ denom;
    grain_rodV(:,3) = (  (grain_rodV(:,3) + rot_rod.z) - ( grain_rodV(:,1).*rot_rod.y - grain_rodV(:,2).*rot_rod.x ) ) ./ denom; 
    
    fprintf('Data have been transformed.\n')
    
end