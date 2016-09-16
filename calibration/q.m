function output = q(i)
%Q returns Q corrected by encoder and calibraiton offsets.

global jointOffset encoder calibration

output = jointOffset(i + 1) + encoder(i + 1) + calibration(i + 1);

end

