function main_terrainRecognition()
% /*********
% @subject  MPOV – Computer vision (Poèítaèové vidìní)
% @subtitle Half-term project, Pùlsemestrální projekt 
% @task#    2
% @project  Segmentation of sattelite maps - Segmentace satelitních map
% @filename main_terrainRecognition.m
% @author   Bc. Daniel Davídek <danieldavidk@gmail.com>
%           Bc. Peter Molèany <xmolca00@stud.feec.vutbr.cz>
% @date     2013_12_10
% @brief    this script demonstrates map2segments functionality on various
%           prescaled satelite images (maps)
% *********/

%% clean-up & dependencies
close all; clc; clear; 
addpath(genpath('.\_functions'));

%% set figure index
global FI; FI = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('main_terrainRecognition started');

%% load individual maps paths
nIm = 6;
for iIm=1:nIm 
    imPath_all{iIm} = ['pic\map',num2str(iIm),'.png'];
end

%% chose image index
% nice = 5
% nice & quick = 2
iChosen = 2;

%% load chosen image
imPath = imPath_all{iChosen};
imMax = imread(imPath);
[pathstr,name,ext] = fileparts(imPath);



%% just segm with defaults
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('map2segmentation - defaults');
sc = 0.1;
    FI = FI+1;
    im_scaled = imresize( imMax, sc );
    im_path = [pathstr,'\',name,'_',num2str(sc*100),ext]
    imwrite(im_scaled,im_path);
    map2segments_defArgs(im_path);

%% try different tresholds
% disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% disp('trying different tresholds');
% speedUp = 2;
% sc = 0.1;
% lumTreshold = -1; colTreshold = -1; 
% for colTreshold=linspace(0.1,1.5,5)
% % for lumTreshold=linspace(10,20,4) 
%     FI = FI+1;
%     im_scaled = imresize( imMax, sc );
%     im_path = [pathstr,'\',name,'_',num2str(sc*100),'_',...
%         num2str(lumTreshold),num2str(colTreshold),ext]
%     imwrite(im_scaled,im_path);
%     map2segments(im_path, 1,1,1,1, speedUp, [lumTreshold, colTreshold] );
% end


%% try different scales - NICE :)
% disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% disp('trying different scales');
% speedUp = 2;
% lumTreshold = -1; colTreshold = -1; 
% % for sc=logspace( -1, 0, 7);
% for sc=linspace( 0.1, 0.3, 4);
%     FI = FI+1;
%     im_scaled = imresize( imMax, sc );
%     im_path = [pathstr,'\',name,'_',num2str(sc*100),'_',...
%         num2str(lumTreshold),num2str(colTreshold),ext]
%     imwrite(im_scaled,im_path);
%     map2segments(im_path, 1,1,1,1, speedUp, [lumTreshold, colTreshold] );
% end

    
%% end
disp('main_terrainRecognition ended');

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% napady 
%% louka a les - stejna strukutra ale ruzna barva - potom co rozsegmetuju na 
%% matematická morfologie - hit & miss
%% lokalni spektralni histogram
%% korelace - korelaèní matice
% kookurentní matice co-occurence - statistika z odezvy na korelaci 
% fourierka - frekvencni
% wavelety
% vyøezi z fourierky

% zkladni pøiznaky pro jednotlive oblasti - šikmost etc ->
% fraktal

% image processing analysis and machine vision
% somka
% 17ta kapitola

%% K-means

% meanshift
% rgb2gray
