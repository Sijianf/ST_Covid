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
- **H0b**: Intercept + Shared Temporal Random Effect
- **H1**: Current Case Count + Shared Temporal Random Effect
- **H2**: H1 + Lagged Death Count
- **H2a**: Lagged Death Count + Shared Temporal Random Effect
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

### 6 by 7 Tracking Table (variants excluded)

|         |  **H0**  |  **H0a** |  **H0b** |  **H1**  |  **H2**  |  **H2a** |  **H3**  |  **H4**  |  **H5**  |
|:-------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
| **L1**  |    m0    |    m1    |          |          |    m4    |          |          |    m3    |          |
| **L2**  |          |    m7    |          |          |    m5    |          |          |          |          |
| **L3**  |          |          |          |          |          |          |          |          |          |
| **L4**  |          |    m8    |          |          |    m10   |          |          |    m2    |          |
| **L5**  |          |          |          |          |          |          |          |          |          |
| **L6**  |          |          |          |          |          |          |          |          |          |
| **L7**  |          |    m9    |          |          |    m6    |          |          |          |          |

## Reports

### Joint modeling

|Model |DIC H                   |DIC L                    |DIC3 H                  |DIC3 L                 |PWAIC H               |PWAIC L                |WAIC H                  |WAIC L                   |
|:-----|:-----------------------|:------------------------|:-----------------------|:----------------------|:---------------------|:----------------------|:-----------------------|:------------------------|
|m0    |${\color{red}{1137.8}}$ |$22532.2$                |${\color{red}{1111.1}}$ |$22629.5$              |${\color{red}{21.4}}$ |${\color{red}{199.7}}$ |${\color{red}{1121.3}}$ |$22642.6$                |
|m1    |$1211.3$                |$22611.1$                |$1155.3$                |$22713.2$              |$41.9$                |$255$                  |$1181.6$                |$22735.6$                |
|m2    |$1231.5$                |$22092.4$                |$1159.7$                |$22131$                |$43.5$                |$240.7$                |$1186.6$                |$22154.2$                |
|m3    |$1211.3$                |$22616.8$                |$1153.8$                |$22718.5$              |$42.2$                |$259$                  |$1180.6$                |$22741.2$                |
|m4    |$1226$                  |$22621.9$                |$1153.6$                |$22718.7$              |$42.7$                |$258.1$                |$1180.9$                |$22742.9$                |
|m5    |$1223.2$                |$22091.5$                |$1159.2$                |$22157.3$              |$43.6$                |$237.6$                |$1186.2$                |$22178.5$                |
|m6    |$1227.5$                |$23434$                  |$1162.8$                |$20673.8$              |$46.3$                |$1002.2$               |$1192.6$                |$21062.6$                |
|m7    |$1215.4$                |$22057.8$                |$1158.6$                |$22143.6$              |$43.2$                |$229.8$                |$1185.8$                |$22163.6$                |
|m8    |$1208.4$                |${\color{red}{22047.3}}$ |$1158$                  |$22117.1$              |$43.7$                |$233.9$                |$1186.2$                |$22138.8$                |
|m9    |$1232.8$                |$22803.8$                |$1162.5$                |${\color{red}{20641}}$ |$43.9$                |$993.4$                |$1190.1$                |${\color{red}{21023.5}}$ |
|m10   |$1221.4$                |$22086.8$                |$1159.6$                |$22148.2$              |$44.4$                |$240.4$                |$1187.6$                |$22170.2$                |



### Separate modeling

|Model |DIC H                   |DIC L                    |DIC3 H                  |DIC3 L                   |PWAIC H               |PWAIC L                |WAIC H                  |WAIC L                   |
|:-----|:-----------------------|:------------------------|:-----------------------|:------------------------|:---------------------|:----------------------|:-----------------------|:------------------------|
|m0    |${\color{red}{1137.8}}$ |$22532.2$                |${\color{red}{1111.1}}$ |$22629.5$                |${\color{red}{21.4}}$ |${\color{red}{199.7}}$ |${\color{red}{1121.3}}$ |$22642.6$                |
|m1    |$1212.8$                |$22610.7$                |$1155.5$                |$22714.6$                |$41.8$                |$256.3$                |$1181.6$                |$22737.2$                |
|m2    |$1391.3$                |$22187.4$                |$1250.9$                |$22235.4$                |$92.6$                |$296$                  |$1321.6$                |$22267.5$                |
|m3    |$1391.3$                |$22738.7$                |$1250.9$                |$22832.1$                |$92.6$                |$328.2$                |$1321.6$                |$22869.2$                |
|m4    |$1385.4$                |$22724.4$                |$1245.2$                |$22827.7$                |$91.7$                |$325.2$                |$1316.3$                |$22864.6$                |
|m5    |$1375.9$                |$22218.9$                |$1245.7$                |$22261.9$                |$90.4$                |$294.5$                |$1314.9$                |$22293.7$                |
|m6    |$1377.5$                |$23110.7$                |$1247$                  |${\color{red}{20729.7}}$ |$90.8$                |$1040.4$               |$1316.4$                |${\color{red}{21133.3}}$ |
|m7    |$1222.4$                |$22070$                  |$1159.2$                |$22149.6$                |$43.4$                |$235.7$                |$1186.6$                |$22170.4$                |
|m8    |$1217.7$                |${\color{red}{22047.2}}$ |$1156.6$                |$22118.1$                |$42.3$                |$236.1$                |$1182.8$                |$22138.6$                |
|m9    |$1220.6$                |$23922$                  |$1158.8$                |$21168.5$                |$43.3$                |$1536.8$               |$1186.2$                |$21915.2$                |
|m10   |$1386$                  |$22221.5$                |$1247.7$                |$22238.8$                |$90.1$                |$298$                  |$1315.6$                |$22271.4$                |

#### Separate modeling for high level

|Type |Model |DIC_H                   |DIC3_H                  |PWAIC_H               |WAIC_H                  |
|:----|:-----|:-----------------------|:-----------------------|:---------------------|:-----------------------|
|H0   |m0    |${\color{red}{1137.8}}$ |${\color{red}{1111.1}}$ |${\color{red}{21.4}}$ |${\color{red}{1121.3}}$ |
|H0a  |m1    |$1212.8$                |$1155.5$                |$41.8$                |$1181.6$                |
|H0b  |-     |$1212.8$                |$1155.5$                |$41.8$                |$1181.6$                |
|H2   |m4    |$1385.4$                |$1245.2$                |$91.7$                |$1316.3$                |
|H2a  |-     |$1385.4$                |$1245.2$                |$91.7$                |$1316.3$                |
|H4   |m3    |$1391.3$                |$1250.9$                |$92.6$                |$1321.6$                |

#### Separate modeling for low level

|Type |Model |DIC_L     |DIC3_L                   |PWAIC_L                |WAIC_L                   |
|:----|:-----|:---------|:------------------------|:----------------------|:------------------------|
|L1   |m0    |$22532.2$ |$22629.5$                |${\color{red}{199.7}}$ |$22642.6$                |
|L4   |m2    |$22187.4$ |$22235.4$                |$296$                  |$22267.5$                |
|L7   |m6    |$23110.7$ |${\color{red}{20729.7}}$ |$1040.4$               |${\color{red}{21133.3}}$ |

Please see the detailed convergence reports and WAICs here: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m3.html)
- [Model 4](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m4.html)
- [Model 5](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m5.html)
- [Model 6](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m6.html)
- [Model 7](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m7.html)
- [Model 8](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m8.html)
- [Model 9](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m9.html)
- [Model 10](https://sijianf.github.io/ST_Covid/pages/Report_Oct_m10.html)


