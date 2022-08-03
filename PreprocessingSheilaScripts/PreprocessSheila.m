%Script to preprocess Sheila's data. Version2022.4

%Input: Iwave files (ic.asc.eeglab.data.txt and ic.asc.eeglab.events.txt).
%!!Input file name: Pair number needs to be characters 1:2 (ie paire 1= 01...txt)
%Output: Set & erp files, preprocessed (Pruned with ICA, 0.1hz/50hz filters applied, artifact rejection done...)

clear all
close all
clc

addpath(genpath('C:\Users\jeula\Documents\current subjects/eeglab2021.1'))

%open eeglab
eeglab

% search for .edf file in the current directory
searchFilter = '*data.txt';
currentDirectory = pwd;
asciiFileDirectory = fullfile( currentDirectory);
addpath( asciiFileDirectory );
searchString = [asciiFileDirectory, '/', searchFilter];
filesList = dir(searchString);

% Boucle pour lire tout .edf
for i=1:length(filesList)
    file_name(i)= fopen(filesList(i).name);% lire le fichier
    [folder, baseFileName, extension] = fileparts(filesList(i).name);
    [onlyFileNames{i}] = baseFileName;
end

for i=1:length(file_name)
    %initializing variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ERPSET =[];
    ERP =[];
    nameset=[];
    nameerp = [];
    name_temp=[];
    events=[];
    EEGSET=[];
    
    
    EEGSET = pop_importdata('dataformat','ascii','nbchan',56,'data', filesList(i).name ,'srate',248,'pnts',0,'xmin',0,'chanlocs',[currentDirectory '/chanloc28_56.ced']);
    
    searchFiltere = '*events.txt';
    currentDirectory = pwd;
    asciiFileDirectory = fullfile( currentDirectory);
    addpath( asciiFileDirectory );
    searchStringe = [asciiFileDirectory, '/', searchFiltere];
    filesListe = dir(searchStringe);
    
    EEGSET = pop_importevent( EEGSET, 'event', filesListe(i).name,'fields',{'latency' 'type'},'skipline',1,'timeunit',1, 'append','no','optimalign','on');
    
    events = [currentDirectory '/EVENTLIST-SHEYLA.txt'];
    
    EEGSET  = pop_editeventlist( EEGSET , 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List', events, 'SendEL2', 'EEG', 'UpdateEEG', 'codelabel', 'Warning', 'on' ); % GUI: 28-Jan-2020 12:15:23
    
    EEGSET = pop_epochbin( EEGSET , [-204.0  1000.0],  [ -204 -4]);
    
    nameset = filesList(i).name;
    
    % savefile
    EEGSET = pop_saveset( EEGSET, nameset,[currentDirectory]);
    
    for j=1:2
        %initializing variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        h=0;
        EEG=[];
        ERP=[];
        name_temp=[];
        nameset=[];
        nameerp = [];
        exportname=[];
        electrodes=[];
        placingelectrode=[];
        EEG=EEGSET
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        name_temp = filesList(i).name;
        % Selecting the subject
        
        if j==1 % human 1 0,1hz 50hz filters
            EEG=EEGSET
            nameset = ['0.1HZ_' name_temp(1:2) '_S1' '.'];
            nameerp = [name_temp(1:2) '_S1' '.erp'];
            electrodes =[5:28];
            frontals = [1:4];
            placingelectrode = {'nch1 = ch1 label Fp2',  'nch2 = ch2 label Fp1',  'nch3 = ch3 label F8',  'nch4 = ch4 label F7',...
                'nch5 = ch5 label Fz',  'nch6 = ch6 label Cz',  'nch7 = ch7 label Pz',  'nch8 = ch8 label P4',  'nch9 = ch9 label P3',  'nch10 = ch10 label T6',...
                'nch11 = ch11 label T5',  'nch12 = ch12 label T4',  'nch13 = ch13 label T3',  'nch14 = ch14 label F4',  'nch15 = ch15 label F3',...
                'nch16 = ch16 label Ft8',  'nch17 = ch17 label Ft7',  'nch18 = ch18 label Fc4',  'nch19 = ch19 label Fc3',  'nch20 = ch20 label Fcz',  'nch21 = ch21 label C4',...
                'nch22 = ch22 label C3',  'nch23 = ch23 label Tp8',  'nch24 = ch24 label Tp7',  'nch25 = ch25 label Cp4',  'nch26 = ch26 label Cp3',...
                'nch27 = ch27 label O2',  'nch28 = ch28 label O1'};
            EEG = pop_eegchanoperator(EEG, placingelectrode);%placing electrodes
            EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);
            % filter data
            EEGSET = pop_eegfiltnew( EEGSET, [], 50, [], false, [], 0); %50hz
            EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0); %0.1hz
            EEG = pop_saveset(EEG,[nameset],[currentDirectory]) %save
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
        elseif j==2 %human 2 0,1hz 50hz filters
            nameset = ['0.1HZ_' name_temp(1:2) '_S2' '.'];
            nameerp = [name_temp(1:2) '_S2' '.erp'];
            electrodes= [33:56];
            frontals= [29:32];
            placingelectrode = {'nch1 = ch29 label Fp2',  'nch2 = ch30 label Fp1',  'nch3 = ch31 label F8',  'nch4 = ch32 label F7',...
                'nch5 = ch33 label Fz',  'nch6 = ch34 label Cz',  'nch7 = ch35 label Pz',  'nch8 = ch36 label P4',  'nch9 = ch37 label P3',  'nch10 = ch38 label T6',...
                'nch11 = ch39 label T5',  'nch12 = ch40 label T4',  'nch13 = ch41 label T3',  'nch14 = ch42 label F4',  'nch15 = ch43 label F3',...
                'nch16 = ch44 label Ft8',  'nch17 = ch45 label Ft7',  'nch18 = ch46 label Fc4',  'nch19 = ch47 label Fc3',  'nch20 = ch48 label Fcz',  'nch21 = ch49 label C4',...
                'nch22 = ch50 label C3',  'nch23 = ch51 label Tp8',  'nch24 = ch52 label Tp7',  'nch25 = ch53 label Cp4',  'nch26 = ch54 label Cp3',...
                'nch27 = ch55 label O2', 'nch28 = ch56 label O1'};
            EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
            EEGSET = pop_eegfiltnew( EEGSET, [], 50, [], false, [], 0);% lowpass filter
            EEGSET = pop_eegfiltnew( EEGSET, 0.1, [], [], false, [], 0);% highpass filter
            EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);%load channel location info
            EEG = pop_saveset(EEG,[nameset],[currentDirectory]) %save set
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        end
        
        if j==1 % human 1 1Hz filter
            EEG=EEGSET
            nameset = ['1HZ_' name_temp(1:2) '_S1' '.'];
            electrodes=[5:28];
            frontals = [1:4];
            placingelectrode = {'nch1 = ch1 label Fp2',  'nch2 = ch2 label Fp1',  'nch3 = ch3 label F8',  'nch4 = ch4 label F7',...
                'nch5 = ch5 label Fz',  'nch6 = ch6 label Cz',  'nch7 = ch7 label Pz',  'nch8 = ch8 label P4',  'nch9 = ch9 label P3',  'nch10 = ch10 label T6',...
                'nch11 = ch11 label T5',  'nch12 = ch12 label T4',  'nch13 = ch13 label T3',  'nch14 = ch14 label F4',  'nch15 = ch15 label F3',...
                'nch16 = ch16 label Ft8',  'nch17 = ch17 label Ft7',  'nch18 = ch18 label Fc4',  'nch19 = ch19 label Fc3',  'nch20 = ch20 label Fcz',  'nch21 = ch21 label C4',...
                'nch22 = ch22 label C3',  'nch23 = ch23 label Tp8',  'nch24 = ch24 label Tp7',  'nch25 = ch25 label Cp4',  'nch26 = ch26 label Cp3',...
                'nch27 = ch27 label O2',  'nch28 = ch28 label O1'};
            EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
            % filter data
            EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
            EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);%load channel location info
            EEG = pop_saveset(EEG,[nameset],[currentDirectory]) %save set
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
        elseif j==2 %human 2 1hz filter
            EEG=EEGSET
            nameset = ['1HZ_' name_temp(1:2) '_S2' '.'];
            electrodes= [33:56];
            frontals= [29:32];
            placingelectrode = {'nch1 = ch29 label Fp2',  'nch2 = ch30 label Fp1',  'nch3 = ch31 label F8',  'nch4 = ch32 label F7',...
                'nch5 = ch33 label Fz',  'nch6 = ch34 label Cz',  'nch7 = ch35 label Pz',  'nch8 = ch36 label P4',  'nch9 = ch37 label P3',  'nch10 = ch38 label T6',...
                'nch11 = ch39 label T5',  'nch12 = ch40 label T4',  'nch13 = ch41 label T3',  'nch14 = ch42 label F4',  'nch15 = ch43 label F3',...
                'nch16 = ch44 label Ft8',  'nch17 = ch45 label Ft7',  'nch18 = ch46 label Fc4',  'nch19 = ch47 label Fc3',  'nch20 = ch48 label Fcz',  'nch21 = ch49 label C4',...
                'nch22 = ch50 label C3',  'nch23 = ch51 label Tp8',  'nch24 = ch52 label Tp7',  'nch25 = ch53 label Cp4',  'nch26 = ch54 label Cp3',...
                'nch27 = ch55 label O2', 'nch28 = ch56 label O1'};
            EEG = pop_eegchanoperator(EEG, placingelectrode); %placing electrodes
            % filter data
            EEGSET = pop_eegfiltnew( EEGSET, 1, [], [], false, [], 0);
            EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);%load channel location info
            EEG = pop_saveset(EEG,[nameset],[currentDirectory])
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
        end
        
        
    end
