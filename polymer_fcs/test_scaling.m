Ntest = [1:9,10:2:40,45:5:99,100:50:500];
times = zeros(size(Ntest));
tau = logspace(-6,0,300);

for u = 1:length(Ntest),
    N = Ntest(u);
    y = linspace(0,1,N);
    tic; 
    gn = exact_blas_unitynorm(0.1, 0.2, 75, 6, 0.22, 0.75, 17, 0.084, 0.3, 2, y, tau); 
    times(u) = toc;
    fprintf('Completed N==%g in %gs.\n', N, times(u));
end;
plot(Ntest, times);
xlabel('Number of dyes');
ylabel('Execution time');