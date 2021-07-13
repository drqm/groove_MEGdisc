clear all
addpath 'C:\Users\au631438\Desktop\PROJECTS\Groove\groove_iEEG-master\groove_iEEG-master\stimuli\'
addpath C:\Users\au631438\Desktop\PROJECTS\Groove\SoundAmplitudes
cd C:\Users\au631438\Desktop\PROJECTS\Groove\discriminationStim\5sWithSound150ms\
%cd C:\Users\au631438\Desktop\PROJECTS\Groove\SoundAmplitudes\zp\
%cd C:\Users\au631438\Desktop\PROJECTS\Groove\SoundAmplitudes\envelope_function\


% [inwave0, fs] = audioread(['19.wav']); %plot(inwave0)
% hithat=inwave0([round(fs*3*2.5/4):round(fs*7*2.5/8)],:);%sound(inwave0([round(fs*3*2.5/4):round(fs*7*2.5/8)]), fs);


%%
for number=[1:81 91 92 94 95 97 98] %2 for low 2 for high harmony %[55:63]%
%% GET SOUND (f.ex. from Iowa http://theremin.music.uiowa.edu/MISviolin.html)


%[inwave0, fs] = audioread('all_song_adding_instrumentals.mp3');
if number<10
[inwave0, fs] = audioread(['0' num2str(number) '.wav']);
else
[inwave0, fs] = audioread([num2str(number) '.wav']);
end

duration=44100*15.6;

BeatLength=round((2.5/8)*fs);

if number>54 && number<64
ISObeat=inwave0([1:BeatLength],:);%sound(ISObeat,fs);
fade=[ones(2,11070) ones(2,(length(ISObeat)-11070))*0.05];
isoBEAT=ISObeat.*fade';%sound(isoBEAT,fs); plot(isoBEAT)
ISObeat=isoBEAT;
else
ISObeat=inwave0([1:BeatLength],:);%sound(ISObeat,fs);
end

basicSTIM=zeros(duration,2); basicSTIM(1:length(inwave0),:)=inwave0;
basicSTIM((10*fs)+1:(10*fs)+length(ISObeat),:)=ISObeat;%sound(basicSTIM, fs)
%% ANTICIPATED
anticipSTIM=basicSTIM;
anticipSTIM((44100*14.85+1):(44100*14.85+length(ISObeat)),:)=ISObeat;
filename=[num2str(number+100) '.wav'];
audiowrite(filename,anticipSTIM,fs);


%from stereo to mono
stereo = anticipSTIM;%inwave0;                       % Signal
lv = ~sum(stereo == 0, 2);                          % Rows Without Zeros (Logical Vector)
mono = sum(stereo, 2);                              % Sum Across Columns
mono(lv) = mono(lv)/2;                              % Divide Rows Without Zeros By ‘2’ To Get Mean
inwave=mono;
%sound(inwave, fs)

figure
y=inwave; 
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;

subplot(3,1,1)
    plot(t,y); xlabel('Seconds'); ylabel('Sound Amplitude'); hold on;% plot([2,4,6,8,10,12,14,16,18,20,22,24,26,28,30],0, 'r*');
    %plot(t,yy); xlabel('Seconds'); 
title('Anticipated Sound')
xline([15],'--r'); xline([2.5],'--r'); xline([5],'--r'); xline([7.5],'--r'); xline([10],'--r'); xline([12.5],'--r')%2.5 5 7.5 10 12.5
ylim([-0.6 0.6]);

%% ON TIME
ontimeSTIM=basicSTIM;
ontimeSTIM((44100*15+1):(44100*15+length(ISObeat)),:)=ISObeat;
filename=[num2str(number+200) '.wav'];
audiowrite(filename,ontimeSTIM,fs);


%from stereo to mono
stereo = ontimeSTIM;%inwave0;                       % Signal
lv = ~sum(stereo == 0, 2);                          % Rows Without Zeros (Logical Vector)
mono = sum(stereo, 2);                              % Sum Across Columns
mono(lv) = mono(lv)/2;                              % Divide Rows Without Zeros By ‘2’ To Get Mean
inwave=mono;
%sound(inwave, fs)


y=inwave; 
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;

subplot(3,1,2)
    plot(t,y); xlabel('Seconds'); ylabel('Sound Amplitude'); hold on;% plot([2,4,6,8,10,12,14,16,18,20,22,24,26,28,30],0, 'r*');
    %plot(t,yy); xlabel('Seconds'); 
title('ontime Sound')
xline([15],'--r'); xline([2.5],'--r'); xline([5],'--r'); xline([7.5],'--r'); xline([10],'--r'); xline([12.5],'--r')%2.5 5 7.5 10 12.5
ylim([-0.6 0.6]);


%% DELAYED
delaySTIM=basicSTIM;
delaySTIM((44100*15.15+1):(44100*15.15+length(ISObeat)),:)=ISObeat;
filename=[num2str(number+300) '.wav'];
audiowrite(filename,delaySTIM,fs);

%from stereo to mono
stereo = delaySTIM;%inwave0;                       % Signal
lv = ~sum(stereo == 0, 2);                          % Rows Without Zeros (Logical Vector)
mono = sum(stereo, 2);                              % Sum Across Columns
mono(lv) = mono(lv)/2;                              % Divide Rows Without Zeros By ‘2’ To Get Mean
inwave=mono;
%sound(inwave, fs)

y=inwave; 
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;
subplot(3,1,3)
    plot(t,y); xlabel('Seconds'); ylabel('Sound Amplitude'); hold on;% plot([2,4,6,8,10,12,14,16,18,20,22,24,26,28,30],0, 'r*');
    %plot(t,yy); xlabel('Seconds'); 
title('Delayed Sound')
xline([15],'--r'); xline([2.5],'--r'); xline([5],'--r'); xline([7.5],'--r'); xline([10],'--r'); xline([12.5],'--r')%2.5 5 7.5 10 12.5
ylim([-0.6 0.6]);

saveas(gcf, ['BeatTask_' num2str(number) '.png'])


close all
end