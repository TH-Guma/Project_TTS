function x = Expand_A_Law(y, A, x_max, y_max)
    x = [];
    for i = 1:length(y)
        if abs(y(i)) / y_max <= 1 / (1+log(A))
            x1 = abs(y(i)) * x_max / (A*y_max) * (1+log(A)) * sign(y(i));
        else
            x1 = x_max / A * exp(abs(y(i)) / y_max * (1+log(A)) - 1) * sign(y(i));
        end
        x = [x x1];
    end
end