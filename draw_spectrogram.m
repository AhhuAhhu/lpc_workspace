function draw_spectrogram(wav)
fs = 16000;
frame_length = 0.025;  % 25ms
frame_shift = 0.005; % 5ms
fft_length = 512; % 512

wav_length = length(wav);
frame_points = frame_length * fs;
step_points = frame_shift * fs;
num_of_frames = floor((wav_length - frame_points) / step_points) + 1;
ham_win = hamming(frame_points);
wav_feature = [];
energy_feature = [];
for i=1:num_of_frames
    start_point = (i - 1) * step_points + 1;
    end_point = (i - 1) * step_points + frame_points;
    wav_feature(i,:) = (ham_win').*(wav(start_point:end_point)');
end

fft_feature = [];
magnitude = [];
phase = [];
for i=1:num_of_frames
    fft_feature(i,:) = fft(wav_feature(i,:),fft_length);
    temp = abs(fft_feature(i,:));
    temp = log(temp);
    magnitude(i,:) = temp(1:fft_length / 2 + 1);
    temp = angle(fft_feature(i,:));
    phase(i,:) = temp(1:fft_length / 2 + 1);
end

figure;
imagesc(magnitude');title('magnitude spectrogram');
end

