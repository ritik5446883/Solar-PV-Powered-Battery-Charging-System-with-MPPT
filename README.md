# Solar-PV-Powered-Battery-Charging-System-with-MPPT
# ☀️ Solar Battery Charging System using Buck Converter with MPPT (P&O Algorithm)

## 📌 Project Overview
This project presents the **design, simulation, and implementation** of a **solar photovoltaic (PV) battery charging system** using a **Buck Converter** integrated with a **Maximum Power Point Tracking (MPPT)** controller based on the **Perturb and Observe (P&O)** algorithm.

Solar PV systems are inherently affected by **irradiance** and **temperature** variations, leading to fluctuations in output voltage and power. Without MPPT, the PV system may not operate at its **maximum power point (MPP)**, resulting in energy losses.

## 🛠 Key Features
- **Perturb and Observe (P&O) MPPT Algorithm** for efficient MPP tracking
- **Buck Converter** for stepping down PV voltage to match battery charging requirements
- Works with **12V battery systems** (adaptable to other voltages)
- Responds to **real-time changes** in solar irradiance and temperature
- MATLAB function implementation for portability and integration
- Simulink model for visual testing and result analysis
- Maintains **battery safe charging profile** while maximizing PV efficiency

## ⚡ Working Principle

### 1. Solar PV Output Measurement
The PV array's **voltage (V)** and **current (I)** are continuously measured to determine instantaneous power:
\[
P = V \times I
\]

### 2. MPPT Controller – Perturb and Observe Method
The P&O algorithm works as follows:
1. **Perturb**: Slightly change the duty cycle `D` of the Buck Converter
2. **Observe**: Measure the resulting change in PV power (`ΔP`)
3. **Decision**:
   - If `ΔP > 0` → Continue in the same direction (moving toward MPP)
   - If `ΔP < 0` → Reverse the change direction (moving away from MPP)
4. **Repeat Continuously** to adapt to changing conditions

### 3. Buck Converter Voltage Regulation
- The **Buck Converter** steps down the PV voltage to match the battery voltage
- MOSFET switching in the Buck Converter is controlled by the **duty cycle** from the MPPT controller
- Output voltage is smoothed with an LC filter to provide stable charging current

## 🔧 MATLAB MPPT Function (`DutyRatio.m`)
```matlab
function D = DutyRatio(V, I)
    Dmax = 0.95;
    Dmin = 0;
    Dinit = 0.95;
    deltaD = 0.0001;
    persistent Vold Pold Dold;

    if isempty(Vold)
        Vold = 0;
        Pold = 0;
        Dold = Dinit;
    end

    P = V * I;
    dV = V - Vold;
    dP = P - Pold;

    if dP ~= 0
        if dP < 0
            if dV < 0
                D = Dold - deltaD;
            else
                D = Dold + deltaD;
            end
        else
            if dV < 0
                D = Dold + deltaD;
            else
                D = Dold - deltaD;
            end
        end
    else
        D = Dold;
    end

    if D >= Dmax || D <= Dmin
        D = Dold;
    end

    Dold = D;
    Vold = V;
    Pold = P;
end
