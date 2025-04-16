%Exercise6  

%Exercise6
%Tommi Paakki

%Tommi Paakki
close all
clear all
clc

load('ex6_data_set1.mat')

tic

C = 1; %Coherent integration [ms]
K = 1; %NonCoherent integration [ms]

Fs = 4e6;
Ts = 1/Fs;

samples = round(C * 1e-3 * Fs); % amount of samples per coherent integration
seconds = C * 1e-3;


for prn = 1:6
    prn % for data set 1
% for prn = 1:6 % for data set 1    
    for ncoh = 1:K
        
        I_in = I((ncoh-1)*samples+1:samples*ncoh);
        Q_in = Q((ncoh-1)*samples+1:samples*ncoh);
        t = (ncoh-1)*seconds:Ts:ncoh*seconds-Ts;
        
        [Iout0,Qout0] = make_search_grid_handout(I_in,Q_in,t,prn,C);
        
        a(:,:,ncoh) = Iout0.^2 + Qout0.^2;
    end
    total_power = sum(a, 3);
    figure
    surf(total_power);
    
end
toc