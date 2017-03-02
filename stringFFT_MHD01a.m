% NOTE: Original file from Todd Gross (3/6/15).
% Modified by M.H. deLeon 3/6/15:
%   * Added grids to plots; labels to frequency plot.
%   * Changed FFT plot to linear in dBv and semilogx (log frequency)
%   * NOTE: need to run in "cell mode" - must hit the
%     "Run Section" button instead of "Run" for each section.

close all; clear all;

nheaderlines=32;
wave = importdata('p3.lvm','\t',nheaderlines); %You may have to adjust this
%the lvm file has four columns

t = wave.data(:,1);   %time vector
v1 = wave.data(:,2);  %waveform 1
v2 = wave.data(:,4);  %waveform 2
subplot(2,1,1)
plot (t,v1,t,v2); grid
xlabel ('Time (sec)')
ylabel ('Volts (V)')
T = t(2)-t(1);         % Time per sample
Fs = 1/T;              % Sampling frequency
L = size(v1);          % Length of signal - # of points
NFFT = 2^nextpow2(L(1)); % Next power of 2 from length of y - need for FFT 
Y1 = fft(v1,NFFT)./L(2); % this is a vector with complex number elements
Y2 = fft(v2,NFFT)./L(2); % this is a vector with complex number elements
% % Y(w)=A(w)-iB(w)=Integral of [y(t)*exp(-iwt)dt]
%Discrete Fourier Transform output
%                      N
%        Y(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N), 1 <= k <= N.
%                     n=1
% The spacing is determined from 1/Ndt where dt is the time spacing and N
% is the number of points.
% Need to divide by L because the function leaves that out of the output

f = Fs/2*linspace(0,1,NFFT/2+1); % linspace generates linearly spaced points
% % to the maximum frequency determined by sampling rate
% 
% % f is the frequency vector
% % Factor of 2 is because it is a two sided FT
% 
% % Plot single-sided amplitude spectrum.
subplot(2,1,2)
AY1=20*log10(abs(Y1(1:NFFT/2+1)));
AY2=20*log10(abs(Y2(1:NFFT/2+1)));
%AY1=2*abs(Y1(1:NFFT/2+1));
%AY2=2*abs(Y2(1:NFFT/2+1));
semilogx(f,AY1,f,AY2);grid  % abs(Y) = (Re(Y)^2 + Im(Y)^2)^1/2
axis([10 1000 -40 60])
xlabel ('Frequency (Hz.)')
ylabel ('Log Magnitude (dBv)')
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% subplot(2,1,2)
% semilogy(f,2*abs(Y2(1:NFFT/2+1)))
% % axis([0 1000 0 10])
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

%% Examples of synthetic signals 
TIME=0.1; %total time of data acquisition
T = TIME/4095; % Time per sample
Fs=1/T;
t = 0:T:TIME; % time vector
f1 = 310;
f2 = 233;
f3=1024;
v1 = 3*sin(2*pi*f1*t)+7*sin(2*pi*f2*t)+1.3*sin(2*pi*f3*t);
L=size(v1);
%Y1=fft(v1);
NFFT = 2^nextpow2(L(2)); % Next power of 2 from length of y - need for FFT 
Y1 = fft(v1,NFFT)./L(2); % this is a vector with complex number elements
% Y2 = fft(v2,NFFT)./L(1); % this is a vector with complex number elements
% % Y(w)=A(w)-iB(w)=Integral of [y(t)*exp(-iwt)dt]
%Discrete Fourier Transform output
%                      N
%        Y(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N), 1 <= k <= N.
%                     n=1
% The spacing is determined from 1/Ndt where dt is the time spacing and N
% is the number of points.
% Need to divide by L because the function leaves that out of the output

f = Fs/2*linspace(0,1,NFFT/2+1); % linspace generates linearly spaced points
% to the maximum frequency determined by sampling rate

% f is the frequency vector
% Factor of 2 is because it is a two sided FT

% Plot single-sided amplitude spectrum.
subplot(2,1,1)
plot(t,v1)
xlabel ('Time (sec)')  % Added by MHD 3/6/15
ylabel ('Volts (V)')  % Added by MHD 3/6/15

subplot(2,1,2)  %,f,2*abs(Y2(1:NFFT/2+1)))
semilogy(f,2*abs(Y1(1:NFFT/2+1)))  %,f,2*abs(Y2(1:NFFT/2+1)))
% abs(Y) = (Re(Y)^2 + Im(Y)^2)^1/2
% axis([0 1000 0.000001 1])
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
% %subplot(2,1,2)
% plot(f,2*abs(Y2(1:NFFT/2+1)))
axis([0 2000 0 10])
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
