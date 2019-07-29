%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8bitת16bit ����
% ������
%   img_dir����ת����8λpng��ʽͼ��·��
%   img_savedir��ת����ɺ��16λpngͼ�񱣴�·��
% �޸ģ�
%   zzh 20190715
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ��ʼ������
clc
clear

%% ��������
img_dir = '..\test_data\8bit_data_1\'; %ԭͼ�ļ���
img_savedir = '..\test_data\16bit_data\'; %�����ļ���

%% ���� r g bӳ���
% load('map_ch1.mat');
% load('map_ch2.mat');
% load('map_ch3.mat');    
% idx = (find(~isnan(map_ch1)));
% map_ch1 = spline(idx, map_ch1(idx), 1:65536);
% idx = (find(~isnan(map_ch2)));
% map_ch2 = spline(idx, map_ch2(idx), 1:65536);
% idx = (find(~isnan(map_ch3)));
% map_ch3 = spline(idx, map_ch3(idx), 1:65536);
% r=zeros(1,256);
% g=zeros(1,256);
% b=zeros(1,256);
% for i=1:256
%     r(i)=min(find(map_ch1>=i-1))/255;
%     g(i)=min(find(map_ch2>=i-1))/255;
%     b(i)=min(find(map_ch3>=i-1))/255;
% end
% r=uint8(r);
% g=uint8(g);
% b=uint8(b);
% save('r.mat', 'r');
% save('g.mat', 'g');
% save('b.mat', 'b');

%% ͼ��ת��
load('r.mat');
load('g.mat');
load('b.mat');
img_list = dir([img_dir, '*.png']); %ԭͼ�ļ���ʽ 3ͨ��RGB .png��ʽ
img_names = {img_list.name};
img_num = length(img_names);

for k = 1:img_num
    name = img_names{k};
    img = imread([img_dir, name]); % original image
    img=uint8(img);
    [h,w,ch] = size(img);
    new_img=uint8(zeros(h,w,ch));
    for c=1:ch
        for i = 1:h
            for j = 1:w
                switch c
                    case {1}
                        new_img(i,j,1)=r(img(i,j,1)+1); %�ֱ�ʹ��r��g��b����ӳ��������ͼ��ƫ�̣�ȫ��ʹ��bӳ���û������ɫ��
                    case {2}
                        new_img(i,j,2)=g(img(i,j,2)+1);
                    case {3}
                        new_img(i,j,3)=b(img(i,j,3)+1);
                end
            end
        end
    end

%     imshow(new_img)
    %%%%%%%%%%%%%%%%%%%%%%%
    [h,w,ch] = size(new_img);
    raw_img=zeros(h,w,ch);
    new_img=uint16(new_img);
    raw_img(:,:,:)=new_img(:,:,:)*255;
    raw_img=uint16(raw_img);
    imwrite(raw_img, [img_savedir, name(1:end-4), '.png'],'png')
%     figure(2)
%     imshow(raw_img)
    if mod(k,100)==0
        fprintf("%.f%% done!\n", 100*k/img_num)
    end    
end