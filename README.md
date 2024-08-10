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

### Joint modeling

| Model |  DIC H  |  DIC L  | DIC3 H  | DIC3 L  | PWAIC H | PWAIC L | WAIC H  | WAIC L  |
|-------|---------|---------|---------|---------|---------|---------|---------|---------|
| m0    | $12343$ | $33821$ | $12406$ | $33901$ | $92.9$  | $162.8$ | $12411$ | $33906$ |
| m1    | $1343$  | $22795$ | $1218$  | $22824$ | $63.4$  | $196.0$ | $1258$  | $22836$ |
| m2    | $1159$  | ${\color{red}20009}$ | $1123$  | $22066$ | $26.6$  | $190.6$ | $1136$  | $22078$ |
| m3    | $1146$  | $22551$ | $1113$  | $22643$ | $23.3$  | $206.4$ | $1125$  | $22656$ |
| m4    | ${\color{red}1142}$ | $22552$ | ${\color{red}1112}$ | $22638$ | ${\color{red}22.6}$ | $203.6$ | ${\color{red}1123}$ | $22652$ |
| m5    | $1159$  | $22018$ | $1123$  | $22086$ | $26.4$  | $187.0$ | $1136$  | $22099$ |
| m6    | $1406$  | $24268$ | $1244$  | $21376$ | $89.9$  | $1525$  | $1313$  | $22102$ |
| m7    | $1474$  | $22568$ | $1312$  | $22442$ | $122.9$ | $136.6$ | $1408$  | $22448$ |
| m8    | $1448$  | $22553$ | $1305$  | $22449$ | $117.9$ | ${\color{red}136.0}$ | $1396$  | $22455$ |
| m9    | $1456$  | $23776$ | $1294$  | ${\color{red}21169}$ | $95.1$  | $1536$  | $1363$  | ${\color{red}21913}$ |
| m10   | $1161$  | $22020$ | $1124$  | $22086$ | $26.8$  | $187.4$ | $1138$  | $22099$ |

### Separate modeling

| Model |  DIC H  |  DIC L  | DIC3 H  | DIC3 L  | PWAIC H | PWAIC L | WAIC H  | WAIC L  |
|-------|---------|---------|---------|---------|---------|---------|---------|---------|
| m0    | $12343$ | $33820$ | $12404$ | $33901$ | $90.43$ | $162.5$ | $12408$ | $33905$ |
| m1    | $1354$  | $33770$ | ${\color{red}1230}$  | $33889$ | ${\color{red}84.88}$ | $167.7$ | ${\color{red}1295}$  | $33894$ |
| m2    | $1381$  | $27389$ | $1247$  | $27461$ | $91.08$ | ${\color{red}121.1}$ | $1317$  | $27465$ |
| m3    | $1387$  | $33774$ | $1249$  | $33889$ | $92.31$ | $167.4$ | $1320$  | $33893$ |
| m4    | $1388$  | $33775$ | $1244$  | $33892$ | $89.78$ | $169.8$ | $1313$  | $33897$ |
| m5    | $1380$  | $30293$ | $1245$  | $30383$ | $90.15$ | $139.3$ | $1314$  | $30387$ |
| m6    | $1377$  | ${\color{red}24118}$ | $1244$  | ${\color{red}21368}$ | $89.58$ | $1525$  | $1312$  | ${\color{red}22092}$ |
| m7    | ${\color{red}1368}$  | $30294$ | $1242$  | $30384$ | $88.32$ | $140.1$ | $1309$  | $30388$ |
| m8    | $1375$  | $27388$ | $1252$  | $27458$ | $90.75$ | $118.7$ | $1321$  | $27462$ |
| m9    | -       | -       | -       | -       | -       | -       | -       | -       |
| m10   | $1393$  | $27391$ | $1246$  | $27462$ | $90.50$ | $122.0$ | $1315$  | $27466$ |

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





