clear all
cd 'C:\Users\au631438\Desktop\PROJECTS\Groove\MEG2022\Stimuli'
%addpath 'C:\Users\au631438\Desktop\PROJECTS\Groove\SoundAmplitudes\ZscoresOct21\STIMULI96BPM'

%% FOR PILOT 1

StimNames={'LR3LH2';'LR3LH3';'LR3LH4';'LR3MH1';'LR3MH2';'LR3MH4';'LR3HH3';'LR3HH5';'LR3HH6';'LR6LH2';'LR6LH3';'LR6LH4';'LR6MH1';'LR6MH2';'LR6MH4';'LR6HH3';'LR6HH5';'LR6HH6';'LR7LH2';'LR7LH3';'LR7LH4';'LR7MH1';'LR7MH2';'LR7MH4';'LR7HH3';'LR7HH5';'LR7HH6';'SonClaveMR1LH2';'SonClaveMR1LH3';'SonClaveMR1LH4';'SonClaveMR1MH1';'SonClaveMR1MH2';'SonClaveMR1MH4';'SonClaveMR1HH3';'SonClaveMR1HH5';'SonClaveMR1HH6';'RumbaClaveMR2LH2';'RumbaClaveMR2LH3';'RumbaClaveMR2LH4';'RumbaClaveMR2MH1';'RumbaClaveMR2MH2';'RumbaClaveMR2MH4';'RumbaClaveMR2HH3';'RumbaClaveMR2HH5';'RumbaClaveMR2HH6';'MariatoClaveMR5LH2';'MariatoClaveMR5LH3';'MariatoClaveMR5LH4';'MariatoClaveMR5MH1';'MariatoClaveMR5MH2';'MariatoClaveMR5MH4';'MariatoClaveMR5HH3';'MariatoClaveMR5HH5';'MariatoClaveMR5HH6';'HR1LH2';'HR1LH3';'HR1LH4';'HR1MH1';'HR1MH2';'HR1MH4';'HR1HH3';'HR1HH5';'HR1HH6';'HR3LH2';'HR3LH3';'HR3LH4';'HR3MH1';'HR3MH2';'HR3MH4';'HR3HH3';'HR3HH5';'HR3HH6';'HR7LH2';'HR7LH3';'HR7LH4';'HR7MH1';'HR7MH2';'HR7MH4';'HR7HH3';'HR7HH5';'HR7HH6';[];[];[];[];[];[];[];[];[];'Metro2LH';'Metro1LH';[];'Metro2MH';'Metro1MH';[];'Metro2HH';'Metro1HH'};
%StimPilot1=[95,98,94,97,5,7,24,26,33,35,50,52,59,61,69,71];
%StimPilot1=[95,94,5,24,33,50,59,69;98,97,7,26,35,52,61,71];
%StimPilot1=[95,94,5,24,33,50,59,69;98,97,7,25,35,52,61,71];%<-- wrong


%figure('units','normalized','outerposition',[0 0 1 1])

for number=[95,94,5,24,33,50,59,69,98,97,7,26,35,52,61,71]%1:length(StimPilot1)%[91 92 94 95 97 98 1:81]
     
        [inwave96, fs] = audioread(['C:\Users\au631438\Desktop\PROJECTS\Groove\SanderGenerator\stims\96\macro-output\' StimNames{number} '.wav']);%' %num2str(number2, '%02.f') '.wav']);%[inwave0, fs] = audioread([StimNames(number) '.wav']);
        %sound(inwave96, fs)
        BarLength=((2.5)*fs);%round((2.5/4)*fs);
        if BarLength>=length(inwave96)
            BarStim0= [inwave96; zeros(2,BarLength-length(inwave96))']; %%%%%%%%%FIX LAST SOUND fade out
        else
            BarStim0= [inwave96(1:BarLength,:)];
        end
        ramp=ones(1,length(BarStim0)); ramp([end-410:end])=(1:-(0.9/410):0.1); %(441 bins) --> 10ms
        NewStim0=[BarStim0; BarStim0; BarStim0; BarStim0.*ramp'];      % sound(NewStim0, fs)  

figure('units','normalized','outerposition',[0 0 1 1])
plotI=0;
    for  tp=[93 96 100] 
        %% GET SOUND (f.ex. from Iowa http://theremin.music.uiowa.edu/MISviolin.html)
        addpath(['C:\Users\au631438\Desktop\PROJECTS\Groove\SanderGenerator\stims\' num2str(tp) '\macro-output'])%'C:\Users\au631438\Desktop\PROJECTS\Groove\SoundAmplitudes\'
    
        BarStim=[] ;
        [inwave0, fs] = audioread([StimNames{number} '.wav']);
        BarLength=((3)*fs);%round((2.5/4)*fs);
        if BarLength>=length(inwave0)
         BarStim= [inwave0; zeros(2,BarLength-length(inwave0))'];
        else
         BarStim= [inwave0(1:BarLength,:)];   
        end
       
        ramp2=ones(1,length(BarStim)); ramp2([end-410:end])=(1:-(0.9/410):0.1); %(441 bins) --> 10ms
        NewStim=[NewStim0; zeros(2, 2*(2.5)*fs)'; BarStim.*ramp2']';     
        
    %To MONO
    stereo = NewStim';%inwave0;                       % Signal
    lv = ~sum(stereo == 0, 2);                          % Rows Without Zeros (Logical Vector)
    mono = sum(stereo, 2);                              % Sum Across Columns
    mono(lv) = mono(lv)/2;                              % Divide Rows Without Zeros By ‘2’ To Get Mean
    inwave=mono;
    
        plotI=(plotI+1);
        subplot(3,1,plotI)
        dt = 1/fs;
        t = 0:dt:(length(inwave)*dt)-dt;
        plot(t,inwave,'r', 'Color', [0.9290 0.6940 0.1250]); xlabel('Seconds'); ylabel('Sound Amplitude'); hold on;% plot([2,4,6,8,10,12,14,16,18,20,22,24,26,28,30],0, 'r*');
        %plot(t,yy); xlabel('Seconds');
        title(['Sound ' num2str(number) ' ' StimNames{number} ' tempo' num2str(tp) 'BPM'])
        ylim([-0.6 0.6]);
        
        for b=[0.625:0.625:17.5]
        xline(b, ':');
        end
        xlim([0 18]);
        
        filename=['C:\Users\au631438\Desktop\PROJECTS\Groove\MEG2022\Stimuli\' num2str(number, '%02.f') '_t' num2str(tp, '%02.f') '.wav'];
        audiowrite(filename,NewStim',fs);
        rmpath(['C:\Users\au631438\Desktop\PROJECTS\Groove\SanderGenerator\stims\' num2str(tp) '\macro-output'])    
    end
    saveas(gcf, ['PlotsTempoStim\TempoSoundAmp' num2str(number, '%02.f') '.png'])
    %rmpath(['C:\Users\au631438\Desktop\PROJECTS\Groove\SanderGenerator\stims\' num2str(tp) '\macro-output'])
    close all
end

%%

S = dir( '*.wav' ); % all of the names are in the structure S anyway.
N = {S.name}';