Iclean = double(imread('cameraman.tif'));
[row,col] = size(Iclean);

% imshow(uint8(Iclean))

% Inoisy = imnoise(Iclean,'gaussian',0,15) ;%awgn(Iclean,15);
sigma=20;
Inoisy=Iclean+sigma.*randn(size(Iclean));

% imshow(uint8(Inoisy))
PSNR_Noisy = 10 * log10(row * col * 255^2 / sum(sum((Inoisy - Iclean).^2)) );

L0 = 1/0.001;
lamda = .001;
max_iter = 1000;

Xinit = zeros(row,col);
x_old = Xinit;
y_old = Xinit;
t_old = 1;
iter = 0;

L = L0;

calc_f = @(x) 1/2 * norm(x-Inoisy,'fro')^2;
calc_F = @(x) calc_f(x) + lambda*sum(abs(x(:)));
grad = @(x) (x-Inoisy);
soft = @(x, lamda) sign(x).* max(abs(x)-lamda, 0); %ones(row,col)
Iter = 1:max_iter;
E = zeros(size(Iter));
PSNR = zeros(size(Iter));

for i=1:max_iter
    x_new = soft( y_old - 1/L0 * grad(y_old), lamda/L0);
    t_new = 0.5*(1 + sqrt(1 + 4*t_old^2));
    y_new = x_new + (t_old - 1)/t_new * (x_new - x_old);
    
    E(i) = sum(sum((x_new-Iclean).^2))/(row*col);
    PSNR(i) = 10 * log10(row * col * 255^2 / sum(sum((x_new - Iclean).^2)) );    
        %% update
        x_old = x_new;
        t_old = t_new;
        y_old = y_new;
end

% plot(Iter,E)
% plot(Iter, PSNR)
% subplot(1,2,1), imshow(Iter,E)
% subplot(1,2,2), imshow(Iter,PSNR)
imshow(uint8(x_new))