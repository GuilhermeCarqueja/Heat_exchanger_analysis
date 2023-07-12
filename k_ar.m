function k_ar = k_ar(temperatura_ar)
  k_ar = -1.1271144710E-14*(temperatura_ar^6) + 3.5848701157E-12*(temperatura_ar^5) - 4.4721137835E-10*(temperatura_ar^4) + 2.7807972146E-08*(temperatura_ar^3) - 9.4237308700E-07*(temperatura_ar^2) + 9.0990901044E-05*temperatura_ar + 2.4266429288E-02;
end