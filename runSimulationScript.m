clc;clear;close all;
%% Start here - User Inputs
myelination = 0; %myelinated = 1, unmyelinated = 0
fascicleNumber = 7.3; %choose between 2,3, and 7 (including sub-fascicles 7.1,7.2,and 7.3)
ConductionDistancemmEditField = 10; %conduction distance between the stimulating and recording cuff in mm
RecordingCuffLengthmmEditField = 2; % length of the recording cuff in mm
UncorrectedCheckBox = 0; %0 to use SAE diameter data. Otherwise, using the uncorrected diameter from the area of a circle.  
DiameterScalingEditField = 0; % to multiply all the diameters by a certain factor. Keep as 0 to use the original diameters
folderName = 'HAPI Figures'; %folder name to store the figures generated by the script

% size of the figures exported in centimeters
figureWidthCM = 14;
figureHeightCM = 8;

%% Folder and file name
if myelination == 1
    myelinationString = 'Myelinated';
elseif myelination == 0
    myelinationString = 'Unmyelinated';
end

fascicleID = string(strcat('Fascicle',{' '}, num2str(fascicleNumber))); %this is the name of the fascicle
fascicleName = strcat('fascicle',num2str(fascicleNumber));
fileNameTEM = strcat(fascicleName, myelinationString,'TEM.tiff');
fileNameCNAP = strcat(fascicleName, myelinationString, 'CD.', num2str(ConductionDistancemmEditField), 'mmCL.', num2str(RecordingCuffLengthmmEditField), 'mmCNAP.tiff');
fileNameHistogram = strcat(fascicleName, myelinationString,'Histogram.tiff');
currentFolder = pwd;
folderName = string(strcat(currentFolder, '/', folderName));

%% start of code

if logical(myelination)
    diameterColumnSAE = 19;
    fascicle2Data = readmatrix('FASCICLE2_Myelinated.xlsx','Sheet',1);
    fascicle2Diameters = fascicle2Data(:,diameterColumnSAE);
    fascicle3Data = readmatrix('FASCICLE3_Myelinated.xlsx','Sheet',1);
    fascicle3Diameters = fascicle3Data(:,diameterColumnSAE);
    fascicle7Data = readmatrix('FASCICLE7_Myelinated.xlsx','Sheet',1);
    fascicle7Diameters = fascicle7Data(:,diameterColumnSAE);
    diameterMaximum = [max(fascicle2Diameters), max(fascicle3Diameters), max(fascicle7Diameters)];
    diameterMinimum = [min(fascicle2Diameters), min(fascicle3Diameters), min(fascicle7Diameters)];
    % colorsRGB = [255 255 0; 255 0 255; 0 255 0; 0 255 255; 255 0 0]./255.*0.7;
    colorsRGB = [230 25 75; 60 180 75; 220 190 255; 0 130 200; 245 130 48]./255;

else 
    diameterColumnSAE = 9;
    fascicle2Data = readmatrix('FASCICLE2_Unmyelinated.xlsx','Sheet',1);
    fascicle2Diameters = fascicle2Data(:,diameterColumnSAE);
    fascicle3Data = readmatrix('FASCICLE3_Unmyelinated.xlsx','Sheet',1);
    fascicle3Diameters = fascicle3Data(:,diameterColumnSAE);
    fascicle7Data = readmatrix('FASCICLE7_Unmyelinated.xlsx','Sheet',1);
    fascicle7Diameters = fascicle7Data(:,diameterColumnSAE);
    diameterMaximum = [max(fascicle2Diameters), max(fascicle3Diameters), max(fascicle7Diameters)];
    diameterMinimum = [min(fascicle2Diameters), min(fascicle3Diameters), min(fascicle7Diameters)];
    % colorsRGB = [255 255 0; 255 0 255; 0 255 0; 0 255 255; 255 0 0]./255;
    colorsRGB = [230 25 75; 60 180 75; 220 190 255; 0 130 200; 245 130 48]./255;

end

if (strcmp(fascicleID, 'Fascicle 2'))
    full_data_myelinated = readmatrix('FASCICLE2_Myelinated.xlsx','Sheet',1);
    full_data_unmyelinated = readmatrix('FASCICLE2_Unmyelinated.xlsx','Sheet',1);
    fascicleImage = imread('FASCICLE2_TEM.tif');
    conv_fac = 1/0.0119; 
    markerScaling = 25; %this is the scaling factor to plot; make 20 for fascicle 2 and 10 for fascicle 3
