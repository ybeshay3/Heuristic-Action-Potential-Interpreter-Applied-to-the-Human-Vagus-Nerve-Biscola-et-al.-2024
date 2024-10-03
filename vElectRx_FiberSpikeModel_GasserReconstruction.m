function [SpikeModelElec1, SpikeModelElec2, SpikeModelDifferential] = vElectRx_FiberSpikeModel_GasserReconstruction(Fs, AxD, AxNum, cTIME, cTIME2, spAMP, spDUR, spMODEL, RecDUR, numCol)

Fs_ms = Fs/1000;                   %Comvert to 25 samples per msec

%% Find the volley
volleyIDX = find(spMODEL == min(spMODEL));
timeMSdelay = volleyIDX/Fs*1e3;

%% Variable Declarations:
% cTIME = cTIME - 1.96;  %For C fiber volley (4June24) TEST
% cTIME2 = cTIME2 - 1.96;  %For C fiber volley (4June24) TEST
cTIME = cTIME + timeMSdelay;  %For C fiber volley (4June24) TEST
cTIME2 = cTIME2 + timeMSdelay;  %For C fiber volley (4June24) TEST


INITIAL_DELAY = cTIME;      %(msec) Initial delay before spike placement
% INITIAL_DELAY = cTIME - 1.96;      %TEST (3JUNE24) - Offset delay for C fiber SFAP template start to peak of SFAP 

% spDUR = spDUR*1000;             %Convert spike duration from sec to msec
spDUR = length(spMODEL)/Fs*1000;

RecDUR = RecDUR*1000;        %Convert record duration from sec to msec

%% Components of Stimulus Waveform Generation:
t_TAIL = RecDUR - INITIAL_DELAY - spDUR;        %Time left until end of period after the cathodic and anodic pulses (msec)

INITIAL_DELAY_VECTOR = zeros(1,round(Fs_ms*cTIME));  %Creates delay before first phase of stimulus waveform (Added 12 Nov 2011)
TAIL = zeros(1,round(Fs_ms*t_TAIL - 1));

%% Piecewise Custom Stimulus Waveform Generation:
SpikeModel = [INITIAL_DELAY_VECTOR spMODEL TAIL];
SpikeModel = SpikeModel(1:numCol);
SpikeModel = SpikeModel*AxNum*spAMP;

%% Repeat process for spike arrival time to second recording electrode
INITIAL_DELAY2 = cTIME2;
% INITIAL_DELAY2 = cTIME2 - 1.96;      %TEST (3JUNE24) - Offset delay for C fiber SFAP template start to peak of SFAP 


t_TAIL2 = RecDUR - INITIAL_DELAY2 - spDUR;
INITIAL_DELAY_VECTOR2 = zeros(1,round(Fs_ms*cTIME2));
TAIL2 = zeros(1,round(Fs_ms*t_TAIL2 - 1));
SpikeModel2 = [INITIAL_DELAY_VECTOR2 spMODEL TAIL2];
SpikeModel2 = SpikeModel2(1:numCol);
SpikeModel2 = SpikeModel2*AxNum*spAMP;
SpikeModelElec2 = SpikeModel2;

% %% Temp plot code (12 Feb 2015)
% figure;
% hold on;
% % plot(SpikeModel, 'k')
% % plot(SpikeModel2, 'r')
% % plot(SpikeModel2 - SpikeModel, 'b')
% plot(SpikeModel - SpikeModel2, 'g')
% legend('SpMod', 'SpMod2', 'SpMod2-SpMod', 'SpMod-SpMod2')
% hold off

% YOUSSEF BESHAY: I modify the function slightly to retrieve the single
% energy recording. That is the recording from the first electrode.
% 3/26/2023
%% Subtract two instances of spsike model to produce differentially recorded response
% SpikeModel = SpikeModel2 - SpikeModel;        
% SpikeModel = SpikeModel;
SpikeModelElec1 = SpikeModel';

SpikeModelDifferential = SpikeModel - SpikeModel2;      %Most accurate method to mimic a "differential" recording

SpikeModelDifferential = SpikeModelDifferential';       %Transpose StimWave so that data is in column format (i.e., in 1 column)




