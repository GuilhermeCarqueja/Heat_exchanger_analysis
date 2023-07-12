function mu_ar = mu_ar(temperatura_ar)
  mu_ar = -3.5679992981E-17*(temperatura_ar) + 1.1747476150E-14*(temperatura_ar^5) - 1.5016377303E-12*(temperatura_ar^4) + 9.3724833872E-11*(temperatura_ar^3) - 2.9686287481E-09*(temperatura_ar^2) + 9.2284213743E-08*temperatura_ar + 1.7004612988E-05;
end