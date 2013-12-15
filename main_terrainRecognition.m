%% MPOV – Poèítaèové vidìní
% Segmentace satelitních map
% Pùlsemestrální projekt è.2

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
close all; clear; clc;
% addpath(genpath('D:\EDUC\m1\V_MPOV'));
addpath(genpath('.\subtightplot'));
addpath(genpath('.\_functions'));

%% set figure index
global FI; FI = 0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load images
disp('Loading images');
i = 1;
% for i=1:6
%     ob{i} = imread(strcat('pic\map',num2str(i),'.png'));
%     fn{i} = strcat('pic\map',num2str(i),'.png');
% end
% i=7;
% ob{i} = imread(strcat('pic\small.png')); fn{i}=strcat('pic\small.png'); i=i+1;
% ob{i} = imread(strcat('pic\small_map.png')); fn{i}=strcat('pic\small_map.png');
ob{i} = imread(strcat('pic\smaller.png')); fn{i}=strcat('pic\smaller.png');

map2segments('pic\smaller.png',1,1,1,1);



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
