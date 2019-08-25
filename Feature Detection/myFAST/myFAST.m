%this class is to realize FAST feature extractor
classdef myFAST
    properties
        numInChain = 12;
        threshold = 0.3;
        img;
        featureMap;
    end
    
    methods
        function obj = myFAST(img_)
            if ndims(img_) == 3
                obj.img = rgb2gray(img_);
            else
                obj.img = img_;
            end
        end
        
        % FAST��ʵ��
        function [corners] = operate(obj)
            corners = []; % ������
            tempCorners = []; 
            [m, n] = size(obj.img);
            obj.featureMap = zeros(m, n); %������ķ�ֵ�����������������Ϊ0
            for i = 4:m-4
                for j = 4:n-4
                    % p0Ϊ����
                    p0 = obj.img(i,j);
                    % ������ȡ��ǰ��뾶Ϊ3��BresenhamԲԲ���ϵĵ㣬�������Ϸ�Ϊp��1��
                    p = [];
                    p(end + 1) = obj.img(i - 3 ,j    );  %p1
                    p(end + 1) = obj.img(i - 3 ,j + 1);  %p2
                    p(end + 1) = obj.img(i - 2 ,j + 2);  %p3
                    p(end + 1) = obj.img(i - 1 ,j + 3);  %p4
                    p(end + 1) = obj.img(i     ,j + 3);  %p5
                    p(end + 1) = obj.img(i + 1 ,j + 3);  %p6
                    p(end + 1) = obj.img(i + 2 ,j + 2);  %p7
                    p(end + 1) = obj.img(i + 3 ,j + 1);  %p8
                    p(end + 1) = obj.img(i + 3 ,j    );  %p9
                    p(end + 1) = obj.img(i + 3 ,j - 1);  %p10
                    p(end + 1) = obj.img(i + 2 ,j - 2);  %p11
                    p(end + 1) = obj.img(i + 1 ,j - 3);  %p12
                    p(end + 1) = obj.img(i     ,j - 3);  %p13
                    p(end + 1) = obj.img(i - 1 ,j - 3);  %p14
                    p(end + 1) = obj.img(i - 2 ,j - 2);  %p15
                    p(end + 1) = obj.img(i - 3 ,j - 1);  %p16
                    thr = obj.threshold*p0;
                    
                    %�жϸõ��Ƿ�Ϊ�������candidate
                    %featureFlag = 1 ������Χ��n�����ϵĵ����p0 + thr
                    %featureFlag = 2 ������Χ��n�����ϵĵ�С��p0 - thr
                    featureFlag = FastFeaturePointDetect(p0,p,thr,obj.numInChain);
                    if featureFlag == 1 || featureFlag == 2  
                        %����������㣬����������ķ�ֵ
                        val = ExtremeSuppression(p0,p,thr, obj.numInChain,featureFlag);
                        tempCorners(end + 1).x = j;
                        tempCorners(end).y = i;
                        tempCorners(end).val = val;
                        obj.featureMap(i,j) = val;
                    end
                end
            end
            
            %��ֵ������
            for k = 1:length(tempCorners)
                j = tempCorners(k).x;
                i = tempCorners(k).y;
                tempList(1) = obj.featureMap(i - 1,j - 1);
                tempList(2) = obj.featureMap(i - 1,j    );
                tempList(3) = obj.featureMap(i - 1,j + 1);
                tempList(4) = obj.featureMap(i    ,j - 1);
                tempList(5) = obj.featureMap(i    ,j + 1);
                tempList(6) = obj.featureMap(i - 1,j - 1);
                tempList(7) = obj.featureMap(i - 1,j    );
                tempList(8) = obj.featureMap(i - 1,j + 1);
                %���������Ĵ��ֵ�Ǹ���3*3������������tempCorners��k������corners
                if tempCorners(k).val > max(tempList)
                    corners(end+1).x = tempCorners(k).x;
                    corners(end).y = tempCorners(k).y;
                    corners(end).val = tempCorners(k).val;
                end
            end
        end
    end
end

%�жϸõ��Ƿ�Ϊ�������candidate
function flag = FastFeaturePointDetect(p0,p,thr, numInChain)
flag = 0;
% ����16���㣬���Ƿ���numInChain�������p0 + thr
% ѭ���б��index = mod(k-1,length(p))+1
for i = 1:16
    if p(i) - p0 > thr
        counter = 1;
        for j = 1:numInChain - 1
            k = i + j;
            if p(mod(k-1,length(p))+1) - p0 > thr
                counter = counter + 1;
            else
                break;
            end
        end
        if counter == numInChain
            flag = 1;
            return
        end
    else
        continue;
    end
end

% ����16���㣬���Ƿ���numInChain����С��p0 - thr
for i = 1:16
    if p0 - p(i) > thr
        counter = 1;
        for j = 1:numInChain - 1
            k = i + j;
            if  p0 - p(mod(k-1,length(p))+1) > thr
                counter = counter + 1;
            else
                break;
            end
        end
        if counter == numInChain
            flag = 2;
            return
        end
    else
        continue;
    end
end

end

%����������
function [val] = ExtremeSuppression(p0, p,thr, numInChain,featureFlag)
N = length(p);
if featureFlag == 1
    d = p - double(p0);
else
    d = double(p0) - p;
end
    a0 = thr;
    
    %��ֵĽ��һ����d��1����d(16)�е�һ��������16���ҳ���������������d(k)
    for i = 1:16
        a = min([d(mod(i,N)+1),d(mod(i+1,N)+1),d(mod(i+2,N)+1)]);        
        if a < a0
            continue;        
        end        
        for j = 4:numInChain-1
            a = min(a,d(mod(i+j-1,N)+1));
        end
        
        a0 = max(a0,min(a, d(mod(i-1,N)+1) ));
        a0 = max(a0, min(a, d(mod(i-1,N)+1) ));
    end

    
val = a0 -1;
end


