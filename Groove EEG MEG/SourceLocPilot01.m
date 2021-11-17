clc
clear all

cd 'C:\Users\au571303\Dropbox\PC\Documents\projects\groove_MEGdisc\Groove EEG MEG/'

%addpath '/users/celma/Desktop/MINDLAB2019_EEG-SubdivisionEntrainment/misc/fieldtrip-20200227/fieldtrip-20200227/'
ft_defaults

%%
% 
% 
% clear all
% 
% cd '/scratch7/MINDLAB2019_EEG-SubdivisionEntrainment/2021/Pilot01/Pilot1_EEG_MEG/MEG_DATA'

%cd C:\Users\au631438\Desktop\PROJECTS\Groove\Pilot1_EEG_MEG\
load('pilot01HeadModel.mat')
load('mri_realigned.mat')
mri = ft_read_mri('single_subj_T1_1mm.nii');

participants={'Pilot1'}

ChannelType=input('ChannelType: eeg (0) , mag (1), or grad (2)?  -->  ')
if ChannelType== 1
electrodes={'MEG0111';'MEG0121';'MEG0131';'MEG0141';'MEG0211';'MEG0221';'MEG0231';'MEG0241';'MEG0311';'MEG0321';'MEG0331';'MEG0341';'MEG0411';'MEG0421';'MEG0431';'MEG0441';'MEG0511';'MEG0521';'MEG0531';'MEG0541';'MEG0611';'MEG0621';'MEG0631';'MEG0641';'MEG0711';'MEG0721';'MEG0731';'MEG0741';'MEG0811';'MEG0821';'MEG0911';'MEG0921';'MEG0931';'MEG0941';'MEG1011';'MEG1021';'MEG1031';'MEG1041';'MEG1111';'MEG1121';'MEG1131';'MEG1141';'MEG1211';'MEG1221';'MEG1231';'MEG1241';'MEG1311';'MEG1321';'MEG1331';'MEG1341';'MEG1411';'MEG1421';'MEG1431';'MEG1441';'MEG1511';'MEG1521';...
    'MEG1531';'MEG1541';'MEG1611';'MEG1621';'MEG1631';'MEG1641';'MEG1711';'MEG1721';'MEG1731';'MEG1741';'MEG1811';'MEG1821';'MEG1831';'MEG1841';'MEG1911';'MEG1921';'MEG1931';'MEG1941';'MEG2011';'MEG2021';'MEG2031';'MEG2041';'MEG2111';'MEG2121';'MEG2131';'MEG2141';'MEG2211';'MEG2221';'MEG2231';'MEG2241';'MEG2311';'MEG2321';'MEG2331';'MEG2341';'MEG2411';'MEG2421';'MEG2431';'MEG2441';'MEG2511';'MEG2521';'MEG2531';'MEG2541';'MEG2611';'MEG2621';'MEG2631';'MEG2641'};%dat_clean.label([76:3:379]);
