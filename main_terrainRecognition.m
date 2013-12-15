%% MPOV � Po��ta�ov� vid�n�
% Segmentace satelitn�ch map
% P�lsemestr�ln� projekt �.2

%% Zad�n�:
% -	�kolem student� je se z p�edlo�en�ch satelitn�ch sn�mk� vysegmetovat jednotliv� druhy ter�n�. 
% - K rozhodnut� o p��slu�nosti do jednotliv�ch skupin, mus� b�t pou�ito tzn. u�en� bez u�itele (nap�. algoritmus MeanShift). 
% -	Segmentaci prove�te hierarchick�m zp�sobem z d�vodu p�esn�j��ho rozd�len� oblast� na men�� celky. 
% -	Spr�vnost segmentace a rozd�len� do t��d bude otestov�no na zvl�tn� mno�in� dat, ke kter� studenti nebudou m�t p��stup. 
% -	N�sledn� jednotliv� vysegmentovan� oblasti vhodn� statisticky analyzujte a v dokumentaci zhodno�te. 
% -	Statistick� metody konzultujte s vedouc�m! Projekt bude vypracov�n v Matlabu.
% 
%% Vstupy: 
% -	Sada satelitn�ch sn�mk�
% 
%% V�stupy: 
% -	Segmentovan� sn�mek a indexovan� sn�mek 
% -	Textov� soubor se statistick�mi hodnotami jednotliv�ch oblast� 
% -	Dokumentace

%% Vypracov�n�

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
%% matematick� morfologie - hit & miss
%% lokalni spektralni histogram
%% korelace - korela�n� matice
% kookurentn� matice co-occurence - statistika z odezvy na korelaci 
% fourierka - frekvencni
% wavelety
% vy�ezi z fourierky

% zkladni p�iznaky pro jednotlive oblasti - �ikmost etc ->
% fraktal

% image processing analysis and machine vision
% somka
% 17ta kapitola

%% K-means

% meanshift
% rgb2gray
