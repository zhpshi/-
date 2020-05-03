function Eout = RS_(Ein, z, lamda, N_x, N_y, dx, dy)
%�˺���ΪRayleigh-Sommerfield������ֺ��� EoutΪ����ⳡ
%   EinΪ����ⳡ
%   zΪ��������
%   lamdaΪ�Ⲩ��
%   N_x,N_y ΪEoutˮƽ�ʹ�ֱ��������ظ���
%   dx dyΪˮƽ��ֱ����Ĳ������
k = 2 * pi / lamda;
x = ( -(N_x - 1) / 2 : 1 : (N_x - 1) / 2) * dx;
y = ( -(N_y - 1) / 2 : 1 : (N_y - 1) / 2) * dy;
[X, Y] = meshgrid(x, y);

R = sqrt(z ^ 2 + X .^ 2 + Y .^ 2);
g = z ./ (2 * pi * R .^ 2 ) .* (- 1i * k + 1 ./ R) .* exp(1i * k * R); %g����������Ҫ

fg = fft2(g, N_x, N_y);
fEin = fft2(Ein, N_x, N_y);
Eout = fftshift(ifft2(fg .* fEin));
end

