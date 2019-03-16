## Simulation for sensorless adaptive optics (Confocal microscopy, Modal method)
## Introduction
### The simulation generates the aberrated PSF on the pupil with Zernike polynomial 5-22 orders, and corrects them with different methods: 
1. GA (Genetic Algorithm). **1000+measurements**
2. Modal method. **350+measurements**
3. SPGD (Stochastic Parallel Gradient  Descent). **250+measurements**
4. Optimal Modal method. **150+measurements**


### All the methods follow the basic direction---> Estimate the Zernike polynomial coefficients based on images with some of measurements.