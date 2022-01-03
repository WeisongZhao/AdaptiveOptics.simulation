## Simulation for sensorless adaptive optics (Confocal microscopy, Modal method)
## Introduction
### The simulation generates the aberrated PSF on the pupil with Zernike polynomial 5-22 orders, and corrects them with different methods: 
1. GA (Genetic Algorithm). **1000+measurements**
2. Modal method. **350+measurements**
3. SPGD (Stochastic Parallel Gradient  Descent). **250+measurements**
4. Optimal Modal method. **150+measurements**


### All the methods follow the basic direction---> Estimate the Zernike polynomial coefficients based on images with some of measurements.

A comparison of different metrics for the Modal sensor (the steeper the curve, the better the metric).
- M1: Variance (aberration.m);
- M2: Sharpness (aberration2.m);
- M3: Gradient (aberration3.m);
- M4: Summation (aberration4.m);.
<br><br><br><br><br>
<p>
<img src='./img/Comparison of different metrics.png' align="right" width=400>
</p>

## Attention
This repo. is made just for self using. It may have bugs or trouble. You can contact me with a github issue.

If you find it useful, please cite our work:

[Liu, J., Zhao, W., Liu, C., Kong, C., Zhao, Y., Ding, X., & Tan, J. (2019). Accurate aberration correction in confocal microscopy based on modal sensorless method. Review of Scientific Instruments, 90(5), 053703.](https://aip.scitation.org/doi/abs/10.1063/1.5088102)