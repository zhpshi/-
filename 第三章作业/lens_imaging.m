clc; clear;


M =  1; % ���÷Ŵ���


[object, map] = imread('a.bmp'); %����ͼƬ��map
object = im2double(object);%��ͼƬ��ֵ��ɡ�0��1���ϵ�˫�������������ǿ̫���ò������

[n_y, n_x] = size(object); %�õ�ͼƬ���ش�С
lamda = 0.633; %������Ĳ���
k = 2 * pi / lamda;
f = 100;  % ͸������
D = 420; %͸��ֱ��
dx = 0.3;
N = 6001; %NҪ��֤��ǡ�ø������ķŴ�����ͼƬ

z_1 = f * ( 1 / M + 1);
z_2 = M * z_1;    %�ɷŴ����õ��������

x = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
y = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
[X, Y] = meshgrid(x, y); 

%��������
Obj = zeros(N);
Obj (floor((N - n_x) / 2) + 1 : floor((N - n_x) / 2) + n_x, floor((N - n_y) / 2) + 1 : floor((N - n_y) / 2 + n_y)) = object;
figure(1);imshow( Obj, map);title('����');%���ܻῴ��������Ϊ�Թ�ǿ������С����Ӱ����

%��һ�δ��䣬 ����z1
E_front = RS_( Obj, z_1, lamda, N, N, dx, dx);
figure(2);imshow( abs( E_front) .^ 2, map);title('͸��ǰ�ⳡ');

%����͹͸��
lens = zeros(N);
for m = 1 : N
    for n = 1 : N
        if x(m) ^ 2 + y(n) ^ 2 <= ( D / 2) ^ 2
            lens(n, m) = 1 * exp( - 1i * k * ( x(m) ^ 2 + y(n) ^ 2) / f / 2);
        end
    end
end
figure(3); imshow( abs( lens ) .^ 2, map);title('͸����ǿ��ֵ');%�ڵģ�������

%͹͸����Ĺⳡ
E_behind = E_front .* lens;   
figure(4);imshow( abs( E_behind) .^ 2, map);title('͸����ⳡ');

%�ڶ��δ��䣬����z1
E_image = RS_( E_behind, z_2, lamda, N, N, dx, dx);
Image = abs( E_image ) .^ 2;
figure(5);imshow( Image, map );title('M = 1');
