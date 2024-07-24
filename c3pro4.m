clear all;
clc;
close all;
%Ma trận kiểm tra
H=[1 1 0 1 0 0
0 1 1 0 1 0
1 0 0 0 1 1
0 0 1 1 0 1];

%Từ mã truyền
c = [0 0 1 0 1 1 ]
x = c;
% Từ mã nhận
r = [1 0 1 1 1 1]
y=r;
%Số lần lặp
maxiter=20;
iter=0;

%Đánh dấu giải mã chưa thành công
success = 0;

while iter < maxiter && ~success% Điều kiện vòng lặp
    %Khởi tạo ma trận lỗi
    E=zeros(4,6);
    for j = 1:4
        for i = 1:6
            if (H(j,i)==1)
                %Xác định ma trận lỗi
                E(j, i) = mod(sum(H(j, :) .* y), 2);
            end
        end
    end
    % Tìm vị trí có nhiều lỗi nhất
    for i=1:6
        M(i)=sum(E(:,i));
    end
        [M,index] = max(M);
    if(sum(E)==0)
        disp("không có sai")
    else
        disp(["vị trí sai:",index])
    end
    % Sửa lỗi
    if M~=0
        y(index) = ~y(index);
     
    end
    % Kiểm tra sau khi đảo bit
    areErrorsPresent = check_errors(H, y);
    if areErrorsPresent == false % Không lỗi
        success = 1;
        disp("No error");
        disp("nhan r:")
        disp(y)
 
    else %Có lỗi
        disp("Still errors");
        success = 0;
    end

   iter=iter+1;
end


