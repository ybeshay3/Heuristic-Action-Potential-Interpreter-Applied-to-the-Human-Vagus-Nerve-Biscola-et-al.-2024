% Copyright Purdue University/Matthew P Ward/Youssef Beshay (2024)
% All code is made available using the following license: GNU General Public License v2.0. 
% If you use any part of this code for any purpose, you must include a copy of the original source code, license and authors with the derivative code or cite the original code in any manuscript or research product produced:
% N. P. Biscola et al., “Laterality, Sexual Dimorphism, and Heterogeneity of the Human Vagal Projectome Shape Neuromodulation to Vagus Nerve Stimulation,” Communications Biology, 2024. 

function [idx1, idx2, idx3, idx4, idx5] = morphology_custom_Youssef2(lim_one, lim_two, lim_three, lim_four, diameters)
% This function sorts the fibers/axons into groups (1-5) based on diameters. 
% idx (1-5) corresponds to the row number where a nerve fiber belongs to a certain diameter group. 

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

