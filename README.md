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
| **L2**  |          |          |          |    m5    |          |          |          |
| **L3**  |          |          |          |          |          |          |          |
| **L4**  |          |          |          |          |          |    m2    |          |
| **L5**  |          |          |          |          |          |          |          |
| **L6**  |          |          |          |          |          |          |          |
| **L7**  |          |          |          |    m6    |          |          |          |

## Reports


| Model |  DIC H  |   DIC L  |  DIC3 H  |  DIC3 L  |  PWAIC H |  PWAIC L |  WAIC H  |  WAIC L  |
|:-----:|:-------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|  m0   | 12344.0 |  12396.5 | 12398.4  | 33900.0  |  86.6    |  161.9   | 12060.5  | 33256.5  |
|  m1   | 1339.1  |  1329.1  | 1218.7   | 22821.8  |  63.5    |  195.2   | 1004.5   | 22052.9  |
|  m2   | 1159.6  |  1264.9  | 1123.1   | 22074.8  |  26.6    |  189.1   | 1030.1   | 21330.7  |
|  m3   | 1143.4  |  1198.7  | 1113.0   | 22638.5  |  23.2    |  203.9   | 1031.5   | 21836.5  |
|  m4   | 1142.4  |  1196.5  | 1112.6   | 22638.6  |  23.1    |  204.4   | 1031.9   | 21834.5  |
|  m5   | 1158.9  |  1210.6  | 1122.7   | 22086.2  |  26.3    |  186.5   | 1030.7   | 21352.5  |
|  m6   | 1377.0  |  5145.6  | 1243.4   | 21366.1  |  89.0    |  1525.3  | 954.5    | 15990.3  |

Please see the detailed convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_July_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_July_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_July_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_July_m3.html)
- [Model 4](https://sijianf.github.io/ST_Covid/pages/Report_July_m4.html)
- [Model 5](https://sijianf.github.io/ST_Covid/pages/Report_July_m5.html)
- [Model 6](https://sijianf.github.io/ST_Covid/pages/Report_July_m6.html)







