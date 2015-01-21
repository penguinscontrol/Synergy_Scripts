function H = h_mat(c, tau, N, T, T_ep)

H = zeros(N*T,T_ep);
    for ii = 1:N
        H = H+c(ii)*theta_mat(ii, tau(ii), N, T, T_ep);
    end

end