function x_new = fista(imgNoisy, param)  

%--------------------------------------------------------------------------
% fista     : computes FISTA output of Noisy image;
%
% ------------------ OUTPUT ----------------------------------------
% x_new     : FISTA denoised image 
%
%------------------ INPUT -----------------------------------------
% imgNoisy : Noisy image.
% sigma    : Square-root of the additive gaussian noise variance
% param    : Parameters of FISTA
%
%--------------------------------------------------------------------------

[row, col] = size(img);

L0 = param.L0;
lamda = param.lamda;
itr_max = param.itr_max;

Xinit = zeros(row, col);
x_old = Xinit;
y_old = Xinit;
t_old = 1;
iter = 0;

L = L0;

calc_f = @(x) 1/2 * norm(x - imgNoisy, 'fro')^2;
calc_F = @(x) calc_f(x) + lambda * sum(abs(x(:)));
grad = @(x) (x - imgNoisy);
soft = @(x, lamda) sign(x) .* max(abs(x) - lamda, 0); %ones(row, col)
Iter = 1:itr_max;

for i = 1:itr_max
    x_new = soft( y_old - 1/L0 * grad(y_old), lamda/L0);
    t_new = 0.5*(1 + sqrt(1 + 4*t_old^2));
    y_new = x_new + (t_old - 1)/t_new * (x_new - x_old);
    
    %% update
    x_old = x_new;
    t_old = t_new;
    y_old = y_new;
end

end