channels=([76:3:379]);
elseif ChannelType== 2
channels=sort([77:3:380, 78:3:381]); %MAGNETOMETERS
electrodes={'MEG0112';'MEG0113';'MEG0122';'MEG0123';'MEG0132';'MEG0133';'MEG0142';'MEG0143';'MEG0212';'MEG0213';'MEG0222';'MEG0223';'MEG0232';'MEG0233';'MEG0242';'MEG0243';'MEG0312';'MEG0313';'MEG0322';'MEG0323';'MEG0332';'MEG0333';'MEG0342';'MEG0343';'MEG0412';'MEG0413';'MEG0422';'MEG0423';'MEG0432';'MEG0433';'MEG0442';'MEG0443';'MEG0512';'MEG0513';'MEG0522';'MEG0523';'MEG0532';'MEG0533';'MEG0542';'MEG0543';'MEG0612';'MEG0613';'MEG0622';'MEG0623';'MEG0632';'MEG0633';'MEG0642';...
    'MEG0643';'MEG0712';'MEG0713';'MEG0722';'MEG0723';'MEG0732';'MEG0733';'MEG0742';'MEG0743';'MEG0812';'MEG0813';'MEG0822';'MEG0823';'MEG0912';'MEG0913';'MEG0922';'MEG0923';'MEG0932';'MEG0933';'MEG0942';'MEG0943';'MEG1012';'MEG1013';'MEG1022';'MEG1023';'MEG1032';'MEG1033';'MEG1042';'MEG1043';'MEG1112';'MEG1113';'MEG1122';'MEG1123';'MEG1132';'MEG1133';'MEG1142';'MEG1143';'MEG1212';'MEG1213';'MEG1222';'MEG1223';'MEG1232';'MEG1233';'MEG1242';'MEG1243';'MEG1312';'MEG1313';'MEG1322';'MEG1323';...
    'MEG1332';'MEG1333';'MEG1342';'MEG1343';'MEG1412';'MEG1413';'MEG1422';'MEG1423';'MEG1432';'MEG1433';'MEG1442';'MEG1443';'MEG1512';'MEG1513';'MEG1522';'MEG1523';'MEG1532';'MEG1533';'MEG1542';'MEG1543';'MEG1612';'MEG1613';'MEG1622';'MEG1623';'MEG1632';'MEG1633';'MEG1642';'MEG1643';'MEG1712';'MEG1713';'MEG1722';'MEG1723';'MEG1732';'MEG1733';'MEG1742';'MEG1743';'MEG1812';'MEG1813';'MEG1822';'MEG1823';'MEG1832';'MEG1833';'MEG1842';'MEG1843';'MEG1912';'MEG1913';'MEG1922';'MEG1923';'MEG1932';'MEG1933';'MEG1942';...
    'MEG1943';'MEG2012';'MEG2013';'MEG2022';'MEG2023';'MEG2032';'MEG2033';'MEG2042';'MEG2043';'MEG2112';'MEG2113';'MEG2122';'MEG2123';'MEG2132';'MEG2133';'MEG2142';'MEG2143';'MEG2212';'MEG2213';'MEG2222';'MEG2223';'MEG2232';'MEG2233';'MEG2242';'MEG2243';'MEG2312';'MEG2313';'MEG2322';'MEG2323';'MEG2332';'MEG2333';'MEG2342';'MEG2343';'MEG2412';'MEG2413';'MEG2422';'MEG2423';'MEG2432';'MEG2433';'MEG2442';'MEG2443';'MEG2512';'MEG2513';'MEG2522';'MEG2523';'MEG2532';'MEG2533';'MEG2542';'MEG2543';'MEG2612';'MEG2613';'MEG2622';...
    'MEG2623';'MEG2632';'MEG2633';'MEG2642';'MEG2643'}%dat_clean.label(channels);
else
electrodes={'EEG001';'EEG002';'EEG003';'EEG004';'EEG005';'EEG006';'EEG007';'EEG008';'EEG009';'EEG010';'EEG011';'EEG012';'EEG013';'EEG014';'EEG015';'EEG016';'EEG017';'EEG018';'EEG019';'EEG020';'EEG021';'EEG022';'EEG023';'EEG024';'EEG025';'EEG026';'EEG027';'EEG028';'EEG029';'EEG030';'EEG031';'EEG032';'EEG033';'EEG034';'EEG035';'EEG036';'EEG037';'EEG038';'EEG039';'EEG040';'EEG041';'EEG042';'EEG043';'EEG044';'EEG045';'EEG046';'EEG047';'EEG048';'EEG049';'EEG050';'EEG051';'EEG052';'EEG053';'EEG054';'EEG055';'EEG056';'EEG057';'EEG058';'EEG059';'EEG060';'EEG061';'EEG062';'EEG063';'EEG064';'EEG065';'EEG066';'EEG067';'EEG068';'EEG069';'EEG070';'EEG071';'EEG072';'EEG073';'EEG074';'EEG075'};
electrodes={'Fp1';'Fpz'; 'Fp2'; 'AF7';'AF3';'AFz';'AF4';'AF8';'F7';'F5';'F3';'F1';'Fz';'F2';'F4';'F6';'F8';'FT9';'FT7';'FC5';'FC3';'FC1';'FC2';'FC4';'FC6';'FT8';'FT10';...
    'T9';'T7';'C5';'C3';'C1';'Cz';'C2';'C4';'C6';'T8';'T10';'TP11';'TP9';'TP7';'CP5';'CP3';'CP1';'CPz';'CP2';'CP4';'CP6';'TP8';'TP10';'TP12';...
    'P9';'P7';'P5';'P3';'P1';'Pz';'P2';'P4';'P6';'P8';'P10';'PO9';'PO7';'PO3';'POz';'PO4';'PO8';'P10';'O1';'Oz';'O2';'O9';'Iz';'O10'};
channels=([1:75]);
end
%REVISE
%conditions={'isoM'; 'isoH'; 'lowM'; 'lowH'; 'mediumM'; 'mediumH'; 'highM'; 'highH'; 'isoM2'; 'isoH2'; 'lowM2'; 'lowH2'; 'mediumM2'; 'mediumH2'; 'highM2'; 'highH2'};
conditions={'isoM'; 'isoM2'; 'lowM'; 'lowM2'; 'mediumM'; 'mediumM2'; 'highM'; 'highM2'; 'isoH'; 'isoH2'; 'lowH'; 'lowH2'; 'mediumH'; 'mediumH2'; 'highH'; 'highH2'};

