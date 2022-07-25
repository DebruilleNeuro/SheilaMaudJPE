%Script to preprocess Sheila's data in a LOOP. Version 1
%Input: Iwave files (ic.asc.eeglab.data.txt and ic.asc.eeglab.events.txt).
%!!Input file name: Pair number needs to be characters 1:2 (ie paire 1= 01...txt)
%Output: Set & erp files, preprocessed (Pruned with ICA, 0.1hz/50hz filters applied, artifact rejection done...)

clear all
close all
clc

addpath(genpath('C:\Users\jeula\Documents\current subjects/eeglab2021.1'))

%open eeglab
eeglab

% search for .edf file in the current directory /sourcedata
searchFilter = '*data.txt';
currentDirectory = pwd ;
FileDirectory = [pwd '/datatxt'];
asciiFileDirectory = fullfile(FileDirectory);
addpath( asciiFileDirectory );
searchString = [asciiFileDirectory, '/', searchFilter];
%filesList = dir(searchString);

searchFiltere = '*events.txt';
FileDirectory2 = [pwd '/eventstxt'];
asciiFileDirectory = fullfile( FileDirectory2);
addpath( asciiFileDirectory );
searchStringe = [asciiFileDirectory, '/', searchFiltere];
%filesListe = dir(searchStringe);

datatxtFiles = dir(searchString); 
N = length(datatxtFiles) ; 
EEGSET = cell(1,N) ; 

eventstxtFiles = dir(searchStringe); 
N = length(eventstxtFiles) ; 
EEGSET = cell(1,N) ; 

