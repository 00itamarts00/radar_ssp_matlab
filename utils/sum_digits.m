% This program does not require any inbuilt functions.
function x = sum_digits(n)
x=0;
if n>0
    x=mod(n,10)+sum_digits(floor(n./10));%recursive
end


