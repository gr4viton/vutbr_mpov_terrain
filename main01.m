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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load images
% i = 1;
% ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png'); i=i+1;
% ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png'); i=i+1;
% ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png'); i=i+1;
% ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png'); i=i+1;
% ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png'); i=i+1;
% ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png'); i=i+1;
for i=1:6
    ob{i} = imread(strcat('pic\map',num2str(i),'.png'));fn{i}=strcat('pic\map',num2str(i),'.png');
end
i=7;
ob{i} = imread(strcat('pic\small.png'));fn{i}=strcat('pic\small.png');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method1 - otsu segmentation - not good

%%method3 - mean shift segmentation
% for i=1:7
%     im = fn{i};
% marg = max(size(im)) * 0.01;
% a = method3(im,marg,1);
% end
% na = method1(255-im,marg);
i=1;
im = fn{i};
marg = max(size(im)) * 0.01;
a = method3(im,marg,1);

% FI=FI+1; figure(FI);  x = 2; y = 2; SI = 0;
% 
% 
% SI=SI+1; subplot2(y,x,SI);
% imshow(a,[]); ylabel(strcat('a = method1(im)')); axis tight
% 
% SI=SI+1; subplot2(y,x,SI);
% imshow(na,[]); ylabel(strcat('na = method1(!im)')); axis tight
% 
% ana = a-na;
% SI=SI+1; subplot2(y,x,SI);
% imshow(ana,[]); ylabel(strcat('a - na')); axis tight
% 
% % im = im(marg:end-marg, marg:end-marg,:);
% % imm = im.*ana;
% % imm = im.*cat(3,ana,ana,ana);
% SI=SI+1; subplot2(y,x,SI);
% imshow(imm,[]); ylabel(strcat('original')); axis tight
% % SI=SI+1; subplot2(y,x,SI);
% % imshow(im,[]); ylabel(strcat('original')); axis tight
% 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method 2 - LAB color and Kmeans
% cutout(ob1,[30 30],20,20)
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
