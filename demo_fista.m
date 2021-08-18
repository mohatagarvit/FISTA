%% Denoising demo using FISTA (PNLM)
%  Obtaining the results of FISTA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  img      : clean grayscale image
%  imgNoisy : noisy grayscale image
%  
%  Author   : G. Mohata and Kunal N. Chaudhury, Indian Institute of Science.
%  Date     : Dec. 29, 2018
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all force; clear all;

% Clean image
img = double(imread('../images/cameraman.tif'));
[m, n] = size(img);
peak  = 255;

% Add noise
sigma     =  20;
imgNoisy  =  img  +  sigma * randn(m,n);
% imgNoisy = imnoise(img,'gaussian',0,15) ;%awgn(img,15);

% FISTA parameters
param.L0 = 1/0.001;
param.lamda = .001;
param.itr_max = 1000;

%% Denoising
% FISTA
disp('FISTA is running.......');
tic;
imgOut_FISTA = fista(imgNoisy, param);
t_FISTA = toc;

%% Results
PSNR_Noisy = 10 * log10(m * n * peak^2 / sum(sum((imgNoisy - img).^2)) )
PSNR_FISTA = 10 * log10(m * n * peak^2 / sum(sum((imgOut_FISTA - img).^2)) )

SSIM_Noisy = 100*ssim(img, imgNoisy)
SSIM_FISTA = 100*ssim(img, imgOut_FISTA)

t_FISTA

%% Displaying images
figure('Units','normalized','Position',[0 0 1 1]);
normap gray,
subplot(2,2,1); imshow(uint8(img)); title('Clean');
subplot(2,2,2); imshow(uint8(imgNoisy)); 
title([ 'Noisy, ', num2str(PSNR_Noisy, '%.2f'), 'dB, ', num2str(SSIM_Noisy, '%.2f')] , 'FontSize', 10),
subplot(2,2,3); imshow(uint8(imgOut_FISTA)); 
title([ 'NLM, ', num2str(PSNR_FISTA, '%.2f'), 'dB, ', num2str(SSIM_FISTA, '%.2f')] , 'FontSize', 10),