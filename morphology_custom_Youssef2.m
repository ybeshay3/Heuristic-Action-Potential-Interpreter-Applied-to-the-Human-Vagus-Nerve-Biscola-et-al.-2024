function [idx1, idx2, idx3, idx4, idx5] = morphology_custom_Youssef2(lim_one, lim_two, lim_three, lim_four, diameters)
% Summary of this function goes here
% x and y are the x and y centroids respectively for all 5 groups. The diameters are the
% diameters in each group (1-5). idx (1-5) corresponds to the row number where a nerve
% fiber belongs to a certain diameter group. 

%first limit
logical_vector = diameters < lim_one;
idx1 = find(logical_vector);

%second limit
logical_vector = diameters >= lim_one & diameters < lim_two;
idx2 = find(logical_vector);

%third limit
logical_vector = diameters >= lim_two & diameters < lim_three ;
idx3 = find(logical_vector);

%fourth limit
logical_vector = diameters >= lim_three & diameters < lim_four ;
idx4 = find(logical_vector);

%fifth limit
logical_vector = diameters >= lim_four ;
idx5 = find(logical_vector);

