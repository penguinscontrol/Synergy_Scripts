function theta = theta_mat(ii, tau, N, T, T_ep)
theta = zeros(N*T,T_ep);
for p = 1:N*T
    for q = 1:T_ep
        if p > (ii-1)*T && p < ii*T+1
            theta(p,q) = (p-(ii-1)*T) == (q-tau);
        end
    end
end
end