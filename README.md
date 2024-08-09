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
| **L4**  |          |    m8    |          |    m10   |          |    m2    |          |
| **L5**  |          |          |          |          |          |          |          |
| **L6**  |          |          |          |          |          |          |          |
| **L7**  |          |    m9    |          |    m6    |          |          |          |

## Reports


| Model |   DIC H   |    DIC L   |   DIC3 H   |    DIC3 L  |   PWAIC H  |   PWAIC L  |   WAIC H   |   WAIC L   |
|:-----:|:---------:|:----------:|:----------:|:----------:|:----------:|:----------:|:----------:|:----------:|
|  m0   |  12343.3  |  33821.3   |  12406.3   |  33901.4   |    92.9    |   162.8    |  12411.1   |  33906.4   |
|  m1   |  1343.4   |  22794.8   |  1218.3    |  22823.8   |    63.4    |   196.0    |  1258.2    |  22835.7   |
|  m2   |  1159.0   | \color{red}{20009.0} |  1122.7    |  22065.5   |    26.6    |   190.6    |  1136.4    |  22078.4   |
|  m3   |  1146.1   |  22551.3   |  1112.9    |  22642.5   |    23.3    |   206.4    |  1124.7    |  22656.2   |
|  m4   | {\color{red}1141.7} |  22552.0   | {\color{red}1111.5} |  22638.2   |   {\color{red}22.6} |   203.6    | {\color{red}1122.8} |  22651.9   |
|  m5   |  1158.7   |  22017.5   |  1122.8    |  22085.9   |    26.4    |   187.0    |  1136.2    |  22098.6   |
|  m6   |  1405.5   |  24268.3   |  1243.8    |  21376.4   |    89.9    |   1524.8   |  1312.6    |  22101.5   |
|  m7   |  1473.9   |  22568.0   |  1312.3    |  22441.7   |    122.9   |   136.6    |  1407.7    |  22448.2   |
|  m8   |  1447.5   |  22552.6   |  1304.7    |  22449.1   |    117.9   | {\color{red}136.0} |  1395.5    |  22455.2   |
|  m9   |  1456.1   |  23776.0   |  1294.4    | {\color{red}21169.1} |    95.1    |   1535.9   |  1362.5    | {\color{red}21913.2} |
|  m10  |  1161.2   |  22020.0   |  1123.7    |  22086.4   |    26.8    |   187.4    |  1137.5    |  22098.6   |

Please see the detailed convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m3.html)
- [Model 4](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m4.html)
- [Model 5](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m5.html)
- [Model 6](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m6.html)
- [Model 7](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m7.html)
- [Model 8](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m8.html)
- [Model 9](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m9.html)
- [Model 10](https://sijianf.github.io/ST_Covid/pages/Report_Aug_m10.html)





