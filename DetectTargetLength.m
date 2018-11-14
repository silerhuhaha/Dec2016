function [Length, target] = DetectTargetLength( ImageSrc )


%Match color
[h w channels] = size(ImageSrc);
ColorProbility = zeros(h, w);
doubleSrc = double(ImageSrc);
for r = 1:h
    for c = 1: w
        subR = 255.0 - doubleSrc(r, c, 1);
        subG = 255.0 - doubleSrc(r, c, 2);
        subB = 0.0 - doubleSrc(r, c, 3);
        ColorProbility(r, c) = (subR * subR + subB * subB + subG * subG)^0.5;
    end
end

%Mapminmax
pMax = max(max(ColorProbility));
pMin = min(min(ColorProbility));
step = 255.0 / (pMax - pMin);
normal = uint8(zeros(h, w));
for r = 1:h
    for c = 1: w
        normal(r, c) = 255 - (ColorProbility(r, c)  - pMin) * step;
    end
end
 imgBW = im2bw(normal, 0.75);

%Image dilate
SE2 = strel('diamond', 7);
imgBW=imdilate(imgBW,SE2,'same'); %dilate

%Find max connect region
imgLable = bwlabel(imgBW);
stats = regionprops(imgLable);
Ar = cat(1, stats.Area);  
ind = find(Ar ==max(Ar));%Label found max region  
imgBW(find(imgLable~=ind))=0;%Set other regions to 0  

%Min bounding rectangle calculation
[r, c] = find(imgBW == 1);
[rectx,recty,area,perimeter] = minboundrect(c,r,'a'); % 'a' is min area rectangle, if the length of side is 'p'

%%%%Cut spikelet image, for later calculation
boundingtRect = stats(ind). BoundingBox;
left = int32(boundingtRect(1));
top = int32(boundingtRect(2));
right = left + int32(boundingtRect(3));
bottom = top + int32(boundingtRect(4));
if left <= 0
    left = 1;
end
if top <= 0
    top = 1;
end
if bottom > h
    bottom = h;
end
if right > w
    right = w;
end 

target = ImageSrc(top:bottom, left:right,:);

%length calculation
pixTargetLength = -1.0;%length of wheat
Width = distance(rectx(1,1), rectx(2,1), recty(1, 1), recty(2, 1) );
Height = distance(rectx(1,1), rectx(4,1), recty(1, 1), recty(4, 1) );
if Width > Height
    pixTargetLength = Width;
else
    pixTargetLength = Height;
end

%%%%Following part is calculation for label length
%Match color White
for r = 1:h
    for c = 1: w
        subR = 255.0 - doubleSrc(r, c, 1);
        subG = 255.0 - doubleSrc(r, c, 2);
        subB = 255.0 - doubleSrc(r, c, 3);
        ColorProbility(r, c) = (subR * subR + subB * subB + subG * subG)^0.5;
    end
end
%Image dilate
pMax = max(max(ColorProbility));
pMin = min(min(ColorProbility));
step = 255.0 / (pMax - pMin);
normal = uint8(zeros(h, w));
for r = 1:h
    for c = 1: w
        normal(r, c) = 255 - (ColorProbility(r, c)  - pMin) * step;
    end
end
 imgBW = im2bw(normal, 0.8);
 
  imgLable = bwlabel(imgBW);
 stats = regionprops(imgLable);
Ar = cat(1, stats.Area);  
ind = find(Ar ==max(Ar));%Find max connect region's label 
imgBW(find(imgLable~=ind))=0;%Set other regions to 0

%Min rectangle calculation
[r, c] = find(imgBW == 1);
[Lrectx,Lrecty,area,perimeter] = minboundrect(c,r,'a'); % 'a'是按面积算的最小矩形，如果按边长用'p'。

labeLength = -1.0;%Length of label
Width = distance(Lrectx(1,1), Lrectx(2,1), Lrecty(1, 1), Lrecty(2, 1) );
Height = distance(Lrectx(1,1), Lrectx(4,1), Lrecty(1, 1), Lrecty(4, 1) );
if Width > Height
    labeLength = Width;
else
    labeLength = Height;
end

%%%%%Actul wheat length calculation%%%%%%%%%%%
factor = 5.0 / labeLength;
 Length = factor * pixTargetLength;

 
 

end

