# Crazyflie Cyclic Pursuit Experiments

This repository contains notebooks and utility scripts used at **MURO LAB** to study cyclic pursuit control with Crazyflie 2.1 quadcopters. The code explores how a swarm of robots can converge to and maintain circular formations while tracking a moving centroid.

## Repository layout

- `isaac_ws/cyclic.ipynb` - main simulation notebook demonstrating the cyclic pursuit controller and visualizing the results.
- `isaac_ws/tuning_params.ipynb` - helper notebook for exploring controller parameters.
- `isaac_ws/moving_centroid.gif` - example animation of the controller in action.
- `wsl2-tutorial.md` - guide for connecting the Crazyradio to WSL2 environments.

## Running the simulation

1. Install Python 3 along with `numpy`, `scipy`, `matplotlib`, `pandas` and `tqdm`.
2. Launch Jupyter Lab or Notebook in the repository directory:
   ```bash
   jupyter lab
   ```
3. Open `isaac_ws/cyclic.ipynb` and run each cell to simulate the pursuit behaviour. The notebook contains comments explaining how the parameters influence the motion.

## Hardware notes

To run experiments on real Crazyflie drones from Windows, follow the steps in **wsl2-tutorial.md**. It explains how to share the Crazyradio USB device with WSL2 using `usbipd`.

## Reference

The control strategy implemented here is described in [Collective circular motion of multi-vehicle systems](https://www.sciencedirect.com/science/article/pii/S0005109808002951).

---
Author: Sudhanshu Shankar & Isaac Lin
