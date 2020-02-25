function [Coeff] = proclpc(data)

% arguments check
if (nargin ~= 1)
   error('argument check failed');
end;

% system constants                                                % sampling rate in Hertz (Hz)
order = 20;                                                % order of the model used by LPC
fl = 512;                                                  % frame length 
fs = 80;                                                  % frame shift

nframe = 0;

data = [zeros(0.5*fl,1); data];
duration = length(data);

for frameIndex = 1:fs:duration-fl+1
    nframe = nframe+1;
    frameData = data(frameIndex:(frameIndex+fl+1));    
    frameData = blackman((frameIndex+fl+1)-frameIndex+1).*frameData;      % Add blackman window
    
    % Levinson's method
    %step1:求线性预测函数方程
    N=length(frameData);%方便R矩阵的计算
    k=zeros(1,order);%生成一个1行20列的0矩阵存储偏相关系数
    a=zeros(order,order);%生成零矩阵存储预测系数
    R=zeros(1,order+1);%自相关系数矩阵。由于将R0纳入，不得不扩充1格
    e=zeros(1,order);
    m=zeros(1,order);  %最后读入的数据
    for j=1:order+1    %语音段Sn自相关函数的求解从R0,R1……到R20
        for n=j:N
            R(j)=R(j)+frameData(n)*frameData(n-j+1);
        end
    end
    k(1)=R(2)/R(1);
    a(1,1)=k(1);
    e(1)=(1-k(1)*k(1))*R(1);
    %step2:基于for循环的递推
    for j=2:order
        temp=0;%辅助ki的计算
        for n=1:j-1
            temp=temp+a(n,j-1)*R(j-n+1);
        end
        k(j)=(R(j+1)-temp)/e(j-1);
        a(j,j)=k(j);
        for n=1:j-1
            a(n,j)=a(n,j-1)-k(j)*a(j-n,j-1);
        end
        e(j)=(1-k(j)*k(j))*e(j-1);
    end
    m=zeros(1,order);
    for x=1:order
        m(x)=-a(x,order);                         %预测系数的计算
    end
    G(nframe) = sqrt(e(order));                   % gain
    G(nframe) = G(nframe)*2620;                   % according experience
    ai(:,nframe) = m;                             % a1,a2,...,a20
%     aCoeff = lpc(frameData, 20);
%     ai(:,nframe) = aCoeff(2:end);
end

C = [G; ai];
Coeff = single(C(:));

