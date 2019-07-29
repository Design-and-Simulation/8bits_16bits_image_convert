%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16bitת8bit ����
% ������
%   img_dir����ת����16λͼ��·��
%   img_savedir��ת����ɺ��8λͼ�񱣴�·��
% �޸ģ�
%   zzh 20190729
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ��ʼ������
clc
clear

%% ��������
img_dir = '..\test_data\16bit_data\'; %ԭͼ�ļ���
img_savedir = '..\test_data\8bit_data_2\'; %�����ļ���

%% ����ӳ���
load('map_ch1.mat');
load('map_ch2.mat');
load('map_ch3.mat');
idx = (find(~isnan(map_ch1)));
map_ch1 = spline(idx, map_ch1(idx), 1:65536);
idx = (find(~isnan(map_ch2)));
map_ch2 = spline(idx, map_ch2(idx), 1:65536);
idx = (find(~isnan(map_ch3)));
map_ch3 = spline(idx, map_ch3(idx), 1:65536);


%% ͼ����
img_list = dir([img_dir, '*.png']); %ԭͼ�ļ���ʽ .png��ʽ
img_names = {img_list.name};
img_num = length(img_names);

for k = 1:img_num
    strImgFilename = img_names{k};
    ppm_test = imread([img_dir, strImgFilename]); % original image
    [h,w,c]=size(ppm_test);
    img_jpg=zeros(h,w,c);
    for i=1:h
        for j=1:w
            for ch = 1 : c
                temp=ppm_test(i,j,ch);
                switch ch
                    case {1}
                        if(temp==0)
                            img_jpg(i,j,ch)=0;
                        else
                            img_jpg(i,j,ch)=round(map_ch1(temp));
                        end
                    case {2}
                        if(temp==0)
                            img_jpg(i,j,ch)=0;
                        else
                            img_jpg(i,j,ch)=round(map_ch2(temp));
                        end
                    case {3}
                        if(temp==0)
                            img_jpg(i,j,ch)=0;
                        else
                            img_jpg(i,j,ch)=round(map_ch3(temp));
                        end
                end
            end
        end
    end
    img_jpg = uint8(img_jpg);
    imwrite(img_jpg, [img_savedir, strImgFilename(1:end-4), '.png'],'png')
%     figure(2)
%     imshow(raw_img)
    if mod(k,100)==0
        fprintf("%.f%% done!\n", 100*k/img_num)
    end 
end