end

if (strcmp(fascicleID, 'Fascicle 3'))
    full_data_myelinated = readmatrix('FASCICLE3_Myelinated.xlsx','Sheet',1);
    full_data_unmyelinated = readmatrix('FASCICLE3_Unmyelinated.xlsx','Sheet',1);
    fascicleImage = imread('FASCICLE3_TEM.jpg');
    conv_fac = 1/0.0119; 
    scaling_fact = 0.7;
    fascicleImage = imresize(fascicleImage, scaling_fact);
    conv_fac = conv_fac * scaling_fact;
    markerScaling = 3; %this is the scaling factor to plot

end

if (strcmp(fascicleID, 'Fascicle 7'))
    full_data_myelinated = readmatrix('FASCICLE7_Myelinated.xlsx','Sheet',1);
    full_data_unmyelinated = readmatrix('FASCICLE7_Unmyelinated.xlsx','Sheet',1);
    fascicleImage = imread('FASCICLE7_TEM.tif');
    conv_fac = 1/0.008734; 
    markerScaling = 2.5; %this is the scaling factor to plot
end

if (strcmp(fascicleID, 'Fascicle 7.1'))
    full_data_myelinated = readmatrix('FASCICLE7.1_Myelinated.csv');
    full_data_unmyelinated = readmatrix('FASCICLE7.1_Unmyelinated.csv');
    fascicleImage = imread('FASCICLE7_TEM.tif');
    conv_fac = 1/0.008734;
    markerScaling = 2.5; %this is the scaling factor to plot

end

if (strcmp(fascicleID, 'Fascicle 7.2'))
    full_data_myelinated = readmatrix('FASCICLE7.2_Myelinated.xlsx','Sheet',1);
    full_data_unmyelinated = readmatrix('FASCICLE7.2_Unmyelinated.xlsx','Sheet',1);
    fascicleImage = imread('FASCICLE7_TEM.tif');
    conv_fac = 1/0.008734;
    markerScaling = 2.5; %this is the scaling factor to plot


end

if (strcmp(fascicleID, 'Fascicle 7.3'))
    full_data_myelinated = readmatrix('FASCICLE7.3_Myelinated.xlsx','Sheet',1);
    full_data_unmyelinated = readmatrix('FASCICLE7.3_Unmyelinated.xlsx','Sheet',1);
    fascicleImage = imread('FASCICLE7_TEM.tif');
    conv_fac = 1/0.008734;
    markerScaling = 2.5; %this is the scaling factor to plot
end

popScaling = 1; %initializes popScaling. Because SAE diameters are smaller than the uncorrected ones, this variable will make the appearance of the scatters on the fascicle display larger
if myelination %myelinated fibers
    if not(UncorrectedCheckBox) %if unchecked, user wants SAE data (default)
        diameterCol = 19;
        gratioCol = 22; %for SAE g-ratio
        popScaling = mean(full_data_myelinated(:,11))/mean(full_data_myelinated(:,19));


    else
        diameterCol = 11; 
        gratioCol = 14;
    end

    centroidXCol = 3;
    centroidYCol = 4;
    full_data = full_data_myelinated;

else 
    if not(UncorrectedCheckBox) 
        diameterCol = 9; %if unchecked, users want SAE data (default) YB 5/4/23
        popScaling = mean(full_data_unmyelinated(:,7))/mean(full_data_unmyelinated(:,9));
    else
        diameterCol = 7;
    end

    centroidXCol = 2;
    centroidYCol = 3;
    full_data = full_data_unmyelinated;

end

if not(DiameterScalingEditField)
    DiameterScalingEditField = 1;
end 
diameterScaling = DiameterScalingEditField;

%updates diameters in the full table with the scaled diameters by
%multiplying by diameterScaling
full_data(:,diameterCol) = diameterScaling * full_data(:,diameterCol);
% omits diameter values that are zeros
omitIndex = find(full_data(:,diameterCol) == 0); %Youssef added 4/11
full_data(omitIndex,:) = [];

allDiameters = full_data(:,diameterCol); %this is the column with all the diameters in the table/matrix


% sets default diameter limits: equal bin width between the smallest
% diameter and the largest one (among fascicles 2,3, and 7)
diameterBin = (max(diameterMaximum)-min(diameterMinimum))/5;
defaultLimits = min(diameterMinimum):diameterBin:max(diameterMaximum);

