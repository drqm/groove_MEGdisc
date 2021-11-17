clear all


addpath('C:\Users\au631438\Documents\MATLAB\fieldtrip-20200227\fieldtrip-20200227');
ft_defaults
cd C:\Users\au631438\Desktop\PROJECTS\Groove\Pilot1_EEG_MEG

addpath D:\MEEG_data\ %filename b1_ica-raw.fif



for block=1:6
%% READ .fif

filename=['b' num2str(block) '_ica-raw.fif'];

hdr = ft_read_header(filename); % your fif-filename
%  
%  dat = ft_read_data('b1_ica-raw.fif');
 
cfg1                         = [];
cfg1.dataset                 = filename%'b1_ica-raw.fif';
cfg1.trialdef.eventtype      = 'STI101';
cfg1.trialdef.eventvalue     = 1:300; % the value of the stimulus trigger for fully incongruent (FIC).
cfg1.trialdef.prestim        = 0;
cfg1.trialdef.poststim       = 15;

cfg1         = ft_definetrial(cfg1); 
 
dataPrepro   = ft_preprocessing(cfg1);
%% electrodes (from 4 to 78)

%% 2. LINE NOISE & FILTERS
cfg2 = cfg1;
cfg2.detrend   = 'yes'; % De-Trending, so that we get rid of the offset and slow drift in the EEG-data
cfg2.dftfilter = 'yes'; % Line Noise Filter using Discrete Fourier Transform
cfg2.dftfreq   = [50 100 150]; % Line Frequency (in America this would be 60)
% cfg2.outputfile = strcat(subj0,'readin');
% cfg2=[];
cfg2.lpfilter       = 'yes';  % lowpass filter (default = 'no')
cfg2.lpfreq         = 20; % lowpass  frequency in Hz
cfg2.lpfiltord      = 4 ; % lowpass filter order
cfg2.lpfilttype     = 'but' ; 

cfg2.hpfilter       = 'yes';  % highpass filter (default = 'no')
cfg2.hpfreq         = 0.1;   % highpass frequency in Hz (0.5 or 0.1)
cfg2.hpfiltord      = 4 ; % highpass filter order
cfg2.hpfilttype     = 'but' ;

cfg2.demean         = 'yes';



dat_2 = ft_preprocessing(cfg2); % Read in the trials defined above


% dat_filt2 = ft_preprocessing(cfg2,dat_2);


% %% 3. SEE TRIAL (need to zoom in!)
% cfg2=[]; 
% %cfg2.channel={'all'};
% cfg2.channel=hdr.label(1:78);%'all';
% cfg2.viewmode='vertical'; 
% %cfg.layout= acticap32; 
% ft_databrowser(cfg2,dat_2);


%% 6.2 Re-reference electrodes and take out eye electrodes
cfg = [];
cfg.reref         = 'yes'; % (default = 'no')
cfg.refchannel    = hdr.label(4:78);%'all', '-EOG1', '-EOG2', '-ECG', '-GSR', '-Rbelt'}; %{'MastL', 'MastR'}; % cell-array with new EEG reference channel(s), this can be 'all' for a common average reference
%cfg.refchannel    = {'M1', 'M2'}; % cell-array with new EEG reference channel(s), this can be 'all' for a common average reference

cfg.channel   = hdr.label(4:78);%{'all'};  %,'-CanEye','-LowEye', '-Neck', '-Arm'};  %elimina algun channel {'all','-Veog','-Heog', '-Neck', '-Arm'}

foobar = ft_preprocessing(cfg,dat_2)%(cfg,dat_redef); 

%% Delete mastoids
cfg = [];
cfg.channel = hdr.label(4:78);%{'all'}% {'all', '-M1', '-M2'}; % delete mastoids
% cfg.outputfile = strcat(subj0,'dat_reref');

dat_reref = ft_preprocessing(cfg,foobar);

%% 6.3 See all electrodes for partial trial rejection
% For endings
cfg=[]; 
cfg.channel=hdr.label(4:78);%'all';
cfg.viewmode='vertical'; 
%cfg.layout= acticap32;
boss = ft_databrowser(cfg,dat_reref);
%% And reject some trials and SAVE
cfg = boss;
cfg.artfctdef.reject = 'complete'; %'partial' or 'complete'
dat_clean = ft_rejectartifact(cfg, dat_reref);
save(strcat('Pilot1_dat_clean', num2str(block) ), 'dat_clean');

end