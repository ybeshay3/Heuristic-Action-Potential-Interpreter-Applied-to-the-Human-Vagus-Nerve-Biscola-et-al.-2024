function [data1] = AP_calculations(conduction, cuff, axon_diameters, axon_number, target_diameter, myelin_status)
        
%         global data1
% I also removed the text input argument 

        data1.cDIST = conduction;
        data1.L_Cuff = cuff;
        data1.AxD = axon_diameters;
        data1.AxNum = axon_number;

        data1.TargetFiberCal = target_diameter;
        [~, data1.target_value_index] = min(abs(data1.AxD - target_diameter));
        target_value = data1.AxD(data1.target_value_index);
        data1.TargetFiberCal = target_value;
        
        data1.cDIST2 = data1.cDIST + data1.L_Cuff;
        
        if myelin_status == 1
            data1.spMODEL = load('SingleSpike_DA12.txt'); %used for myelinated fiber 
            % data1.spMODEL = data1.spMODEL/rms(data1.spMODEL); % YOUSSEF BESHAY- NORMALIZE THE UNITS 2/24
            data1.spMODEL = ((data1.spMODEL*-1)/1000)';   %Invert to match recording configuration with noninv amp input seeing traveling negative wave first
            %divide by a 1000 added by Youssef on June 4, 2024
            % data1.spMODEL = data1.spMODEL/1e3; %comment this
            data1.AxVel = data1.AxD .* 6.02; %check fiber vs axon diameter!! commented on June 5, 2024
            % data1.AxVel = data1.AxD .* 8; %check fiber vs axon diameter!!


        else 
            data1.spMODEL = load('tVNS3_Cf_template_v2_VolleyOnly_25kHz_29June19.txt')*1000*1000;  %29June19 --> from tVNS3 (volley and tail)
            % data1.spMODEL = data1.spMODEL/ rms(data1.spMODEL)*1e33; %YOUSSEF BESHAY - NORMALIZE THE UNITS 2/24
            data1.AxVel = data1.AxD.*sqrt(pi); %axon velocity for unmyelinated fibers

        end 
        data1.MaxD = max(data1.AxD);
        
        data1.cTIME = (data1.cDIST./data1.AxVel);
        data1.cTIME = data1.cTIME*1e3;    %(ms) Conduction time of spike as a function of fiber diameter
        data1.cTIME2 = (data1.cDIST2./data1.AxVel);
        data1.cTIME2 = data1.cTIME2*1e3;   %(ms) Conduction time of spike to second recording electrode in bipolar pair
        data1.Fs = 25e3;
       % data1.spMODEL = data1.spMODEL';
        
        % data1.spMODEL = data1.spMODEL/max(data1.spMODEL);
        data1.spDUR = length(data1.spMODEL)/data1.Fs*1e3;
        
        %Compute Spike Amplitude Scaling Factor
        data1.spAMP = 0.05.*(1./(5e3./data1.AxD + 1));     %Calculate spike amplitude as a function of diameter as per Gasser method
        data1.spAMP = data1.spAMP*1e3;                         %Convert amplitudes to mV
        
        %Compute spDUR at CV = 20 m/s
        delta_20mps = (0.05*0.14)/1.51;
        spDUR_20mps = 0.20 + delta_20mps;   %ms
        
        %Compute spDUR at CV = 100 m/s
        delta_100mps = (0.05*1.21)/1.51;
        spDUR_100mps = 0.10 + delta_100mps;   %ms
        
        %Compute slope
        data1.m = (spDUR_100mps - spDUR_20mps) / (100 - 20);
        
        %Compute y-intercept
        data1.b = spDUR_100mps - data1.m*100;
        
        data1.numCol = 2000;
        data1.RecDUR = 0.5;           %(s) Window length in seconds (note: set to 0.01 s in v3GasserReconstruction)
        
        % initializes the recordings
        data1.CAPcomponents = zeros(length(data1.cTIME), data1.numCol);        %Initialize matrix to store additive components of CAP
        data1.electrode1Recording = data1.CAPcomponents;
        data1.electrode2Recording = data1.CAPcomponents;

        data1.t2_ms = zeros(length(data1.cTIME), data1.numCol);
        
        data1.t_temp = ((0:data1.numCol - 1)/data1.Fs)*1e3;
        data1.L_cTIME = length(data1.cTIME);
        
        % %% (14Mar21) TEST CODE: ID Pk2Pk Amp and Response latency for e.g., 1 um diameter C fibers
        % data1.Latency_1um = zeros(length(data1.cTIME), 1);  %Vector to store latency to arrival of first SFAP peak of e.g., 1 um fibers
        % data1.Vpk2pk_1um = zeros(length(data1.cTIME), 1);   %Vector to store CAP Pk2Pk data with measurement indices defined by SFAP response latency and not largest observed peaks in CAP
        
        for a = 1:length(data1.cTIME)
            % data1.CAPcomponents(a,:) = vElectRx_FiberSpikeModel_GasserReconstruction_SingleEnded(data1.Fs, data1.AxD(a), data1.AxNum(a), data1.cTIME(a), data1.cTIME2(a), data1.spAMP(a), data1.spDUR, data1.spMODEL, data1.RecDUR, data1.numCol);
            [data1.electrode1Recording(a,:), data1.electrode2Recording(a,:), data1.CAPcomponents(a,:)] = vElectRx_FiberSpikeModel_GasserReconstruction(data1.Fs, data1.AxD(a), data1.AxNum(a), data1.cTIME(a), data1.cTIME2(a), data1.spAMP(a), data1.spDUR, data1.spMODEL, data1.RecDUR, data1.numCol);
            % Youssef Beshay: I modify the outputs of the function to retrieve the energy from the first electrode  
            %     t2_ms(a,:) = ((0:numCol - 1)/Fs)*1000;
            %     t2_ms(a,:) = t_temp + t_temp*cTIME(L_cTIME + 1 - a)*m;     %26Jan18
            data1.t2_ms(a,:) = data1.t_temp + data1.t_temp*((data1.cDIST*1e3) / data1.cTIME(data1.L_cTIME + 1 - a))*data1.m;     %26Jan18
        end
        