%display(channels)

frequencies={'F08','F16','F32'}% % --> 
FoI=[0.8, 1.6, 3.2] % % --> grouping2 beat and duplet
fs=1000;

trialCODE=[1:2:16, 2:2:16] ;


ByTrials=input('fft trial by trials: yes=1, no=0  -->  ')
Silent=input('fft of silent part: yes=1, no=0  -->  ')
SignalToNoise=input('Avoid Noz SignalToNoise baseline: yes=1, no=0  -->  ')
LastBlockTap=input('Last Block tapping: yes=1, no=0 m blockListen=2 -->  ')

%% 

if LastBlockTap==0
    block=1:6
elseif LastBlockTap==1
    block=5:6
else
    block=1:4
end
    


data=struct;
for p=1:length(participants)
    namep=[participants{p}];
    for block=block
        
        load(strcat( ['MEG_DATA/' namep '_dat_clean' num2str(block) '.mat']));
        
        data.trial((((block-1)*24)+1):(24*block))=dat_clean.trial;
        data.trialinfo((((block-1)*24)+1):(24*block))=dat_clean.trialinfo';
        data.sampleinfo((((block-1)*24)+1):(24*block),:)= dat_clean.sampleinfo;
    end
end

%cd 'FreqTagZP'
%%
numbOfEvents=[];
for p=1:length(participants)
    namep=[participants{p}];
    for c = 1:length(conditions)
        namec=[conditions{c}];
       who=[find(data.trialinfo==(trialCODE(c))) find(data.trialinfo==(trialCODE(c)+100)) find(data.trialinfo==(trialCODE(c)+200))];
       numbOfEvents=[numbOfEvents;length(who)];
       MEEG_trial.(namep).(namec) = {};
       for tr=1:length(who)
           time = data.trial{who(tr)}(channels,[625:10000]);
           MEEG_trial.(namep).(namec).data{1,tr}=time;
           MEEG_trial.(namep).(namec).sampleinfo(tr,:) = data.sampleinfo(who(tr),:);
       end    
    end
end

%% 
cfg = [];
mri = ft_volumereslice(cfg, mri_realigned);
%%
for c = 1:length(conditions)
    namec=[conditions{c}];
   
    epochs.trial = MEEG_trial.(namep).(namec).data;
    epochs.time = repmat({(625:10000)/1000},1,length(epochs.trial));
    epochs.label = electrodes';
    epochs.grad = grad;
    epochs.fsample = 1000;
    epochs.sampleinfo = MEEG_trial.(namep).(namec).sampleinfo;
    
    cfg = [];
    cfg.method    = 'mtmfft';
    cfg.output    = 'powandcsd';
    cfg.pad = 'nextpow2';
    cfg.tapsmofrq = 0.107;
    cfg.foilim    = [1.5 1.7];
    cfg.channel = {'MEG'};
    freq = ft_freqanalysis(cfg, epochs);
    
    cfg = [];
    % cfg.xlim = [0.9 1.3];
    % cfg.ylim = [15 20];
    %cfg.zlim = [0  3*10^-13];
    %cfg.baseline = [-0.5 -0.1];
    %cfg.baselinetype = 'absolute';
    cfg.layout = 'neuromag306planar.lay';
    %figure; ft_topoplotTFR(cfg,freq); colorbar
   % print(sprintf('topo_freq_%d', cond),'-dpng', '-r300');
      
    cfg              = [];
    cfg.method       = 'dics';
    cfg.frequency    = [1.5, 1.7];
    cfg.sourcemodel  = grid;
    cfg.headmodel    = headmodel;
    cfg.dics.projectnoise = 'yes';
    cfg.dics.normalize = 'yes';
    cfg.dics.lambda = 1;
    
    source_result = ft_sourceanalysis(cfg, freq);
    
    cfg            = [];
    cfg.downsample = 2;
    cfg.parameter = 'pow';
    source_int  = ft_sourceinterpolate(cfg, source_result , mri);
    
%     cfg = [];
%     cfg.nonlinear = 'no';
%     source_int = ft_volumenormalise(cfg, source_int);
    
    cfg              = [];
    cfg.method       = 'slice';
    cfg.funparameter  = 'pow';
    cfg.maskparameter = cfg.funparameter;
    cfg.opacitylim    = [0 3*(10^-26)];
    cfg.opacitymap    = 'rampup';
    cfg.funparameter = 'pow';
    cfg.funcolorlim   = [0 3*(10^-26)];
    ft_sourceplot(cfg,source_int);
    print(sprintf('source_freq_%s', namec),'-dpng', '-r300');
    close all
end