% Hàm compress
function y = Compress_A_Law(x, A, x_max, y_max)
    y = [];
    for i = 1:length(x)
        if abs(x(i)) / x_max <= 1/A
            y1 = y_max * ((A*abs(x(i))/x_max) / (1+log(A))) * sign(x(i));
        else
            y1 = y_max * ((1+log(A*abs(x(i))/x_max)) / (1+log(A))) * sign(x(i));
        end
        y = [y y1];
    end
end
