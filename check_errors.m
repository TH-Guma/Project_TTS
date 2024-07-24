% Hàm kiểm tra lỗi
function res = check_errors(H, current_frame)
    syndrome = H * transpose(current_frame);
    areErrors = any(mod(syndrome,2));
    res = areErrors;
end