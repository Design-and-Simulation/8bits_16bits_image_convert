function img_jpg = ppm2jpg_fst(strPPM, strJPG, dScale)
load('map_ch1.mat');
load('map_ch2.mat');
load('map_ch3.mat');    
% idx = (find(~isnan(map_ch1)));
% mat_ch1 = spline(idx, map_ch1(idx), 1:65536);
% idx = (find(~isnan(map_ch2)));
% map_ch2 = spline(idx, map_ch2(idx), 1:65536);
% idx = (find(~isnan(map_ch3)));
% map_ch3 = spline(idx, map_ch3(idx), 1:65536);

%% input
if ischar(strPPM)
    ppm_test=imread(strPPM);
else
    ppm_test = strPPM;
end

%% transformation
if max(ppm_test(:)) < 256
    img_jpg = uint8(ppm_test);
    return;
end
ppm_test = ppm_test * dScale;
[h,w,c]=size(ppm_test);
img_jpg=zeros(h,w,c);
for ch = 1 : c
    temp=max(ceil(ppm_test(:,:,ch)),1);
    idxZero = find(temp<0);
    idxMax = temp > length(map_ch1);
    temp(idxMax) = length(map_ch1);
    switch ch
        case {1}
            img_jpg(:,:,ch)=round(map_ch1(temp));
        case {2}
            img_jpg(:,:,ch)=round(map_ch2(temp));
        case {3}
            img_jpg(:,:,ch)=round(map_ch3(temp));
    end
end
img_jpg = uint8(img_jpg);
%% output
if ~isempty(strJPG)
    imwrite(uint8(img_jpg),strJPG, 'jpg');
end



