function X = DFT(x)
    N = length(x);
    X = zeros(N, 1);
    for k = 0:N-1
        for n = 0:N-1
            X(k+1) = X(k+1) + x(n+1) * exp(-1j * 2 * pi * k * n / N);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 8000;
t = 0:1/Fs:1-1/Fs;
f1 = 500;
f2 = 1000;
f3 = 1500;
noise_amp = 0.2;
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.3*sin(2*pi*f3*t);
noise = noise_amp * randn(size(t));
audio = signal + noise;
plot(t, audio);
audiowrite('originalaudio.wav', audio, Fs);
sound(audio, Fs);




Y = DFT(audio');
a=Fs / length(Y);
b=0:length(Y)-1;
f = a*b;
figure;
plot(f, abs(Y));
title('Magnitude of the Audio Signal');
xlabel('Hz');
ylabel('measure');


band_low = 800;
band_high = 1200;

low = 800;
high = 1200;

%filtering

HLow = (f < low)';
HHigh = (f > high)';
HBand = (f > band_low & f < band_high)';

YLow = Y .* HLow;
YHigh = Y .* HHigh;
YBand = Y .* HBand;




lowFilterAudio= IDFT(YLow);
highFilterAudio = IDFT(YHigh);
bandFilterAudio= IDFT(YBand);


lowAudioToSave = real(lowFilterAudio) / max(abs(lowFilterAudio));
HighAudioToSave= real(highFilterAudio) / max(abs(highFilterAudio));
BandAudioToSave = real(bandFilterAudio) / max(abs(bandFilterAudio));

figure;
subplot(3,1,1);
plot(f, abs(DFT(lowAudioToSave)));
title('Low-pass Filtered');
xlabel('Hz');
ylabel('measure');

subplot(3,1,2);
plot(f, abs(DFT(HighAudioToSave)));
title('High-pass Filtered');
xlabel('Hz');
ylabel('measure');

subplot(3,1,3);
plot(f, abs(DFT(BandAudioToSave)));
title('Band-pass Filtered');
xlabel('Hz');
ylabel('measure');

sound(lowAudioToSave, Fs);
pause(length(audio)/Fs + 2);
sound(HighAudioToSave, Fs);
pause(length(audio)/Fs + 2);
sound(BandAudioToSave, Fs);

audiowrite('audiolow.wav', lowAudioToSave, Fs);
audiowrite('audiohigh.wav', HighAudioToSave, Fs);
audiowrite('audioband.wav', BandAudioToSave, Fs);

figure;
subplot(3,1,1);
plot(t, lowAudioToSave);
title('Low-pass Filtered Audio Signal');
xlabel('Tsecond');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, HighAudioToSave);
title('High-pass Filtered Audio Signal');
xlabel('Tsecond');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, BandAudioToSave);
title('Band-pass Filtered Audio Signal');
xlabel('Tsecond');
ylabel('Amplitude');





function x = IDFT(X)
    N = length(X);
    x = zeros(N, 1);
    for n = 0:N-1
        for k = 0:N-1
            x(n+1) = x(n+1) + X(k+1) * exp(1j * 2 * pi * k * n / N);
        end
        x(n+1) = x(n+1) / N;
    end
end
