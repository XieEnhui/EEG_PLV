clc,clear
work_dir = 'E:\EEG\predata\';
matdata_dir=fullfile(work_dir,'matdata');
save_dir = 'E:\EEG\clusterplvdata\';
delta_dir=fullfile(save_dir,'PLVDelta');
theta_dir=fullfile(save_dir,'PLVTheta');
alpha_dir=fullfile(save_dir,'PLVAlpha');
beta_dir=fullfile(save_dir,'PLVBeta');
gamma_dir=fullfile(save_dir,'PLVGamma');
if ~exist(save_dir,'dir')
    mkdir(save_dir)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
EEG = pop_loadset('filename','sample.data_pre.set','filepath','E:\EEG\predata\');
data=EEG.data;
%data=reshape(EEG.data,60,[])
a=cell2mat({EEG.event(:).type}');
b=cell2mat({EEG.event(:).latency}');
marker=[a,b];
cd(matdata_dir);
save('sample.data.mat','data','marker');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG_size = [];
filename_b=[work_dir,'sample.data_pre'.mat'];%%%%listener's data
ID=num2str(subjlist(i));
EEG_a=load('E:\EEG\data\speaker.mat')
EEG_b=load(filename_b);
revertedtimeA = EEG_a.marker;%changetime --- revertedtime
revertedtimeB = EEG_b.marker;
EEG_a=EEG_a.EEG_clustered;
EEG_b=EEG_b.EEG_clustered;
EEG_a = EEG_a(:,revertedtimeA(find(revertedtimeA(:,3)==32),1):revertedtimeA(find(revertedtimeA(:,3)==64),1));%%%load your own marker
EEG_b = EEG_b(:,revertedtimeB(find(revertedtimeB(:,3)==8),1):revertedtimeB(find(revertedtimeB(:,3)==16),1));
EEG_size(i,1) = subjlist(i);
EEG_size(i,2) = size(EEG_a,2);
EEG_size(i,3) = size(EEG_b,2);
if size(EEG_a,2) ~= size(EEG_b,2)
    selectlength = min(size(EEG_a,2), size(EEG_b,2));
    EEG_a = EEG_a(:,1:selectlength);
    EEG_b = EEG_b(:,1:selectlength);
end
dataa_upd{1,1} = EEG_a;
datab_upd{1,1} = EEG_b;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%different frequency
if ~exist(delta_dir,'dir')
    mkdir(delta_dir)
end
cd(delta_dir);
CalPlvTotal(ID,2,4,dataa_upd,datab_upd,250);
if ~exist(theta_dir,'dir')
    mkdir(theta_dir)
end
cd(theta_dir);
CalPlvTotal(ID,5,7,dataa_upd,datab_upd,250);
if ~exist(alpha_dir,'dir')
    mkdir(alpha_dir)
end
cd(alpha_dir);
CalPlvTotal(ID,8,13,dataa_upd,datab_upd,250);
if ~exist(beta_dir,'dir')
    mkdir(beta_dir)
end
cd(beta_dir);
CalPlvTotal(ID,14,28,dataa_upd,datab_upd,250);
if ~exist(gamma_dir,'dir')
    mkdir(gamma_dir)
end
cd(gamma_dir);
CalPlvTotal(ID,28,40,dataa_upd,datab_upd,250);
disp(strcat('done',ID));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
cd(save_dir);
save('EEG_plv.mat','EEG_size');
clc
disp('finish all');
