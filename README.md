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

|Model |DIC H      |DIC L       |DIC3 H     |DIC3 L    |PWAIC H  |PWAIC L   |WAIC H     |WAIC L      |
|:-----|:----------|:-----------|:----------|:---------|:--------|:---------|:----------|:-----------|
|m1    |**1137.8** |22532.2     |**1111.1** |22629.5   |**21.4** |**199.7** |**1121.3** |22642.6     |
|m2    |1211.3     |22611.1     |1155.3     |22713.2   |41.9     |255       |1181.6     |22735.6     |
|m3    |1231.5     |22092.4     |1159.7     |22131     |43.5     |240.7     |1186.6     |22154.2     |
|m4    |1211.3     |22616.8     |1153.8     |22718.5   |42.2     |259       |1180.6     |22741.2     |
|m5    |1226       |22621.9     |1153.6     |22718.7   |42.7     |258.1     |1180.9     |22742.9     |
|m6    |1223.2     |22091.5     |1159.2     |22157.3   |43.6     |237.6     |1186.2     |22178.5     |
|m7    |1227.5     |23434       |1162.8     |20673.8   |46.3     |1002.2    |1192.6     |21062.6     |
|m8    |1215.4     |22057.8     |1158.6     |22143.6   |43.2     |229.8     |1185.8     |22163.6     |
|m9    |1208.4     |**22047.3** |1158       |22117.1   |43.7     |233.9     |1186.2     |22138.8     |
|m10   |1232.8     |22803.8     |1162.5     |**20641** |43.9     |993.4     |1190.1     |**21023.5** |
|m11   |1221.4     |22086.8     |1159.6     |22148.2   |44.4     |240.4     |1187.6     |22170.2     |

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
| m6    | $1378$  | $23111$ | $1247$  | ${\color{red}20730}$ | $90.8$  | $1040$  | $1316$  | $21133$ |
| m7    | $1222$  | $22070$ | $1159$  | $22150$ | $43.4$  | $235.7$ | $1187$  | $22170$ |
| m8    | $1214$  | ${\color{red}22044}$ | $1157$  | $22121$ | $43.0$  | $235.3$ | $1185$  | $22142$ |
| m9    | $1220$  | $22840$ | $1158$  | $20635$ | $43.3$  | $997.1$  | $1186$  | ${\color{red}21016}$ |
| m10   | $1381$  | $22212$ | $1246$  | $22235$ | $90.9$  | $297.1$ | $1316$  | $22267$ |

#### Combined high and low level models 

| Model |   DIC  |  DIC3  |  PWAIC  |  WAIC  |
|-------|--------|--------|---------|--------|
| m0    | 23670  | 23741  | 221.1   | 23764  |
| m1    | 23824  | 23870  | 298.1   | 23919  |
| m2    | 23567  | 23490  | 389.2   | 23593  |
| m3    | 24132  | 24085  | 421.4   | 24191  |
| m4    | 24118  | 24074  | 417.5   | 24179  |
| m5    | 23580  | 23504  | 383.7   | 23604  |
| m6    | 24489  | 21977  | 1130.8  | 22449  |
| m7    | 23292  | 23309  | 279.1   | 23357  |
| m8    | ${\color{red}23258}$  | 23278  | ${\color{red}278.3}$   | 23327  |
| m9    | 24060  | ${\color{red}21793}$  | 1040.4  | ${\color{red}22202}$  |
| m10   | 23593  | 23481  | 388.0   | 23583  |


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


