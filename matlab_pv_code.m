function D = DutyRatio(V, I)
% DutyRatio - Perturb and Observe MPPT Algorithm
% Computes updated duty cycle for a DC-DC converter 
% using PV voltage (V) and current (I) measurements.
%
% Inputs:
%   V - Instantaneous PV voltage (Volts)
%   I - Instantaneous PV current (Amps)
% Output:
%   D - Updated duty cycle (0 to 1)

    % ==== PARAMETERS ====
    Dmin   = 0.0;       % Minimum allowed duty cycle
    Dmax   = 0.95;      % Maximum allowed duty cycle
    Dinit  = 0.5;       % Initial duty cycle (mid-range is safer)
    baseDelta = 0.002;  % Base perturbation step size
    Ptol   = 1e-4;      % Deadband for power change (noise immunity)

    % ==== PERSISTENT VARIABLES ====
    persistent Vold Pold Dold initialized;
    if isempty(initialized)
        Vold = V;           % Initialize with measured voltage
        Pold = V * I;       % Initialize with measured power
        Dold = Dinit;       % Start at mid duty range
        initialized = true;
    end

    % ==== CALCULATIONS ====
    P  = V * I;             % Instantaneous power
    dV = V - Vold;          % Voltage change
    dP = P - Pold;          % Power change

    % ==== MPPT DECISION LOGIC (Perturb & Observe) ====
    if abs(dP) <= Ptol
        % Power change is too small -> ignore (within noise band)
        D = Dold;
    else
        % Adaptive step size (bigger when far from MPP)
        deltaD = baseDelta * (1 + min(10, abs(dP) / max(abs(P), 1e-6)));

        if dP > 0
            % Power increased -> keep same perturb direction
            if dV > 0
                D = Dold + deltaD; % Increasing V increased P -> keep going
            else
                D = Dold - deltaD; % Decreasing V increased P -> keep going
            end
        else
            % Power decreased -> reverse perturb direction
            if dV > 0
                D = Dold - deltaD; % Increasing V decreased P -> reverse
            else
                D = Dold + deltaD; % Decreasing V decreased P -> reverse
            end
        end
    end

    % ==== LIMIT DUTY CYCLE ====
    D = min(max(D, Dmin), Dmax); % Clamp between Dmin and Dmax

    % ==== UPDATE PERSISTENT VALUES ====
    Vold = V;
    Pold = P;
    Dold = D;
end
