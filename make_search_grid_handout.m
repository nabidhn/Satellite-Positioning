%Exercise6
%Tommi Paakki

function [Iout,Qout] = make_search_grid_handout(I,Q,t,prn,C)

f_baseband = 1.5e6;
code_repeat = 1e-3;
fc = 1.023e6;

prn_code_orig = generateCAcodes(prn);
double_prn_code_orig = kron(prn_code_orig, [1, 1]) ;% PRN code 2x oversample

doppler_bin_size = 2/(3 * C * 1e-3); % rule of thumb from lecture slides
doppler_search_range = -10e3 : doppler_bin_size : 10e3; % range presented in lectures(khz)
doppler_bin_max = length(doppler_search_range); % determined by doppler_search_range
code_bin_max = 2 * 1023; % recommended 0.5chip spacing

for doppler_bin = 1:doppler_bin_max
    
    % carrier wipeoff
    frequency = f_baseband + doppler_search_range(doppler_bin);
    cosine = cos(2 * pi * frequency .* t);
    sine = sin(2 * pi * frequency * t);
    
    II = I .* cosine + Q .* sine; % Baseband I
    QQ = Q .* cosine + I .* sine; % Baseband 
    
    
    for code_bin = 1:code_bin_max
        double_prn_code_sampled = ... 
        double_prn_code_orig(floor(mod(t,code_repeat)*2*fc)+1); % sample the 2x rate PRN with given t
        I_temp(code_bin,doppler_bin) = sum(double_prn_code_sampled .* II); % do I correlation
        Q_temp(code_bin,doppler_bin) = sum(double_prn_code_sampled .* QQ); % do Q correlation
        double_prn_code_orig = ...
            [double_prn_code_orig(2:end) double_prn_code_orig(1)]; % shift half a sample
           
    end
    
    
end

Iout = I_temp;
Qout = Q_temp;
