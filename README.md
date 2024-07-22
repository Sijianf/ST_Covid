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
|-------|----------|
| **M0** | No regression for high-level; No lagged time effects as covariates; No cross-level random effects |
| **M1** | No regression for high-level; No lagged time effects as covariates; Cross-level random effects |
| **M2** | Regression for high-level; Lagged time effects as covariates; Cross-level random effects | 
| **M3** | Regression for high-level; Lagged time effects only in high-level ${}^*$; Cross-level random effects | 

${}^*$ Model 3 turns out to be a simpler version of Model 2.

## Nimble Codes

Please see the model codes in [models_raw.R](https://github.com/Sijianf/ST_Covid/blob/main/codes/models_raw.R).  

## Tracking of Model Selection

### High Models
- **H0**: Sum Only
- **H0a**: Sum + Shared Temporal Random Effect
- **H1**: Lagged Death Count Model
- **H2**: Current Case Count + Lagged Death Count Model
- **H3**: H2 + Cumulative Case
- **H4**: H3 + Spatial Effects and Additional Model Components

### Low Models
- **L1**: Current Case + Spatial Random Effect + Temporal Random Effect
- **L1a**: Lagged Death Count + Spatial Random Effect + Temporal Random Effect
- **L2**: L1 + Cumulative Case
- **L3**: L2 + Lagged Death Count
- **L4**: L3 + Spatial-Temporal Random Effect
- **L5**: L1 + Spatial Convolution
- **L6**: L4 + Spatial Convolution

### 7 by 6 Tracking Table

|         | **H0** | **H0a** | **H1** | **H2** | **H3** | **H4** |
|---------|--------|---------|--------|--------|--------|--------|
| **L1**  |        |         |        |        |        |        |
| **L1a** |        |         |        |        |        |        |
| **L2**  |        |         |        |        |        |        |
| **L3**  |        |         |        |        |        |        |
| **L4**  |        |         |        |        |        |        |
| **L5**  |        |         |        |        |        |        |
| **L6**  |        |         |        |        |        |        |

## Reports

| Model  | DIC H    | DIC L    | DIC3 H    | DIC3 L    | PWAIC H  | PWAIC L  | WAIC H    | WAIC L    |
|--------|----------|----------|-----------|-----------|----------|----------|-----------|-----------|
| Model0 | 12344.01 | 12396.56 | 12398.43  | 33900.04  | 86.66    | 161.99   | 12060.53  | 33256.55  |
| Model1 | 1339.12  | 1329.15  | 1218.72   | 22821.85  | 63.53    | 195.22   | 1004.57   | 22052.96  |
| Model2 | 1159.69  | 1264.90  | 1123.19   | 22074.80  | 26.68    | 189.18   | 1030.16   | 21330.70  |
| Model3 | 1143.40  | 1198.78  | 1113.01   | 22638.52  | 23.28    | 203.92   | 1031.58   | 21836.52  |

Please see the detailed convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_July_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_July_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_July_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_July_m3.html)