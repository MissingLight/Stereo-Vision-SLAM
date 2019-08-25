function bucketed_matches = Featurematch( I1_l, I2_l, I1_r, I2_r)
%INPUT:
%   - I1_l: left image for time t-1
%   - I2_l: left image for time t
%   - I1_r: right images for time t-1
%   - I2_r: right images for time t

%Initialize parameters
dims = size(I2_l);      % dimensions of image (height x width)
time = zeros(4, 1);      % variable to store time taken by each step

% Parameters for Feature Extraction
vo_params.feature.nms_n = 8;                      % non-max-suppression: min. distance between maxima (in pixels)
vo_params.feature.nms_tau = 50;                   % non-max-suppression: interest point peakiness threshold
vo_params.feature.margin = 21;                    % leaving margin for safety while computing features ( >= 25)
% Parameters for Feature Matching
vo_params.matcher.match_binsize = 50;             % matching bin width/height (affects efficiency only)
vo_params.matcher.match_radius = 200;             % matching radius (du/dv in pixels)
vo_params.matcher.match_disp_tolerance = 1;       % dx tolerance for stereo matches (in pixels)
vo_params.matcher.match_ncc_window = 21;          % window size of the patch for normalized cross-correlation
vo_params.matcher.match_ncc_tolerance = 0.3;      % threshold for normalized cross-correlation
% add subpixel-refinement using parabolic fitting
vo_params.matcher.refinement = 2;                 % refinement (0=none,1=pixel,2=subpixel)
% Paramters for Feature Selection using bucketing
vo_params.bucketing.max_features = 1;             % maximal number of features per bucket
vo_params.bucketing.bucket_width = 1;            % width of bucket
vo_params.bucketing.bucket_height = 1;           % height of bucket
%  add feature selection based on feature tracking
vo_params.bucketing.age_threshold = 10;           % age threshold while feature selection

% compute features 
pts1_l = computeFeatures(I1_l, vo_params.feature);
pts1_r = computeFeatures(I1_r, vo_params.feature);
pts2_l = computeFeatures(I2_l, vo_params.feature);
pts2_r = computeFeatures(I2_r, vo_params.feature);
% Circular feature matching
matches = matchFeaturePoints(I1_l, I1_r, I2_l, I2_r, pts1_l, pts2_l, pts1_r, pts2_r, dims, vo_params.matcher);
bucketed_matches = bucketFeatures(matches, vo_params.bucketing);
end