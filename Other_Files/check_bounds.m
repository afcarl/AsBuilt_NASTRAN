% find max and min bounds on material properties

v_Tlam1 = vertcat(bdf.CTRIA3(:).tLam);

maxTlam1 = max(v_Tlam1);
minTlam1 = min(v_Tlam1);

maxE1_K13C = polyval(bdf.PCOMP(1).c_K13C(2,:),maxTlam1)
minE1_K13C = polyval(bdf.PCOMP(1).c_K13C(2,:),minTlam1)

maxE1_boron = polyval(bdf.PCOMP(1).c_Boron(2,:),maxTlam1)
minE1_boron = polyval(bdf.PCOMP(1).c_Boron(2,:),minTlam1)