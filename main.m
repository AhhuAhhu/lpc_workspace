clc;
clear all;

%[inspeech, Fs] = audioread('wav\\aslp_zhy_00001.wav');
%draw_spectrogram(inspeech);
%%[Coeff] = proclpc(inspeech);
%draw_spectrogram(inspeech);

% step 3
%write2lpctxt('lpctxt\\aslp_zhy_00001.lpc', Coeff);
%system('sptk3.1\\x2x +af <lpctxt\\aslp_zhy_00010.lpc >lpc\\aslp_zhy_00010.lpc');

[a1,Fs] = audioread('wav\\aslp_zhy_00010.wav');
[a2,FS2]=audioread('lpcwav\\aslp_zhy_00010.wav');
N1=length(a1);
N2=length(a2);
N=min(N1,N2);
for i=1:N
    t1=a1(i)*a1(i);
end
for i=1:N
    t2=(a1(i)-a2(i))*(a1(i)-a2(i));
end
snr=10*log(t1/t2);
snr


