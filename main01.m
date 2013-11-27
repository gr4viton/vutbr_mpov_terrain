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

% clean-up & dependencies
close all; clear; clc;
addpath(genpath('D:\EDUC\m1\V_MPOV'));
addpath(genpath('.\subtightplot'));

%% subtightplot
% make_it_tight = true;
addpath(genpath('.\subtightplot'));
subplot2 = @(m,n,p) subtightplot (m, n, p, [0.05 0.01], [0.05 0.01], [0.01 0.01]);
% if ~make_it_tight,  clear subplot;  end


% set figure index
global FI;
FI = 0;

%% load images
i = 1;
ob1 = imread(strcat('pic\map',num2str(i),'.png')); i=i+1;
ob2 = imread(strcat('pic\map',num2str(i),'.png')); i=i+1;
ob3 = imread(strcat('pic\map',num2str(i),'.png')); i=i+1;
ob4 = imread(strcat('pic\map',num2str(i),'.png')); i=i+1;
ob5 = imread(strcat('pic\map',num2str(i),'.png')); i=i+1;
ob6 = imread(strcat('pic\map',num2str(i),'.png')); i=i+1;
% for i=1:6
%     ob(:,:,i) = imread(strcat('pic\map',num2str(i),'.png'));
% end

%% method1 - otsu

im = ob1;
marg = max(size(im)) * 0.01;
a = method2(im,marg);
na = method2(255-im,marg);


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


FI=FI+1; figure(FI);  x = 2; y = 2; SI = 0;


SI=SI+1; subplot2(y,x,SI);
imshow(a,[]); ylabel(strcat('a = method1(im)')); axis tight

SI=SI+1; subplot2(y,x,SI);
imshow(na,[]); ylabel(strcat('na = method1(!im)')); axis tight

ana = a-na;
SI=SI+1; subplot2(y,x,SI);
imshow(ana,[]); ylabel(strcat('a - na')); axis tight

% im = im(marg:end-marg, marg:end-marg,:);
% imm = im.*ana;
% imm = im.*cat(3,ana,ana,ana);
SI=SI+1; subplot2(y,x,SI);
imshow(imm,[]); ylabel(strcat('original')); axis tight
% SI=SI+1; subplot2(y,x,SI);
% imshow(im,[]); ylabel(strcat('original')); axis tight


%% K-means

% meanshift
% rgb2gray
