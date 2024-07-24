
% Hàm Expand
function  x= Expand(y,mu,x_max)
 x = sign(y) .* (x_max * ((exp((abs(y) * log(1 + mu)) / x_max)) - 1) / mu);
end 