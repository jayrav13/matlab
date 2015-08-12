function x_adj = scrambler_training()
original = [1,1;1,2;2,1;2,2];
[r c] = size(original);
y = randperm(r);
x_adj = zeros(r,c);
for z = 1:r
   x_adj(z,:) =  original(y(z),:);
end
