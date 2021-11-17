ft_defaults;
addpath C:\Users\au571303\Documents\MATLAB\fieldtrip-20200302\private_not
mri = ft_read_mri('single_subj_T1_1mm.nii');
load('EEGdata_avg.mat')
load('epochs');
load('standard_BEM')
elec = ft_read_sens('standard_1020.elc');

figure
ft_plot_sens(elec);
hold on
ft_plot_headmodel(vol);

cfg                 = [];
cfg.elec            = elec;
cfg.headmodel       = vol;
cfg.reducerank      = 2;
cfg.channel         = {'EEG'};
cfg.resolution = 10;   % use a 3-D grid with a 1 cm resolution
cfg.sourcemodel.unit       = 'mm';
grid = ft_prepare_leadfield(cfg);

% cfg = [];
% cfg.eventfile = 'D:\MIB_LaB\MIB\STIMPC\EEGdata\CelmaMiralles/TappingEEG_subDiv0001.vmrk';
% cfg.dataset = 'D:\MIB_LaB\MIB\STIMPC\EEGdata\CelmaMiralles/TappingEEG_subDiv0001.vhdr';
% epochs = ft_preprocessing(cfg);

for cond =  1:16
    EEG = EEGdata_avg(:,cond);
    
    for ee = 1:length(EEG)
        EEG{ee,1} = EEG{ee,1}*10^-6; % convert to V
    end
    epochs.trial = EEG';
    epochs.time = repmat({(1:20000)/1000},1,31);
    epochs.label = electrodes';
    epochs.elec = elec;
    
    cfg = [];
    cfg.method    = 'mtmfft';
    cfg.output    = 'powandcsd';
    cfg.pad = 'nextpow2';
    cfg.tapsmofrq = 0.05;
    cfg.foilim    = [1.25 1.25];
    cfg.channel = {'EEG'};
    freq = ft_freqanalysis(cfg, epochs);
    
    cfg = [];
    % cfg.xlim = [0.9 1.3];
    % cfg.ylim = [15 20];
    cfg.zlim = [0  3*10^-13];
    %cfg.baseline = [-0.5 -0.1];
    %cfg.baselinetype = 'absolute';
    cfg.layout = 'EEG1020.lay';
    figure; ft_topoplotTFR(cfg,freq); colorbar
    print(sprintf('topo_freq_%d', cond),'-dpng', '-r300');
      
    cfg              = [];
    cfg.method       = 'dics';
    cfg.frequency    = 1.25;
    cfg.sourcemodel  = grid;
    cfg.headmodel    = vol;
    cfg.dics.projectnoise = 'yes';
    %cfg.normalize = 'yes';
    cfg.dics.lambda       = 0;
    
    source_result = ft_sourceanalysis(cfg, freq);
    
    cfg            = [];
    cfg.downsample = 2;
    cfg.parameter = 'pow';
    source_int  = ft_sourceinterpolate(cfg, source_result , mri);
    
    cfg              = [];
    cfg.method       = 'slice';
    cfg.funparameter = 'pow';
    cfg.funcolorlim   = [0 6*(10^-6)];
    ft_sourceplot(cfg,source_int);
    print(sprintf('source_freq_%d', cond),'-dpng', '-r300');
    close all
end