%% Likelihood function
% Sohyeon Park (sohyeop@uci.edu)
% sVal: contourlength, cVal: cos(theta)

function pcEqn = F4_likelihood(sVal,cVal,DthetaVal)

v = 4.5;
maxFourierMode = 50;
sumTerm = 0;

for iTerm = 1:maxFourierMode
    sumTerm = sumTerm + cos(iTerm.*acos(cVal)).*exp(-((iTerm.^2).*sVal.*DthetaVal)./v);
end

pre_pcEqn = (1./(2.*pi) + (1./pi) .* sumTerm) .* (2./(sqrt(1-cVal.^2)));

ind = find(pre_pcEqn<eps);
pre_pcEqn(ind) = eps;
pcEqn = pre_pcEqn;

end