% may want to explore different limits of fibers/axons
lim1 = defaultLimits(2);
lim2 = defaultLimits(3);
lim3 = defaultLimits(4);
lim4 = defaultLimits(5);

%uses default values for the morphology parameters
 [idx1, idx2, idx3, idx4, idx5] = morphology_custom_Youssef2(lim1, lim2, lim3, lim4, allDiameters);

% sets all the diameterss
diameters1 = allDiameters(idx1);
diameters2 = allDiameters(idx2);
diameters3 = allDiameters(idx3);
diameters4 = allDiameters(idx4);
diameters5 = allDiameters(idx5);

im_height = size(fascicleImage, 1);
im_width = size(fascicleImage, 2);
x_max = im_width/conv_fac;
y_max = im_height/conv_fac;
xWorldLimits = [0 x_max];
yWorldLimits = [0 y_max];
RA = imref2d(size(fascicleImage),xWorldLimits,yWorldLimits);

x_scaling = 1;
y_scaling = 1;

%% starts fascicle Display image 
figure('Position', [100, 100, 1000, 800]); % Adjust the last two values as needed

ax = gca;
ax.OuterPosition = [0.01, 0.01, 0.99, 0.99]; % Adjust these values as needed

if size(fascicleImage,3) ~= 3
    fascicle_img_gray = rgb2gray(fascicleImage(1:end, 1:end, 1:3));
    imshow(fascicle_img_gray,RA);
else
    imshow(fascicleImage,RA);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on;
set(gca,'YDir','normal'); %may be 'reverse' rather than 'normal'

% defines a constant c if y values are negative
c = 1; 
if full_data(1,centroidYCol) < 0
    c = -1;
end

axis(gca,[0 x_max 0 y_max]);

scatter(full_data(idx1,centroidXCol)*x_scaling, c*full_data(idx1,centroidYCol)*y_scaling, allDiameters(idx1) * markerScaling * popScaling, 'o', 'filled', 'MarkerFaceColor', colorsRGB(1,:), 'MarkerEdgeColor', colorsRGB(1,:));
scatter(full_data(idx2,centroidXCol)*x_scaling, c*full_data(idx2,centroidYCol)*y_scaling, allDiameters(idx2) * markerScaling * popScaling, 'o', 'filled', 'MarkerFaceColor', colorsRGB(2,:), 'MarkerEdgeColor', colorsRGB(2,:));
scatter(full_data(idx3,centroidXCol)*x_scaling, c*full_data(idx3,centroidYCol)*y_scaling, allDiameters(idx3) * markerScaling * popScaling, 'o', 'filled', 'MarkerFaceColor', colorsRGB(3,:), 'MarkerEdgeColor', colorsRGB(3,:));
scatter(full_data(idx4,centroidXCol)*x_scaling, c*full_data(idx4,centroidYCol)*y_scaling, allDiameters(idx4) * markerScaling * popScaling, 'o', 'filled', 'MarkerFaceColor', colorsRGB(4,:), 'MarkerEdgeColor', colorsRGB(4,:));
scatter(full_data(idx5,centroidXCol)*x_scaling, c*full_data(idx5,centroidYCol)*y_scaling, allDiameters(idx5) * markerScaling * popScaling, 'o', 'filled', 'MarkerFaceColor', colorsRGB(5,:), 'MarkerEdgeColor', colorsRGB(5,:));

% plotting features
% title(fascicleDisplay, 'Axons in the Vagus Nerve Segment', 'FontSize', 18);
xlabel("X (\mum)", "FontSize",20, "FontName",'Arial','FontWeight','bold');
ylabel("Y (\mum)", "FontSize",20, 'FontName','Arial','FontWeight','bold');
fontsize(gca, 25, 'points');
set(gca, 'FontWeight','bold');

if (strcmp(fascicleID, 'Fascicle 7')) || (strcmp(fascicleID, 'Fascicle 7.1')) || (strcmp(fascicleID, 'Fascicle 7.2')) || (strcmp(fascicleID, 'Fascicle 7.3')) 
    %these are the true dimensions of the fascicle in microns
    newXLim = 403.986145;
    newYLim = 394.679749;

    currentXLim = max(xlim(gca)); %gets the upper bound of the current x axis
    currentYLim = max(ylim(gca));

    X_factor = newXLim/currentXLim;
    Y_factor = newYLim/currentYLim; 

    %see the label instead of ticks 
    % Set new tick values
    set(gca, 'XTick', [0 200 400]./X_factor);
    xticklabels(gca, [0 200 400]);
    set(gca, 'YTick', [0 100 200 300]./Y_factor);
    yticklabels(gca, [0 100 200 300]);