end

%% Human 1 (ICA, Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loop for H1 & H2 commented. Section now duplicated (for j=1, then for j=2)
%for j=1:2

j=1; % participant 1

%initializing variables
nameerp = [];
nameset = [];

EEG = pop_loadset('filename',['1HZ_' name_temp(1:2) '_S' int2str(j) '.set'],'filepath',[pwd]); %load 1hz dataset for ICA
nameerp = [name_temp(1:2) '_S' int2str(j) '.erp'];
nameset = [name_temp(1:2) '_S' int2str(j) '.set'];
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);%load channel location info

% automatic channel rejection
%pop_rejchan(EEG)
EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters
%  fprintf('If *bad* channels exist, remove them from brackets in pop_runica')
%% run ICA
%!!! Chanind remove *bad* electrode in Pop up (or if ICA automated, remove from brackets to run e.g.[1:23 25:28] %24)
EEG = pop_runica( EEG )
%EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:28], 'extended',1); %  change chanind to reject bad electrode if needed
EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) '_S' int2str(j) '.set'],'filepath',[pwd]); %save set

%ICA activation matrix
TMP.icawinv = EEG.icawinv;
TMP.icasphere = EEG.icasphere;
TMP.icaweights = EEG.icaweights;
TMP.icachansind = EEG.icachansind;

