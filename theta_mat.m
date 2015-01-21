function theta = theta_mat(ii, tau, N, T, T_ep)
theta = zeros(N*T,T_ep);
for p = 1:N*T
    for q = 1:T_ep
       theta(p,q) = (p-(ii-1)*T) == (q-tau);
    end 
end
end