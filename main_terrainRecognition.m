%% MPOV – Poèítaèové vidìní
% Segmentace satelitních map
% Pùlsemestrální projekt è.2

% function main_terrainRecognition(speedUp)
function main_terrainRecognition()

%% Zadání:
% -	Úkolem studentù je se z pøedložených satelitních snímkù vysegmetovat jednotlivé druhy terénù. 
% - K rozhodnutí o pøíslušnosti do jednotlivých skupin, musí být použito tzn. uèení bez uèitele (napø. algoritmus MeanShift). 
% -	Segmentaci proveïte hierarchickým zpùsobem z dùvodu pøesnìjšího rozdìlení oblastí na menší celky. 
% -	Správnost segmentace a rozdìlení do tøíd bude otestováno na zvláštní množinì dat, ke které studenti nebudou mít pøístup. 
% -	Následnì jednotlivé vysegmentované oblasti vhodnì statisticky analyzujte a v dokumentaci zhodnote. 
% -	Statistické metody konzultujte s vedoucím! Projekt bude vypracován v Matlabu.
% 
%% Vstupy: 
% -	Sada satelitních snímkù
% 
%% Výstupy: 
% -	Segmentovaný snímek a indexovaný snímek 
% -	Textový soubor se statistickými hodnotami jednotlivých oblastí 
% -	Dokumentace

%% Vypracování

%% clean-up & dependencies
% close all; clc; clear; 
addpath(genpath('.\_functions'));

%% set figure index
global FI; FI = 0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('main_terrainRecognition started');
%% segment individual maps
% for i=1:6
%     ob{i} = imread(strcat('pic\map',num2str(i),'.png'));
%     fn{i} = strcat('pic\map',num2str(i),'.png');
% end
% i=7;
% ob{i} = imread(strcat('pic\small.png')); fn{i}=strcat('pic\small.png'); i=i+1;
% ob{i} = imread(strcat('pic\small_map.png')); fn{i}=strcat('pic\small_map.png');
% ob{i} = imread(strcat('pic\smaller.png')); fn{i}=strcat('pic\smaller.png');

% imMax = imread('pic\map5.png');
imPath = 'd:\EDUC\m1\V_MPOV\proj_terrain_recognition\TRY\pic\map5.png';
imMax = imread(imPath);


[pathstr,name,ext] = fileparts(imPath);




% try speedUp execution times for different resolutions
speedUp = 2;
disp(num2str(speedUp));
% for sc=logspace( -1, 0, 7);
% for sc=linspace( 0.2, 0.3, 4);
for sc = 0.2
    FI = FI+1;
    im_scaled = imresize( imMax, sc );
    im_path = [pathstr,'\',name,'_',num2str(sc*100),'_',num2str(speedUp),ext]
    imwrite(im_scaled,im_path);
    map2segments(im_path, speedUp, 1,1,1,1 );
end

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