% apply matrix to 0.1hz dataset
clear EEG;
EEG = pop_loadset('filename', ['0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]); %load 0.1hz .set
EEG.icawinv = TMP.icawinv;
EEG.icasphere = TMP.icasphere;
EEG.icaweights = TMP.icaweights;
EEG.icachansind = TMP.icachansind;
clear TMP;
EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]); %save 0.1hz+ICA matrix .set

%% !!! when 'reject component' window pops up, before rejecting need to label components manually (precaution)
EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]);
%IC component rejection
%EEG=iclabel(EEG);
noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; %IC label parameters: 90% Muscle and Eye probability;
EEG = pop_icflag(EEG, noisethreshold);
% remove bad component(s)
EEG = pop_subcomp( EEG ); %manual check
% save
EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]); %set 0.1hz filter + ICA + bad ICs removed

% check bad channels again
EEG = pop_rejchan(EEG)
%EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters

fprintf('In next section: Remove *bad electrodes from brackets')
%% artifact detection


%%%!! exclude *bad* electrodes, comment which electrode(s) and restore
%%%after participant is done
frontals = [1 3:4]; %2
electrodes=[5:15 16:17 18:28];%take note of which electrode is removed

%peak to peak (frontal elec and other elec)
EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',[ -204 1000] );
EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',[ -204 1000] );

