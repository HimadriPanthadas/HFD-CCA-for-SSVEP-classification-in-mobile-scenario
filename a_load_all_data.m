clear all;
addpath 'D:\EEE 4-1\BIC_MAT\matlab extensions\bbci_public'
addpath 'D:\EEE 4-1\BIC_MAT\matlab extensions\BCILAB-devel\BCILAB-devel'
MyDataDir='D:\dataset_BCI';
startup_bbci_toolbox('DataDir', MyDataDir);

%% Load Isolated data
BTB.DataDir = 'D:\dataset_BCI';

BTB.task = 'SSVEP'; %ERP, SSVEP
datatype = 'eeg';
%%
switch(BTB.task)
    case 'SSVEP'
        %what is segmentation?
        disp_ival= [0 5000]; % SSVEP 0-5000(ms)
        trig_sti = {11,12,13; '5.45','8.57','12'};
        nSub = 23;
    case 'ERP'
        disp_ival= [-200 800]; % ERP
        ref_ival= [-200 0] ;
        trig_sti = {2,1 ;'target','non-target'};
        nSub = 24;
end
%%
CNT = []; 
MRK = [];
EPO = [];
MNT = [];
for subNum = 1:nSub
    
    fprintf('Load Subject %02d ...\n',subNum)

    for sesNum = 1:5

        sub_dire = sprintf('sub-%02d/ses-%02d',subNum,sesNum);
        % sub-01_task-ERP_speed-0.8_scalp-EEG
        naming = sprintf('sub-%02d_ses-%02d_task-%s_%s',...
            subNum,sesNum,BTB.task,datatype);
        filename = fullfile(BTB.DataDir,sub_dire,datatype,naming);

        % load data
        try
            [CNT{subNum,sesNum}, mrk_orig, hdr] = file_readBV(filename, 'Fs', 100);
        catch
            continue;
        end

        % create mrk
        MRK{subNum,sesNum}= mrk_defineClasses(mrk_orig, trig_sti);
        %creating clas of when stimulations were given and what category of
        %stimulations were given

        % segmentation
        
        EPO{subNum,sesNum} = proc_segmentation(CNT{subNum,sesNum}, MRK{subNum,sesNum}, disp_ival);

        MNT= mnt_setElectrodePositions(CNT{subNum,sesNum}.clab);

    end
end


