function [m1_l,m2_l,m1_r,m2_r] = Featurematch( I1_l, I2_l, I1_r, I2_r)
%INPUT:
%   - I1_l: left image for time t-1
%   - I2_l: left image for time t
%   - I1_r: right images for time t-1
%   - I2_r: right images for time t
%OUTPUT:
%   - m1_l: matched point in left image at time t-1
%   - m2_l: matched point in right image at time t
%   - m1_r: matched point in left image at time t-1
%   - m2_r: matched point in right image at time t
orb1_l = detectSURFFeatures(I1_l);
orb2_l = detectSURFFeatures(I2_l);
orb1_r = detectSURFFeatures(I1_r);
orb2_r = detectSURFFeatures(I2_r);
%figure;
%imshow(I1_l);
%hold on;
%plot(selectStrongest(I1_l, 100));
%title('100 Strongest Feature Points from cup Image');

% Extract feature descriptors.
[I1_lFeatures, pts1_l] = extractFeatures(I1_l, orb1_l);
[I2_lFeatures, pts2_l] = extractFeatures(I2_l, orb2_l);
[I1_rFeatures, pts1_r] = extractFeatures(I1_r, orb1_r);
[I2_rFeatures, pts2_r] = extractFeatures(I2_r, orb2_r);

% Match Features
I1L1R = matchFeatures(I1_lFeatures, I1_rFeatures, 'MatchThreshold', 0.5); 
I1R2R = matchFeatures(I1_rFeatures, I2_rFeatures, 'MatchThreshold', 0.5);
I2R2L = matchFeatures(I2_rFeatures, I2_lFeatures, 'MatchThreshold', 0.5); 
I2L1L = matchFeatures(I2_lFeatures, I1_lFeatures, 'MatchThreshold', 0.5); 
[a12,b12,c12]=intersect(I1L1R(:,2),I1R2R(:,1));
I1L1R=I1L1R(b12,:);
I1R2R=I1R2R(c12,:);
[a23,b23,c23]=intersect(I1R2R(:,2),I2R2L(:,1));
I1R2R=I1R2R(b23,:);
I1L1R=I1L1R(b23,:);
I2R2L=I2R2L(c23,:);
[a34,b34,c34]=intersect(I2R2L(:,2),I2L1L(:,1));
I2R2L=I2R2L(b34,:);
I1R2R=I1R2R(b34,:);
I1L1R=I1L1R(b34,:);
I2L1L=I2L1L(c34,:);
[a41,b41,c41]=intersect(I2L1L(:,2),I1L1R(:,1));
I2L1L=I2L1L(b41,:);
I2R2L=I2R2L(b41,:);
I1R2R=I1R2R(b41,:);
I1L1R=I1L1R(b41,:);
%select features
m1_l= orb1_l(I1L1R (:, 1), :);
m1_r= orb1_r (I1L1R (:, 2), :);
m2_l = orb2_l(I2L1L (:, 1), :);
m2_r = orb2_r (I1R2R (:, 2), :);
end

