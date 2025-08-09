# Solar-PV-Powered-Battery-Charging-System-with-MPPT

## Overview
Photovoltaic power generation systems implement an effective utilization of solar energy, but have very low conversion efficiency. The major problem in solar photovoltaic systems is to maintain the DC output power from the panel as constant. Irradiation and temperature are the two factors which will change the output power of the panel. In this article, it is shown that for charging lead-acid batteries from solar panels, MPPT can be achieved by the Perturb and Observe (P&O) algorithm. MPPT is used in photovoltaic systems to regulate the photovoltaic array output. A buck converter is utilized as a DC-DC converter for the charge controller. It is used to match the impedance of the solar panel and battery to deliver maximum power. Voltage and current from the solar panel are sensed and the duty cycle of the gating signal is varied accordingly by the algorithm to attain maximum power transfer. It is obtained by using MATLAB Simulink Model.



---

## 1. Introduction
Renewable energy sources have gained significant attention as the global community faces challenges related to climate change, depleting fossil fuels, and energy security. Among these, solar energy stands out as a clean, abundant, and sustainable energy source. Harnessing solar energy reduces carbon emissions, mitigates environmental degradation, and promotes sustainable development.

Solar energy has the potential to meet a substantial portion of global energy demands. Photovoltaic (PV) technology, which converts sunlight directly into electricity, is at the forefront of solar energy applications. PV systems are particularly advantageous for standalone and remote applications, providing a reliable and renewable alternative to conventional energy sources. However, optimizing the efficiency of solar energy systems remains a key challenge.

The integration of solar panels with battery storage systems ensures a continuous and reliable power supply. Batteries store excess energy generated during peak sunlight hours and release it when solar power is insufficient. However, solar panels and batteries operate at varying voltages, requiring efficient power electronics to regulate and manage energy transfer. DC-DC converters, such as buck converters, play a crucial role in stepping down voltage levels to match battery requirements. Additionally, Maximum Power Point Tracking (MPPT) algorithms are essential for maximizing the energy extracted from solar panels under varying environmental conditions.

---

## 2. Solar Photovoltaic Systems
Solar photovoltaic (PV) systems convert sunlight directly into electrical energy using semiconductor materials that exhibit the photovoltaic effect. They are used in off-grid and grid-connected applications, such as residential power systems, solar farms, electric vehicles, and battery charging stations.

### 2.1 Photovoltaic Effect
When sunlight strikes a PV cell, it is absorbed by the semiconductor material (typically silicon). The energy from the sunlight excites electrons, causing them to break free from their atoms. This creates electron-hole pairs, where the electron is negatively charged and the hole is positively charged. The electric field within the PV cell drives the electrons toward the external circuit, generating current. The amount of electricity produced depends on sunlight intensity and the PV cell’s efficiency.

---

## 3. Battery Management Systems
Battery charging is an essential part of solar systems for energy storage. Battery type, charging techniques, and management systems affect performance and lifespan.

### 3.1 Battery Types for Solar Systems
- **Lead-Acid:** Low cost, short lifespan, sensitive to deep discharge.
- **Lithium-Ion:** High efficiency, long lifespan, tolerant to deep discharge.
- **Nickel-Metal Hydride (NiMH):** Moderate efficiency and cost.

### 3.2 Charge/Discharge Cycles
Cycle life refers to the number of complete charge-discharge cycles a battery can undergo before its capacity drops significantly. Depth of discharge (DoD) directly impacts cycle life.

### 3.3 Charging Techniques
- **Constant Current (CC):** Battery charged at fixed current until voltage reaches a set limit.
- **Constant Voltage (CV):** Voltage kept constant, current decreases as the battery reaches full charge.

---

## 🛠 Key Features
- **Perturb and Observe (P&O) MPPT Algorithm** for efficient MPP tracking.
- **Buck Converter** for stepping down PV voltage to match battery charging requirements.
- Works with **12V battery systems** (adaptable to other voltages).
- Responds to **real-time changes** in solar irradiance and temperature.
- MATLAB function implementation for portability and integration.
- Simulink model for visual testing and result analysis.
- Maintains **battery safe charging profile** while maximizing PV efficiency.

---

## ⚡ Working Principle

### 1. Solar PV Output Measurement
The PV array's **voltage (V)** and **current (I)** are continuously measured to determine instantaneous power:
\[
P = V \times I
\]

### 2. MPPT Controller – Perturb and Observe Method
The P&O algorithm works as follows:
1. **Perturb**: Slightly change the duty cycle `D` of the Buck Converter.
2. **Observe**: Measure the resulting change in PV power (`ΔP`).
3. **Decision**:
   - If `ΔP > 0` → Continue in the same direction (moving toward MPP).
   - If `ΔP < 0` → Reverse the change direction (moving away from MPP).
4. **Repeat Continuously** to adapt to changing conditions.

### 3. Buck Converter Voltage Regulation
- The **Buck Converter** steps down the PV voltage to match the battery voltage.
- MOSFET switching in the Buck Converter is controlled by the **duty cycle** from the MPPT controller.
- Output voltage is smoothed with an LC filter to provide stable charging current.

---

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