end
set(gca,'LooseInset',get(gca,'TightInset'));
set(gcf,'units','centimeters','position',[0,0,figureWidthCM,figureHeightCM+5]);

exportgraphics(gca, fullfile(folderName, fileNameTEM),'Resolution',600,'BackgroundColor','white');
grid on;
hold off;

%% plotting of CNAP
figure(2);
%inputted conduction distance + recording cuff length
test_conduct = ConductionDistancemmEditField / 1e3;
test_recording = RecordingCuffLengthmmEditField / 1e3;
conduct = test_conduct;   
cuff_length = test_recording;
axon_diameter = 1 / 1e3;

% using 1 um as test for target diameter
number_axons_1 = ones(size(idx1));
number_axons_2 = ones(size(idx2));
number_axons_3 = ones(size(idx3));
number_axons_4 = ones(size(idx4));
number_axons_5 = ones(size(idx5));

if ~isempty(idx1)
    [o_calculated_1] = AP_calculations(conduct, cuff_length, diameters1, number_axons_1, axon_diameter, myelination);
    plot(o_calculated_1.tms_reconstructed, o_calculated_1.reconstructedCAP, 'Color', colorsRGB(1,:), 'LineWidth',1.5);
    hold on;
    if myelination == 0 %add silver lining for unmyelinated fibers
        plot(o_calculated_1.tms_reconstructed, o_calculated_1.reconstructedCAP, 'Color', [192 192 192]./255, 'LineWidth',0.5);
        hold on;
    end
end
if ~isempty(idx2)
    [o_calculated_2] = AP_calculations(conduct, cuff_length, diameters2, number_axons_2, axon_diameter, myelination);
    plot(o_calculated_2.tms_reconstructed,o_calculated_2.reconstructedCAP, 'Color', colorsRGB(2,:), 'LineWidth',1.5);
    hold on;
end
if ~isempty(idx3)
    [o_calculated_3] = AP_calculations(conduct, cuff_length, diameters3, number_axons_3, axon_diameter, myelination);
    plot(o_calculated_3.tms_reconstructed,o_calculated_3.reconstructedCAP, 'Color', colorsRGB(3,:), 'LineWidth',1.5);
    hold on;
end
if ~isempty(idx4)
    [o_calculated_4] = AP_calculations(conduct, cuff_length, diameters4, number_axons_4, axon_diameter, myelination);
    plot(o_calculated_4.tms_reconstructed,o_calculated_4.reconstructedCAP, 'Color', colorsRGB(4,:), 'LineWidth',1.5);
    hold on;
end
if ~isempty(idx5)
    [o_calculated_5] = AP_calculations(conduct, cuff_length, diameters5, number_axons_5, axon_diameter, myelination);
    plot(o_calculated_5.tms_reconstructed,o_calculated_5.reconstructedCAP, 'Color', colorsRGB(5,:), 'LineWidth',1.5);
    hold on;
end

cnap_all_diameters = allDiameters;
cnap_all_diameters_numbers = ones(size(cnap_all_diameters));
[o_calculated_6] = AP_calculations(conduct, cuff_length, cnap_all_diameters, cnap_all_diameters_numbers, axon_diameter, myelination);

plot(o_calculated_6.tms_reconstructed,o_calculated_6.reconstructedCAP, 'Color', 'k', 'LineWidth', 2); %change to silver instead of black to test
xlabel('Time (ms)', 'FontSize',35,"FontName",'Arial','FontWeight','bold');


% CY: 4/10/2023, changed from uV to arbitrary units
ylabel('V_p_r_e_d (\muV)', 'FontSize',35,"FontName",'Arial','FontWeight','bold');
if myelination
    xlim([0 5]); %FOR MYELINATED FIBERS REDUCE THE X RANGE; eliminates the automatic zooming
else
    xlim([0 80]);
end
set(gca, 'TickDir', 'out', 'XMinorTick', 'on');
fontsize(gca, 25, 'points');
set(gca, 'FontWeight','bold');
set(gca,'LooseInset',get(gca,'TightInset'));
set(gcf,'units','centimeters','position',[0,0,figureWidthCM,figureHeightCM])
exportgraphics(gca, fullfile(folderName, fileNameCNAP),'Resolution',600,'BackgroundColor','white');
hold off;


