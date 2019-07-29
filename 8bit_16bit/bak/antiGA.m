clc,
clear
load('map_ch1.mat');
load('map_ch2.mat');
load('map_ch3.mat');    
idx = (find(~isnan(map_ch1)));
map_ch1 = spline(idx, map_ch1(idx), 1:65536);
idx = (find(~isnan(map_ch2)));
map_ch2 = spline(idx, map_ch2(idx), 1:65536);
idx = (find(~isnan(map_ch3)));
map_ch3 = spline(idx, map_ch3(idx), 1:65536);
r=zeros(1,256);
g=zeros(1,256);
b=zeros(1,256);
for i=1:256
    r(i)=min(find(map_ch1>=i-1))/255;
    g(i)=min(find(map_ch2>=i-1))/255;
    b(i)=min(find(map_ch3>=i-1))/255;
end
r=uint8(r);
g=uint8(g);
b=uint8(b);
save r;
save g;
save b;
%%%%%%%%%%%%%%%%%%%%%%%%%%%5
load('r.mat');
load('g.mat');
load('b.mat');
img = imread('1.png'); % original image
[h,w,ch] = size(img);
new_img=zeros(h,w,ch);
new_img=uint8(new_img);
img=uint8(img);
for c=1:ch
    for i = 1:h
        for j = 1:w
            switch c
                case {1}
                    new_img(i,j,1)=r(img(i,j,1)+1);
                case {2}
                    new_img(i,j,2)=g(img(i,j,2)+1);
                case {3}
                    new_img(i,j,3)=b(img(i,j,3)+1);
            end
        end
    end
end
imshow(new_img)
%%%%%%%%%%%%%%%%%%%%%%%
[h,w,ch] = size(new_img);
raw_img=zeros(h,w,ch);
raw_img(:,:,:)=new_img(:,:,:)*255;
imwrite(raw_img,'raw.ppm')