  clc; clear;
  
  dx = 0.3; %ȡ�������λum
  size_of_pic = 500; %Ŀ��ͼƬ�Ĵ�С�� ��λum
  cycle_index = 10;%ѭ������
  image00 = imread('4.jpg');%����ͼƬ
  
  %�������ظ����� ��֤�ܸ���ͼƬ����Ϊ����ͼƬ���ĶԳƣ���֤NΪ����
  N = ceil( size_of_pic / dx); 
  if mod(N, 2) == 0
      N = N + 1;
  end
  
  %�������
  w_0 = 200;%�����뾶
  lamda = 0.6328; %waveLength
  z = 400;
  x_0 = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
  y_0 = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
  [Y, X] = meshgrid(x_0, y_0);
  U_i = 0.1 * exp(-(X .^ 2 + Y .^ 2) / w_0 ^ 2); %��˹����
  %U_i = 0.1; %ƽ��ⱸ��
  
  %����
  %image00 = rgb2gray(image00);%��ɻҶ�ͼ
  image_0 = im2double(image00);%���double����ʵ��ģ�����õ���
  [h, w] = size(image_0);%��ȡ��С
  
  %��ͼƬ���N*N�ͣ�����������Ƚϱ�����ֱ���и�����������䣬���Ҫ���õ�Ч����Ҫ��ֵ�㷨
  %�����ѡ��ͼƬ��������ú�N*Nʮ�ֽӽ�
  image_1 = zeros(N);
  if N - h >= 0
      if N - w >= 0
          image_1 ( floor((N - h) / 2) + 1 : floor((N - h) / 2) + h, floor((N - w) / 2) + 1 : floor((N - w) / 2) + h ) = image_0;%��Ŀ��ͼƬ����
      else
          image_1( floor((N - h) / 2) + 1 : floor((N - h) / 2) + h, : ) = image_0( : , floor((w - N) / 2) + 1 : floor((w - N) / 2) + N);
      end
  else 
      if N - w >= 0
          image_1 ( : , floor((N - w) / 2) + 1 : floor((N - w) / 2) + h) = image_0( floor((h - N) / 2) + 1 : floor((h - N) / 2) + N, : );
      else
          image_1 = image_0(floor((h - N) / 2) + 1 : floor((h - N) / 2) + N, floor((w - N) / 2) + 1 : floor((w - N) / 2) + N);
      end
  end
  %image_1������ʹ�õ�ԭͼ       
  amplitude_image = sqrt(image_1);%��ȡ���
  
  %���ԭͼ
  figure;
  subplot(1, 2, 1);
  imshow(image_1);
  title('ԭͼ');
  
  %����ȫϢƬ�ϵ������λ
  radius = 100;
  disk = zeros(N);
  for m = 1 : N
      for n = 1 : N
          if x_0(n) ^ 2 + y_0(m) ^ 2 < radius ^ 2
              disk(m, n) = exp( 1i * 2 * pi * rand(1, 1));
          end
      end
  end
  
  %����RS�㷨֮ǰ��һ��RS���䣬 �������
  U_in = U_i * disk;
  U_out = RS_(U_in, z, lamda, N, N, dx, dx);
  amplitude_out = abs(U_out);
  phase_out = U_out ./ amplitude_out;
  
  %������GS�㷨��ѭ������
  U_down_i = phase_out .* amplitude_image; %����down�±꣬��������RS�����������̣� up�±��������RS�������������
  for j = 1 : 1 : cycle_index %ѭ������
      
      tic
      U_down_o = RS_(U_down_i, z, -lamda, N, N, 0.3, 0.3);
      amplitude_down_o = abs(U_down_o);
      disk = U_down_o ./ amplitude_down_o;
  
      U_up_i = disk .* U_i;
      U_up_o = RS_(U_up_i, z, lamda, N, N, 0.3, 0.3);
      amplitude_up_o = abs(U_up_o);
      phase_up_o = U_up_o ./ amplitude_up_o;
      U_down_i = phase_up_o .* amplitude_image;
      
      toc
      
  end

  subplot(1, 2, 2);
  imshow(amplitude_up_o .^ 2);
  title('��ԭͼƬ');
  