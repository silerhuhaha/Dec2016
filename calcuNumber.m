function total = calcuNumber( targetROI )
%spikelet calculation

%Image gray
gray = rgb2gray(targetROI);
%Auto gray thresh setting
level = graythresh(gray);
BW = im2bw(gray,level);
%Morphology functional calculation
SE = strel('diamond', 3);
BW=imopen(BW,SE);
%Find max region
imgLable = bwlabel(BW);
stats = regionprops(imgLable);
Ar = cat(1, stats.Area);  
ind = find(Ar ==max(Ar));%Label the found max region 
BW(find(imgLable~=ind))=0;%Set other regions to 0  

%Rotating angle calculation
[r, c] = find(BW == 1);
[rectx,recty,area,perimeter] = minboundrect(c,r,'a'); % 'a'是按面积算的最小矩形，如果按边长用'p'。
[r, c] = size(rectx);
%Find max length of side
first = 0;
sec = 0;
dMax = -1;
for i = 1: r - 2
    dis = distance(rectx(i,1), rectx(i + 1,1), recty(i, 1), recty(i + 1, 1) );
    if dis > dMax
        dMax = dis;
        first = i;
        sec = i + 1;
    end
end

%Rotating angle calculation
dFX = rectx(first,1) - rectx(sec, 1);
dFY = recty(first, 1) - recty(sec, 1);
dSX =  - 1;
dSY = 0;
dInside = dFX * dSX + dFY * dSY;
dModeF = (dFX * dFX  + dFY * dFY)^0.5;
dModeS = (dSX * dSX  + dSY * dSY)^0.5;
dAngle = acos(dInside / (dModeF * dModeS)) * 180 / pi;

%Move the target to center of image
boundingtRect = stats(ind). BoundingBox;
left = int32(boundingtRect(1));
top = int32(boundingtRect(2));
right = left + int32(boundingtRect(3));
bottom = top + int32(boundingtRect(4));
[h w] = size(BW);
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

%Image revise
 target = BW(top:bottom, left:right,:);
 target = imrotate(target, dAngle);

%Projection
project = sum(target);
 
%Find extreme value
nWin = 10;
[h w] = size(project);
total = 0;
for i = nWin : w - nWin
    
    if project(1, i) < 5
        continue;
    end
    
    isPeek = 1;
    %left
    for j = i - nWin + 1 : i - 1
        if project(1, j) > project(1, i)
            isPeek = 0;
        end
    end
    %right
    for j = i + 1: i + nWin - 1
         if project(1, j) > project(1, i)
            isPeek = 0;
        end
    end
    
    if isPeek == 1
%plot(i, project(i), 'r*');
        total = total + 1;
    end
end


end

