function sudoku = diag()
sudoku = zeros(9);
y = 10;
for x = 1:9
    y = y - 1;
    sudoku(x,y) = y;
end
end
    