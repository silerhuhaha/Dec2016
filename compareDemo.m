%Detective of wheat length
clc;
clear all;
close all;

%Set the path to 'read' file
SearchFolder = '.\image\'; %No character allowed in the path
%Set the postfix of the file
SearFlag = '*.JPG';  

%Auto operation
Buffer = dir([SearchFolder SearFlag]); 
%Find number of files
Number = length(Buffer);

total = zeros(1, Number);
for n = 1:Number
    PathName = [SearchFolder Buffer(n).name];
    %Read file
    imgSrc = imread(PathName);
    %Length detective
    [maxLength target] = DetectTargetLength(imgSrc);
    total(1, n) = calcuNumber(target);
end

%Input actul number of spikelet
real = load('real.txt');
real = real';

plot(real,'--rs','LineWidth',2,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',10);
hold on
plot(total,'--ks','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',10)
hold off







  
  
  
  
  