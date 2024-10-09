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

|Model                             |DIC_H                                           |DIC_L                                           |DIC3_H                                         |DIC3_L                                          |PWAIC_H                                         |PWAIC_L                                         |WAIC_H                                          |WAIC_L                                          |
|:---------------------------------|:-----------------------------------------------|:-----------------------------------------------|:----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|:-----------------------------------------------|
|<span style="color:red">m1</span> |<span style="color:red">1137.78104676453</span> |22532.1778436994                                |<span style="color:red">1111.1466102909</span> |22629.5469327488                                |<span style="color:red">21.3792293960105</span> |<span style="color:red">199.695044431753</span> |<span style="color:red">1121.27927664694</span> |22642.6012679475                                |
|m2                                |1211.34548581276                                |22611.0628920371                                |1155.316172777                                 |22713.2478842958                                |41.9159201102452                                |255.010499323176                                |1181.63383099882                                |22735.5757663547                                |
|m3                                |1231.45086793158                                |22092.3767742807                                |1159.66530886359                               |22131.0243814883                                |43.4945573457186                                |240.726824459907                                |1186.57378310894                                |22154.1587800148                                |
|m4                                |1211.32188459943                                |22616.7719446859                                |1153.83457623301                               |22718.4531383608                                |42.2398484939946                                |259.037677737545                                |1180.55173944551                                |22741.2220428992                                |
|m5                                |1226.02334038014                                |22621.9292139513                                |1153.62333835681                               |22718.7490171809                                |42.6641618798287                                |258.063407574316                                |1180.85378256396                                |22742.8689830584                                |
|m6                                |1223.23311108592                                |22091.4702197889                                |1159.15230521315                               |22157.2816570747                                |43.5552293859831                                |237.625588042826                                |1186.24757122455                                |22178.4975042074                                |
|m7                                |1227.54301334555                                |23434.0201302094                                |1162.80834373372                               |20673.7529947891                                |46.2726604701526                                |1002.19959899688                                |1192.59910103653                                |21062.5773969857                                |
|m8                                |1215.35110652844                                |22057.7555780891                                |1158.56181947772                               |22143.5978762778                                |43.1803544970839                                |229.839528729583                                |1185.76558261424                                |22163.6084267502                                |
|m9                                |1208.38463920536                                |<span style="color:red">22047.3051700343</span> |1158.03151003174                               |22117.1098024181                                |43.706427204453                                 |233.917363284035                                |1186.21420471328                                |22138.8429405602                                |
|m10                               |1232.800622908                                  |22803.7627215937                                |1162.49887316186                               |<span style="color:red">20640.9861360609</span> |43.8649068747157                                |993.411417033488                                |1190.09517127785                                |<span style="color:red">21023.4924322135</span> |
|m11                               |1221.44081121649                                |22086.7639559927                                |1159.61959797003                               |22148.1564065992                                |44.3533490569117                                |240.421374011984                                |1187.60308247172                                |22170.2218008637                                |


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