%% starts histogram plotting
figure(3); 
%plots histogram
histogram(diameters1, 'BinEdges', [min(diameterMinimum), lim1: lim1, lim2: lim2, lim3: lim3, lim4: lim4, max(diameterMaximum)], 'FaceColor', colorsRGB(1,:));
hold on;
histogram(diameters2, 'BinEdges', [min(diameterMinimum), lim1: lim1, lim2: lim2, lim3: lim3, lim4: lim4, max(diameterMaximum)], 'FaceColor', colorsRGB(2,:));
histogram(diameters3, 'BinEdges', [min(diameterMinimum), lim1: lim1, lim2: lim2, lim3: lim3, lim4: lim4, max(diameterMaximum)], 'FaceColor', colorsRGB(3,:));
histogram(diameters4, 'BinEdges', [min(diameterMinimum), lim1: lim1, lim2: lim2, lim3: lim3, lim4: lim4, max(diameterMaximum)], 'FaceColor', colorsRGB(4,:));      
histogram(diameters5, 'BinEdges', [min(diameterMinimum), lim1: lim1, lim2: lim2, lim3: lim3, lim4: lim4, max(diameterMaximum)], 'FaceColor', colorsRGB(5,:)); 
% title(histogramAllFibers, 'Axon Diameter Distribution', 'FontSize', 12)
x = histogram([diameters1; diameters2; diameters3; diameters4; diameters5], 'BinEdges', [min(diameterMinimum), lim1: lim1, lim2: lim2, lim3: lim3, lim4: lim4, max(diameterMaximum)], 'FaceColor','none');

if myelination
    % xticks(0:2:round(max(diameterMaximum,2))); %this line generates a
    % warning, but was originally used to produce the figures
    xticks(0:2:ceil(max(diameterMaximum)));
    set(gca, 'TickDir', 'out', 'XMinorTick', 'on');
    xlabel('Fiber Diameter (\mum)', 'FontSize',35,"FontName",'Arial','FontWeight','bold');

else
    % xticks(0:0.5:round(max(diameterMaximum,2))); %this line generates a
    % warning, but was originally used to produce the figures
    xticks(0:0.5:ceil(max(diameterMaximum)));
    set(gca, 'TickDir', 'out', 'XMinorTick', 'on');
    xlabel('Axon Diameter (\mum)', 'FontSize',35,"FontName",'Arial','FontWeight','bold');

end

E = x.BinEdges;
y = x.BinCounts;
xloc = E(1:end-1)+diff(E)/2;
%added 2/23/24 to eliminate diameter bins with zero elements/fibers
xloc(y == 0) = [];
y(y == 0) = [];

% may modify the Y location of the text (displaying the number of fibers/axons in a group). location adjusted based on the
% number of fibers/axons in the group
for z = 1:length(y)
    if y(z)>1000
        text(xloc(z)-0.175, y(z)+log10(max(y))*45, string(y(z)), 'Color', 'k', 'FontSize', 15,'FontWeight','bold','FontName','Arial'); 
    elseif y(z)>=100
        text(xloc(z)-0.14, y(z)+log10(max(y))*45, string(y(z)), 'Color', 'k', 'FontSize', 15,'FontWeight','bold','FontName','Arial'); 
    elseif y(z)>=10
        text(xloc(z)-0.08, y(z)+log10(max(y))*45, string(y(z)), 'Color', 'k', 'FontSize', 15,'FontWeight','bold','FontName','Arial'); 
    else
        text(xloc(z)-0.04, y(z)+log10(max(y))*45, string(y(z)), 'Color', 'k', 'FontSize', 15,'FontWeight','bold','FontName','Arial'); 
    end 
end 

ylabel('Count', 'FontSize',35,"FontName",'Arial','FontWeight','bold');
fontsize(gca, 25, 'points');
value = max(y);
ylim([0 10^floor(log10(value)) * floor(value/10^floor(log10(value))) + 1.25*10^floor(log10(value))]);
set(gca, 'FontWeight','bold');
set(gca,'LooseInset',get(gca,'TightInset'));
set(gcf,'units','centimeters','position',[0,0,figureWidthCM,figureHeightCM])
exportgraphics(gca, fullfile(folderName, fileNameHistogram),'Resolution',600,'BackgroundColor','white');
hold off;