%         if (size(data1.CAPcomponents) > 1)
            data1.singleEnergyRecording1 = sum(data1.electrode1Recording,1); %YB: single energy recording
            data1.singleEnergyRecording2 = sum(data1.electrode2Recording,1);
            data1.reconstructedCAP = sum(data1.CAPcomponents, 1);
%         else
%             data1.reconstructedCAP = data1.CAPcomponents;
%         end

        
        % data1.norm_reconstructedCAP = (data1.reconstructedCAP/max(data1.reconstructedCAP))*max(max(data1.CAPcomponents));
        data1.norm_reconstructedCAP = data1.reconstructedCAP;
        
        data1.tms_reconstructed = ((0:data1.numCol - 1)/data1.Fs)*1e3;
        % data1.tms_reconstructed = mean(data1.t2_ms,1);
        
        % maxamp = max(data1.reconstructedCAP);  %Shreya
        data1.maxamp = abs(min(data1.reconstructedCAP) - max(data1.reconstructedCAP));  %(13Mar21) MPW edit to correctly compute Vpk2pk for entire CAP
        
        %table1 = table(data1.cDIST, maxamp);
        %writetable(table1, 'CD_AMP_data1.txt')
        
        %% TEST CODE (14Mar21) --> Extract indices of first and second volley of 1 um C fiber SFAP
        % data1.TargetFiberCal = 1;   %1 um C fiber (e.g., to ID latencies and CAP signal amp for 1 um fibers)
        SFAP_Latencies = [data1.AxD data1.AxVel data1.cTIME data1.cTIME2];
        Latency_1um = data1.TargetFiberCal*ones(size(SFAP_Latencies,1), 1) - SFAP_Latencies(:,1);  %Subtract all evaluated AxDs from target fiber caliber and search for row with min difference (to ID closest fiber to user input spec)
        % IMPORTANT CHANGE: not length but size because length returns the
        % largest array dimension. size(SFAP_Latencies,1) is the number of
        % rows of SFAP_Latencies

        Latency_1um_abs = abs(Latency_1um);
        [M, i_min] = min(Latency_1um_abs);   %identify row index of min to ID data for AxD of interest specified in TargetFiberCal
        
        data1.cTIME1_TargetFiberCal = SFAP_Latencies(i_min, 3);  %Col3 contains latency to first SFAP peak of TargetFiberCal
        data1.cTIME2_TargetFiberCal = SFAP_Latencies(i_min, 4);  %Col4 contains latency to second SFAP peak of TargetFiberCal
        
        data1.index_pk1_1um = (data1.cTIME1_TargetFiberCal / 1e3)*data1.Fs;  %Index of first SFAP peak
        data1.index_pk2_1um = (data1.cTIME2_TargetFiberCal / 1e3)*data1.Fs;  %Index of second SFAP peak
        
        % Important Note: Sometimes I get errors about index values
        % exceeding 2000, so I am making this simple modification. Youssef Beshay
        % 3/18/23
        condition1 = data1.index_pk1_1um >  data1.numCol;
        condition2 = data1.index_pk2_1um > data1.numCol;
        if any([condition1 condition2],2)
            data1.Vpk2Pk_TargetFiberCal = NaN;
            return
        end

        data1.index_pk1_1um = round(data1.index_pk1_1um);  %Round to nearest whole sample
        data1.index_pk2_1um = round(data1.index_pk2_1um);  %Round to nearest whole sample
        
        data1.Vpk2Pk_TargetFiberCal = abs(data1.reconstructedCAP(data1.index_pk1_1um) - data1.reconstructedCAP(data1.index_pk2_1um));  %(14Mar21)
        
%         x = [data1.cDIST, data1.maxamp, data1.L_Cuff, 0, 0, 0, data1.index_pk1_1um, data1.index_pk2_1um, data1.Vpk2Pk_TargetFiberCal];  %(14Mar21) --> Zeros for placeholders for CMAP data; Edited to include more data on specific fiber calibers (latency, etc.)
        % %END TEST CODE (14Mar21)
        
        % x = [data1.cDIST, maxamp, data1.L_Cuff];  %Shreya original
        data1.target_value_SFAP = data1.CAPcomponents(data1.target_value_index, :);
%         dlmwrite(text, x, '-append')
end