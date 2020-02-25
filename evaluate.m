[inspeech, Fs1] = audioread('wav\\aslp_zhy_00010.wav');
[outspeech, Fs2] = audioread('lpcWav\\aslp_zhy_00010.wav');

% Draw the speech wavwform
figure;
subplot(2,1,1);
plot(inspeech);
title('original speech waveform');
grid;
subplot(2,1,2);
plot(outspeech);
title('synthesised speech waveform');
grid;

% Draw the speech spectrogram
draw_spectrogram(inspeech);
title('original speech spectrogram');
grid;
draw_spectrogram(outspeech);
title('synthesised speech spectrogram');
grid;