function [cf, gof] = modelMPG(carData, CarTruck, CityHighway, CI)
% modelKm_gal(carData, CARTRUCK, CITYHIGHWAY, CI)
%
%   carData      : car data (table object)
%   CARTRUCK     : 'car' or 'truck' or 'all'
%   CITYHIGHWAY  : 'city' or 'highway' or 'all'
%   CI (optional): Confidence Interval (default: 95)

% Copyright 2017 The MathWorks, Inc.

if nargin == 3 % CI not provided
    CI = 95;
end


%% Filter out data
if strcmpi(CarTruck, 'all')
    idx1 = true(size(carData.Km_gal));
else
    idx1 = carData.Car_Truck == CarTruck;
end
if strcmpi(CityHighway, 'all')
    idx2 = true(size(carData.Km_gal));
else
    idx2 = carData.City_Highway == CityHighway;
end
idx = idx1 & idx2;
iData = carData.RatedHP(idx);
dData = carData.Km_gal(idx);


%% Curve Fitting
%
% Equation:
%    Km_gal = b1 + b2 * 1/RatedHP

[cf, gof] = createMPGFit(iData, dData);


%% Plot
hh = plot(cf, 'r', iData, dData, 'predobs', CI*0.01);
xlabel('Rated Horsepower')
ylabel('Km_gal')
title([CarTruck ' - ' CityHighway]);
if CarTruck == "car"
    str1 = "autos";
else
    str1 = "camionetas";
end

if CityHighway == "city"
    str2 = "ciudad";
else
    str2 = "autopista";
end
strf = strcat("Eficiencia de combustible para ",str1," en ",str2);
title(strf)
grid on
xlim([min(iData) max(iData)])
ylim([min(dData) max(dData)])
legend(["Datos" "Curva ajustada" strcat("Intervalo de confianza del ",num2str(CI),"%")])

end