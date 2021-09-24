clear;clc
work_dir = 'E:\EEG\';
EEG = pop_loadcnt('E:\EEG\sample.data.cnt' , 'dataformat', 'auto', 'memmapfile', '');
EEG=pop_chanedit(EEG, 'lookup','F:\\yinqing\\eeglab14_0_0b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp');
EEG = pop_select( EEG,'nochannel',{'CB1' 'CB2'  'Trigger'});
EEG = pop_eegfiltnew(EEG, [],1,3300,1,[],1);%high-pass 1HZ
EEG = pop_eegfiltnew(EEG, [],45,294,0,[],1);%low-pass 45HZ 
%EEG = pop_eegfiltnew(EEG, 49,51,3300,1,[],0);% notch 50HZ
disp('Filter Done!');  
EEG = pop_resample( EEG, 250); %resampling
EEG = pop_reref( EEG, [33 43] ,'exclude',[63 64] );
EEG = pop_saveset( EEG, 'filename','sample.data.set','filepath','E:\EEG\refdata');
EEG = pop_loadset( 'filename','sample.data.set','filepath','E:\EEG\refdata'); 
EEG = pop_epoch( EEG, [], [-0.2         0.8], 'newname', ['sub' num2str(sub_list(sub_nr)) '_epoch'], 'epochinfo', 'yes');%[]表示所有的event，-0.2-0.8表示1m的epoch，这里有23个epoch
EEG = pop_rmbase( EEG, [-200    0]);
%Input data size [64,1542600] = 64 channels, 1542600 frames/nFinding 64 ICA components using extended ICA.
EEG = pop_runica(EEG, 'extended',1,'interupt','on');
disp('ICA Done!');  
EEG = pop_select( EEG,'nochannel',{'HEO' 'VEO'});%去除参考电极和眼电
%% Clearing badchannels 
% EEGLAB -- Automatic Channel Rejection -- 'spec'
[~,indelec] = pop_rejchan(EEG, 'elec',[1:60] ,'threshold',5,'norm','on','measure','spec');
badchannels = indelec';  
misplaced_channels = badchannels;
index1 = find(misplaced_channels > 32 & misplaced_channels < 41); 
index2 = find(misplaced_channels > 40);
misplaced_channels(index1) = misplaced_channels(index1)+1;
misplaced_channels(index2) = misplaced_channels(index2)+2;
badchannels = misplaced_channels;
EEG.data(badchannels,:) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG = pop_saveset( EEG, 'filename','sample.data_pre.set','filepath','E:\EEG\predata');
%%%%%ICA
EEG = pop_loadset('filename','sample.data.set','filepath','E:\EEG\result\\');
pop_selectcomps(EEG, [1:62] );
EEG = pop_eegthresh(EEG,0,[1:62] ,-100,100,-0.2,0.796,0,0);
pop_eegplot( EEG, 1, 1, 1);