for i = 1:N %loop to create .set files for H1 & H2 for ALL PAIRES
   
    %initializing variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ERPSET =[];
    ERP =[];
    nameset=[];
    nameerp = [];
    name_temp=[];
    events=[];
    EEGSET=[];
    
    EEGSET = pop_importdata('dataformat','ascii','nbchan',56,'data',datatxtFiles(i).name ,'srate',248,'pnts',0,'xmin',0,'chanlocs',[currentDirectory '/chanloc28_56.ced']);
    %EEGSET = pop_importdata('dataformat','ascii','nbchan',56,'data', filesList(i).name ,'srate',248,'pnts',0,'xmin',0,'chanlocs',[currentDirectory '/chanloc28_56.ced']);

    
    EEGSET = pop_importevent( EEGSET, 'event', eventstxtFiles(i).name,'fields',{'latency' 'type'},'skipline',1,'timeunit',1, 'append','no','optimalign','on');
    %EEGSET = pop_importevent( EEGSET, 'event', filesListe(i).name,'fields',{'latency' 'type'},'skipline',1,'timeunit',1, 'append','no','optimalign','on');
    
    events = [currentDirectory '/EventlistStrangers.txt'];
    
    EEGSET  = pop_editeventlist( EEGSET , 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List', events, 'SendEL2', 'EEG', 'UpdateEEG', 'codelabel', 'Warning', 'on' ); % GUI: 28-Jan-2020 12:15:23
    
    EEGSET = pop_epochbin( EEGSET , [-204.0  1000.0],  [ -204 -4]);
    
    nameset = datatxtFiles(i).name;
    
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
        name_temp = datatxtFiles(i).name;
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
            EEG = pop_saveset(EEG,[nameset],[currentDirectory '/01HZ1']) %save
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
            EEG = pop_saveset(EEG,[nameset],[currentDirectory '/01HZ1']) %save set
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
            EEG = pop_saveset(EEG,[nameset],[currentDirectory '/1HZ1']) %save set
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
            EEG = pop_saveset(EEG,[nameset],[currentDirectory '/1HZ2'])
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            
        end
        
        
    end
end

%% Human 1 (ICA, Artifact rejection, Creation of ERP) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=1;

clear

        EEG=[];
        ERP=[];
        EEGSET=[];
        name_temp=[];
        nameset=[];
        nameerp = [];
        exportname=[];
        electrodes=[];
        placingelectrode=[];
        EEG=EEGSET;

if j==1
 searchFilter1hz = '*.set';
 %currentDirectory01hz = [pwd '/01HZ'];
 FileDirectory1hz = [pwd '/1HZ1'];
 set1FileDirectory = fullfile(FileDirectory1hz);
 addpath( set1FileDirectory );
 searchString1hz = [set1FileDirectory, '/', searchFilter1hz];
 Filelist1hz = dir(searchString1hz); 
 N = length(Filelist1hz) ; 
 EEGSET = cell(1,N) ;
 
elseif j==2
  searchFilter1hz = '*.set';
 %currentDirectory01hz = [pwd '/01HZ'];
 FileDirectory1hz = [pwd '/1HZ2'];
 set1FileDirectory = fullfile(FileDirectory1hz);
 addpath( set1FileDirectory );
 searchString1hz = [set1FileDirectory, '/', searchFilter1hz];
 Filelist1hz = dir(searchString1hz); 
 N = length(Filelist1hz) ; 
 EEGSET = cell(1,N) ;
  end 

if j==1;
 searchFilter01hz = '*.set';
 %currentDirectory01hz = [pwd '/01HZ'];
 FileDirectory01hz = [pwd '/01HZ1'];
 set01FileDirectory = fullfile(FileDirectory01hz);
 addpath( set01FileDirectory );
 searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
 Filelist01hz = dir(searchString01hz); 
 N = length(Filelist01hz) ; 
 EEGSET = cell(1,N) ; 
 
elseif j==2;
 searchFilter01hz = '*.set';
 %currentDirectory01hz = [pwd '/01HZ'];
 FileDirectory01hz = [pwd '/01HZ2' ];
 set01FileDirectory = fullfile(FileDirectory01hz);
 addpath( set01FileDirectory );
 searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
 Filelist01hz = dir(searchString01hz); 
 N = length(Filelist01hz) ; 
 EEGSET = cell(1,N) ; 
    end
 
for i = 1:N
    
%j=1; % participant 1

%initializing variables
nameerp = [];
nameset = [];
name_temp = Filelist1hz(i).name;
name_temp2 = Filelist01hz(i).name;

%EEG = pop_loadset(Filelist1hz(i).name)
EEG = pop_loadset('filename',['1HZ_' name_temp(5:6) '_S' int2str(j) '.set'],'filepath',[pwd '/1HZ' int2str(j)]); %load 1hz dataset for ICA
nameerp = [name_temp(5:6) '_S' int2str(j) '.erp'];
nameset = [name_temp(5:6) '_S' int2str(j) '.set'];
EEG = pop_editset(EEG, 'run', [], 'chanlocs', [pwd '/Chanloc28.ced']);%load channel location info

% automatic channel rejection
%pop_rejchan(EEG)
EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters
%  fprintf('If *bad* channels exist, remove them from brackets in pop_runica')
%% run ICA
%!!! Chanind remove *bad* electrode in Pop up (or if ICA automated, remove from brackets to run e.g.[1:23 25:28] %24)
EEG = pop_runica( EEG )
%EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', [1:28], 'extended',1); %  change chanind to reject bad electrode if needed
%EEG = pop_saveset( EEG, 'filename',['ICA_' Filelist1hz(i).name],'filepath',[pwd])
EEG = pop_saveset( EEG, 'filename',['ICA_1HZ_' name_temp(5:6) '_S' int2str(j) '.set'],'filepath',[pwd ]); %save set

%ICA activation matrix
TMP.icawinv = EEG.icawinv;
TMP.icasphere = EEG.icasphere;
TMP.icaweights = EEG.icaweights;
TMP.icachansind = EEG.icachansind;

% apply matrix to 0.1hz dataset
clear EEG;

%EEG = pop_loadset(Filelist01hz(i).name)
EEG = pop_loadset('filename', ['0.1HZ_' name_temp2(7:8) '_S' int2str(j) '.set'], 'filepath', [pwd '/01HZ' int2str(j)]); %load 0.1hz .set
EEG.icawinv = TMP.icawinv;
EEG.icasphere = TMP.icasphere;
EEG.icaweights = TMP.icaweights;
EEG.icachansind = TMP.icachansind;
clear TMP;
%EEG = pop_saveset( EEG, 'filename',['ICA_' Filelist01hz(i).name],'filepath',[pwd])
EEG = pop_saveset(EEG, 'filename',['ICA_0.1HZ_' name_temp2(7:8) '_S' int2str(j) '.set'], 'filepath', [pwd]); %save 0.1hz+ICA matrix .set

%% !!! when 'reject component' window pops up, before rejecting need to label components manually (precaution)
EEG = pop_loadset('filename', ['ICA_0.1HZ_' name_temp2(7:8) '_S' int2str(j) '.set'], 'filepath', [pwd]);
%IC component rejection
%EEG=iclabel(EEG);
noisethreshold = [0 0;0.9 1; 0.9 1; 0 0; 0 0; 0 0; 0 0]; %IC label parameters: 90% Muscle and Eye probability;
EEG = pop_icflag(EEG, noisethreshold);
% remove bad component(s)
EEG = pop_subcomp( EEG ); %manual check
% save
EEG = pop_saveset(EEG, 'filename',['ICs_ICA_0.1HZ_' name_temp2(7:8) '_S' int2str(j) '.set'], 'filepath', [pwd '/ICA int2str(j)']); %set 0.1hz filter + ICA + bad ICs removed

% check bad channels again
EEG = pop_rejchan(EEG)
%EEG = pop_rejchan(EEG, 'elec',[1:28],'measure','prob','norm','on','threshold',5); %automatic rejection parameters

fprintf('In next section: Remove *bad electrodes from brackets')

pause (30)

end

%% artifact detection loop
clear

j=1

        EEG=[];
        ERP=[];
        EEGSET=[];
        name_temp=[];
        nameset=[];
        nameerp = [];
        exportname=[];
        electrodes=[];
        placingelectrode=[];
        EEG=EEGSET;
        
        if j==1;
            searchFilter01hz = '*.set';
            %currentDirectory01hz = [pwd '/01HZ'];
            FileDirectory01hz = [pwd '/ICA'];
            set01FileDirectory = fullfile(FileDirectory01hz);
            addpath( set01FileDirectory );
            searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
            Filelist01hz = dir(searchString01hz);
            N = length(Filelist01hz) ;
            EEGSET = cell(1,N) ;
            
           
        elseif j==2;
            searchFilter01hz = '*.set';
            %currentDirectory01hz = [pwd '/01HZ'];
            FileDirectory01hz = [pwd '/ICA' ];
            set01FileDirectory = fullfile(FileDirectory01hz);
            addpath( set01FileDirectory );
            searchString01hz = [set01FileDirectory, '/', searchFilter01hz];
            Filelist01hz = dir(searchString01hz);
            N = length(Filelist01hz) ;
            EEGSET = cell(1,N) ;
        end
        
for i = 1:N
nameerp = [];
nameset = [];
name_temp = Filelist01hz(i).name;


%EEG = pop_loadset(Filelist1hz(i).name)
EEG = pop_loadset('filename',['ICs_ICA_' name_temp(11:12) '_S' int2str(j) '.set'],'filepath',[pwd '/ICA' int2str(j)]); %load 1hz dataset for ICA
nameerp = [name_temp(11:12) '_S' int2str(j) '.erp'];
nameset = [name_temp(11:12) '_S' int2str(j) '.set'];
%%%!! exclude *bad* electrodes, comment which electrode(s) and restore
%%%after participant is done
 frontals = [1:4]; %
 electrodes=[5:15 16:17 18:28];  %take note of which electrode is removed


%peak to peak (frontal elec and other elec)
EEG  = pop_artextval( EEG , 'Channel', electrodes, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow',[ -204 1000] );
EEG  = pop_artextval( EEG , 'Channel', frontals, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow',[ -204 1000] );

%flat line (frontal elec and other elec)
EEG  = pop_artflatline( EEG , 'Channel', electrodes, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );
EEG  = pop_artflatline( EEG , 'Channel', frontals, 'Duration',  100, 'Flag',  1, 'Threshold', [ -1e-07 1e-07], 'Twindow', [ -204 1000] );

%close;
EEG = pop_saveset( EEG, [nameset] ,[pwd '/sheila_strangers']);

%% compute erp
ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );

% load channel location information
ERP = pop_erpchanedit( ERP, [pwd '/Chanloc28.ced']);

% Save the erp
ERP = pop_savemyerp(ERP, 'erpname', nameerp, 'filename', nameerp, 'filepath', [pwd '/sheila_strangers'], 'Warning', 'on');
ERP = pop_summary_AR_erp_detection(ERP, [pwd '/sheila_strangers' nameerp(1:end-4) '.txt'])
ERP = pop_summary_rejectfields(EEG);

fprintf(':) Participant 1 done :)');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
