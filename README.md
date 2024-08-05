# Spatial Temporal Analysis of COVID Data (ST_Covid)

## Table of Contents
- [Project Overview](#project-overview)
- [Nimble Codes](#nimble-codes)
- [Tracking of Model Selection](#tracking-of-model-selection)
- [Reports](#reports)

## Project Overview

This project focuses on spatial temporal analysis of COVID-19 data. We have developed a series of basic models to illustrate the differences in their assumptions and outcomes.  

### Starting Models 
The basic models (*Model 0 and Model 1*) operate under the assumption that the high-level mean at time point $j$ is the sum of total $M$ low-level means: 

$$\mu_j^H = \sum_{i=1}^{M} \mu_{i,j}^L$$

The other models estimate the high-level mean at time point $j$ through regression of covariates. Below is an example with lagged time effects: 

$$\mu_j^H = f(Ycase_{j}^H, Ycumulate_{j}^H, \mu_{j-1}^H)$$

We now give more details of 4 starting models, and below we will provide a more comprehensive table of candidate models for selection.

| Model | Features |
|-------|:--------:|
| m0 | No regression for high-level; No lagged time effects as covariates; No cross-level random effects |
| m1 | No regression for high-level; No lagged time effects as covariates; Cross-level random effects |
| m2 | Regression for high-level; Lagged time effects as covariates; Cross-level random effects | 
| m3 | Regression for high-level; Lagged time effects only in high-level ${}^*$; Cross-level random effects | 

${}^*$ Model 3 turns out to be a simpler version of Model 2.

## Nimble Codes

Please see the model codes in [models_raw.R](https://github.com/Sijianf/ST_Covid/blob/main/codes/models_raw.R).  

## Tracking of Model Selection

### High Models
- **H0**: Sum Only
- **H0a**: Sum + Shared Temporal Random Effect
- **H1**: Current Case Count + Shared Temporal Random Effect
- **H2**: H1 + Lagged Death Count
- **H3**: H1 + Cumulative Case
- **H4**: H1 + Lagged Death Count + Cumulative Case
- **H5**: H4 + Spatial Effects and Additional Model Components

### Low Models
- **L1**: Current Case + Spatial Random Effect + Temporal Random Effect
- **L2**: L1 + Lagged Death Count
- **L3**: L1 + Cumulative Case
- **L4**: L1 + Lagged Death Count + Cumulative Case
- **L5**: L4 + Spatial-Temporal Random Effect
- **L6**: L1 + Spatial Convolution
- **L7**: L5 + Spatial Convolution

### 7 by 7 Tracking Table

|         |  **H0**  |  **H0a** |  **H1**  |  **H2**  |  **H3**  |  **H4**  |  **H5**  |
|:-------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
| **L1**  |    m0    |    m1    |          |    m4    |          |    m3    |          |
| **L2**  |          |    m7    |          |    m5    |          |          |          |
| **L3**  |          |          |          |          |          |          |          |
| **L4**  |          |    m8    |          |          |          |    m2    |          |
| **L5**  |          |          |          |          |          |          |          |
| **L6**  |          |          |          |          |          |          |          |
| **L7**  |          |    m9    |          |    m6    |          |          |          |

## Reports


| Model |  DIC H  |   DIC L  |  DIC3 H  |  DIC3 L  |  PWAIC H |  PWAIC L |  WAIC H  |  WAIC L  |
|:-----:|:-------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|  m0   | 12343.3 |  33821.3 | 12406.3  | 33901.4  |  92.9    |  162.9   | 12411.1  | 33906.4  |
|  m1   | 1343.4  |  22794.8 | 1218.3   | 22823.8  |  63.4    |  196.0   | 1258.2   | 22835.7  |
|  m2   | 1157.7  |  21999.7 | 1122.3   | 22064.8  |  26.1    |  188.0   | 1135.5   | 22077.4  |
|  m3   | 1143.4  |  22540.9 | 1113.0   | 22638.5  |  23.2    |  203.9   | 1124.2   | 22650.4  |
|  m4   | 1142.4  |  22542.2 | 1112.6   | 22638.6  |  23.1    |  204.4   | 1124.1   | 22652.1  |
|  m5   | 1158.9  |  22013.5 | 1122.7   | 22086.2  |  26.3    |  186.5   | 1136.0   | 22098.6  |
|  m6   | 1377.0  |  24161.2 | 1243.4   | 21366.1  |  89.0    |  1525.3  | 1310.7   | 22091.6  |
|  m7   |    -    |     -    |    -     |     -    |     -    |     -    |     -    |     -    |
|  m8   |    -    |     -    |    -     |     -    |     -    |     -    |     -    |     -    |
|  m9   |    -    |     -    |    -     |     -    |     -    |     -    |     -    |     -    |
%|  m7   |    -    |     -    |    -     |     -    |     -    |     -    |     -    |     -    |

Please see the detailed convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m3.html)
- [Model 4](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m4.html)
- [Model 5](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m5.html)
- [Model 6](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m6.html)
- [Model 7]: running
- [Model 8]: running
- [Model 9]: running







