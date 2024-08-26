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
| m0    | ${\color{red}1138}$  | $22532$ | ${\color{red}1111}$  | $22630$ | ${\color{red}21.4}$  | ${\color{red}199.7}$ | ${\color{red}1121}$  | $22643$ |
| m1    | $1211$  | $22611$ | $1155$  | $22713$ | $41.9$  | $255.0$ | $1182$  | $22736$ |
| m2    | $1219$  | ${\color{red}22056}$ | $1159$  | $22133$ | $43.5$  | $239.8$ | $1186$  | $22154$ |
| m3    | $1211$  | $22617$ | $1154$  | $22718$ | $42.2$  | $259.0$ | $1181$  | $22741$ |
| m4    | $1213$  | $22618$ | $1154$  | $22719$ | $42.3$  | $258.9$ | $1181$  | $22743$ |
| m5    | $1218$  | $22081$ | $1160$  | $22159$ | $43.6$  | $239.6$ | $1187$  | $22180$ |
| m6    | $1231$  | $22757$ | $1165$  | $20663$ | $46.6$  | $994.8$ | $1194$  | $21040$ |
| m7    | $1215$  | $22058$ | $1159$  | $22144$ | $43.2$  | $229.8$ | $1186$  | $22164$ |
| m8    | $1216$  | $22070$ | $1157$  | $22121$ | $42.7$  | $234.3$ | $1184$  | $22141$ |
| m9    | $1225$  | $22728$ | $1162$  | ${\color{red}20648}$ | $44.0$  | $996.1$ | $1190$  | ${\color{red}21028}$ |
| m10   | $1228$  | $22088$ | $1160$  | $22151$ | $44.2$  | $242.2$ | $1188$  | $22173$ |

#### Combined high and low level models 

| Model | DIC Total | DIC3 Total | PWAIC Total | WAIC Total | 
|-------|-----------|------------|-------------|------------|
| m0    | 23670     | 23741      | ${\color{red}221.1}$  | 23764      |
| m1    | 23822     | 23868      | 296.9       | 23918      |
| m2    | ${\color{red}23275}$ | 23292      | 283.3       | 23340      |
| m3    | 23828     | 23872      | 301.2       | 23922      |
| m4    | 23831     | 23873      | 301.2       | 23924      |
| m5    | 23299     | 23319      | 283.2       | 23367      |
| m6    | 23988     | ${\color{red}21828}$ | 1041.4      | 22234      |
| m7    | ${\color{red}23273}$ | 23303      | 273.0  | 23350      |
| m8    | 23286     | 23278 | 277.0       | 23325 |
| m9    | 23953     | ${\color{red}21810}$ | 1040.1      | ${\color{red}22218}$ |
| m10   | 23316     | 23311      | 286.4       | 23361      |


### Separate modeling

| Model |  DIC H  |  DIC L  | DIC3 H  | DIC3 L  | PWAIC H | PWAIC L | WAIC H  | WAIC L  |
|-------|---------|---------|---------|---------|---------|---------|---------|---------|
| m0    | ${\color{red}1138}$  | $22532$ | ${\color{red}1111}$  | $22630$ | ${\color{red}21.4}$  | ${\color{red}199.7}$ | ${\color{red}1121}$  | $22643$ |
| m1    | $1213$  | $22611$ | $1155$  | $22715$ | $41.8$  | $256.3$ | $1182$  | $22737$ |
| m2    | $1380$  | $22187$ | $1255$  | $22235$ | $93.2$  | $296.0$ | $1326$  | $22267$ |
| m3    | $1388$  | $22744$ | $1251$  | $22834$ | $91.9$  | $329.5$ | $1320$  | $22871$ |
| m4    | $1376$  | $22742$ | $1244$  | $22830$ | $90.3$  | $327.2$ | $1313$  | $22866$ |
| m5    | $1361$  | $22219$ | $1242$  | $22262$ | $89.2$  | $294.5$ | $1310$  | $22294$ |
| m6    | $1378$  | $23111$ | $1247$  | ${\color{red}20730}$ | $90.8$  | $1040$  | $1316$  | ${\color{red}21133}$ |
| m7    | $1222$  | $22070$ | $1159$  | $22150$ | $43.4$  | $235.7$ | $1187$  | $22170$ |
| m8    | $1214$  | ${\color{red}22044}$ | $1157$  | $22121$ | $43.0$  | $235.3$ | $1185$  | $22142$ |
| m9    | $1448$  | $23922$ | $1293$  | $21169$ | $94.6$  | $1537$  | $1361$  | $21915$ |
| m10   | $1381$  | $22212$ | $1246$  | $22235$ | $90.9$  | $297.1$ | $1316$  | $22267$ |

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

Below are the archived previous pages: 

- [Model 0](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m0.html)
- [Model 1](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m1.html)
- [Model 2](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m2.html)
- [Model 3](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m3.html)
- [Model 4](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m4.html)
- [Model 5](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m5.html)
- [Model 6](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m6.html)
- [Model 7](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m7.html)
- [Model 8](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m8.html)
- [Model 9](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m9.html)
- [Model 10](https://sijianf.github.io/ST_Covid/pages/archived/Report_Aug_m10.html)



