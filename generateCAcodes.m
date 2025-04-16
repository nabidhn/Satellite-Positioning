function CAcodes = generateCAcodes(prn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generateCAcodses.m generates GPS satellite C/A codes for specified PRNs
%
% CAcodes = generateCAcodes(PRN)
%
%   Inputs:
%       PRNs        - (nx1) vector of PRN numbers.
%
%   Outputs:
%       CAcodes     - (nx1023) matrix containing the desired C/A code
%                     sequences (chips).  
%--------------------------------------------------------------------------
% Copyright (C) Jason Bingham
% Modified from code by Darius Plausinaitis
% Based on Dennis M. Akos, Peter Rinder and Nicolaj Bertelsen
%--------------------------------------------------------------------------
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or (at your option) any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
%USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
L = length(prn) + 1;
%% Make the code shift array
% The shift depends on the PRN number. The g2s vector holds the appropriate
% shift of the g2 code to generate the C/A code [ex. for SV#19 - use a G2
% shift of g2s(19) = 471].
g2s = [  5,   6,   7,   8,  17,  18, 139, 140, 141, 251, ...
       252, 254, 255, 256, 257, 258, 469, 470, 471, 472, ...
       473, 474, 509, 512, 513, 514, 515, 516, 859, 860, ...
       861, 862 ... end of shifts for GPS satellites 
       ... Shifts for the ground GPS transmitter are not included
       ... Shifts for EGNOS and WAAS satellites (true_PRN = PRN + 87)
                 145, 175,  52,  21, 237, 235, 886, 657, ...
       634, 762, 355, 1012, 176, 603, 130, 359, 595, 68, ...
       386];

%% Pick right shift for the given PRN numbers
g2shift = g2s(prn)';

%% Generate G1 and G2 codes
% Initialize outputs to speed function
g = zeros(L, 1023);

% Load shift registers
reg = -1*ones(L, 10);

%% Generate all G1 and G2 signal chips
% Based on corresponding feedback polynomials
for i = 1:1023
    g(:,i) = reg(:,10);
    
    newBit = [reg(1,3).*reg(1,10);...
              reg(2:L,2).*reg(2:L,3).*reg(2:L,6).*reg(2:L,8).*...
              reg(2:L,9).*reg(2:L,10)];
    
    reg(:,2:10) = reg(:,1:9);
    
    reg(:,1) = newBit;
end

%% Shift G2 code and form sample C/A code
for i = 2:L
    g(i,:) = [g(i,1023-g2shift(i-1)+1:1023),g(i,1:1023-g2shift(i-1))];
    CAcodes(i-1,:) = -g(1,:).*g(i,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%