%flat line (frontal elec and other elec)
EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );
EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );

%close;
EEG = pop_saveset( EEG, [nameset] ,[pwd]);

%% compute erp
ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );

% load channel location information
ERP = pop_erpchanedit( ERP, [currentDirectory '/Chanloc28.ced']);

% Save the erp
ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd], 'Warning', 'on');
ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\' nameerp(1:end-4) '.txt'])


fprintf(':) Participant 1 done :)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Human 2 (ICA, Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

j=2; % participant 1

%initializing variables
nameerp = [];
nameset = [];

EEG = pop_loadset('filename',['1HZ_' name_temp(1:2) '_S' int2str(j) '.set'],'filepath',[pwd]); %load 1hz dataset for ICA
nameerp = [name_temp(1:2) '_S' int2str(j) '.erp'];
nameset = [name_temp(1:2) '_S' int2str(j) '.set'];
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);%load channel location info
% automatic channel rejection
%pop_rejchan(EEG)
EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters
%  fprintf('If *bad* channels exist, remove them from brackets in pop_runica')
%% run ICA
%!!! Chanind remove *bad* electrode in Pop up (or if ICA automated, remove from brackets to run e.g.[1:23 25:28] %24)
EEG = pop_runica( EEG )
%EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:28], 'extended',1); %  change chanind to reject bad electrode if needed
EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(1:2) '_S' int2str(j) '.set'],'filepath',[pwd]); %save set

%ICA activation matrix
TMP.icawinv = EEG.icawinv;
TMP.icasphere = EEG.icasphere;
TMP.icaweights = EEG.icaweights;
TMP.icachansind = EEG.icachansind;
% apply matrix to 0.1hz dataset
clear EEG;
EEG = pop_loadset('filename', ['0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]); %load 0.1hz .set
EEG.icawinv = TMP.icawinv;
EEG.icasphere = TMP.icasphere;
EEG.icaweights = TMP.icaweights;
EEG.icachansind = TMP.icachansind;
clear TMP;
EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]); %save 0.1hz+ICA matrix .set

%% !!! when 'reject component' window pops up, before rejecting need to label components manually (precaution)
EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]);
%IC component rejection
EEG=iclabel(EEG);
noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; %IC label parameters: 90% Muscle and Eye probability;
EEG = pop_icflag(EEG, noisethreshold);
% remove bad component(s)
EEG = pop_subcomp( EEG ); 
% save
EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp(1:2) '_S' int2str(j) '.set'], 'filepath', [pwd]); %set 0.1hz filter + ICA + bad ICs removed

% check bad channels again
EEG = pop_rejchan(EEG) 
%, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters
                               
fprintf('In next section: Remove *bad electrodes from brackets')
%% artifact detection

%%%!! exclude *bad* electrodes, comment which electrode(s) and restore
%%%after participant is done
frontals = [2:4]; %1
electrodes=[5:15 16:17 18:28];%take note of which electrode is removed

%peak to peak (frontal elec and other elec)
EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',[ -204 1000] );
EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',[ -204 1000] );

%flat line (frontal elec and other elec)
EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );
EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );

%close;
EEG = pop_saveset( EEG, [nameset] ,[pwd]);

%% compute erp
ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );

% placing the electrodes for plot
%ERP = pop_erpchanoperator( ERP, placingelectrode );

% load channel location information
ERP = pop_erpchanedit( ERP, [currentDirectory '/Chanloc28.ced']);

% Save the erp
ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd], 'Warning', 'on');
ERP = pop_summary_AR_erp_detection(ERP, [currentDirectory '\' nameerp(1:end-4) '.txt'])
%ERP = pop_summary_rejectfields(EEG);
% EEG = pop_exporteegeventlist(EEG, 'Export_EEG_EL.txt');  
%         if j==2
%
%         end

fprintf(':) Participants done. Save your .set, .erp, .txt. Recalc elec. Plot erp. :)');
%end
%end

