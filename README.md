# GLS of Stress Levels Based on Sleep Quality, Mental Wellness & Productivity

> **Generalized Least Squares (GLS) regression analysis to examine factors associated with stress levels based on sleep quality, mental wellness, and productivity.**

[![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge\&logo=r\&logoColor=white)](https://www.r-project.org/)
[![Statistics](https://img.shields.io/badge/Statistical%20Modeling-Regression-4B8BBE?style=for-the-badge)]()
[![Method](https://img.shields.io/badge/Method-GLS-8A2BE2?style=for-the-badge)]()

---

## Project Overview

Stress is influenced by various aspects of daily life, including sleep quality, psychological well-being, and perceived productivity. This project investigates how these factors are associated with an individual's **stress level** using regression analysis.

The analysis begins with a multiple linear regression model using **Ordinary Least Squares (OLS)**. Model assumptions are then evaluated through residual diagnostics, including normality, heteroscedasticity, autocorrelation, and multicollinearity testing.

Since the OLS model exhibits a **heteroscedasticity problem**, the analysis proceeds to **Generalized Least Squares (GLS)** to account for non-constant error variance.

The final model focuses on three key explanatory variables:

* **Sleep Quality**
* **Mental Wellness**
* **Productivity**

The project demonstrates how regression modeling can be extended beyond ordinary linear regression when classical assumptions are not fully satisfied.

---

## Problem Statement

Stress can negatively affect both psychological well-being and daily performance. However, stress is not determined by a single factor.

This project addresses the following question:

> **How do sleep quality, mental wellness, and productivity relate to an individual's stress level, and can Generalized Least Squares provide a more appropriate regression framework when the OLS assumption of constant error variance is violated?**

---

## Objectives

The main objectives of this project are to:

1. Explore the relationship between stress level and several lifestyle and well-being variables.
2. Develop a multiple linear regression model using OLS.
3. Perform variable selection using a backward elimination approach.
4. Identify and handle potential outliers and influential observations.
5. Evaluate the assumptions of the regression model.
6. Identify violations of classical regression assumptions.
7. Apply Generalized Least Squares (GLS) to address heteroscedasticity.
8. Obtain a regression model that better accounts for non-constant error variance.
9. Interpret the relationship between sleep quality, mental wellness, productivity, and stress level.

---

## Dataset

The analysis uses the **Screen Time vs Mental Wellness Survey** dataset containing **400 observations**. Each observation represents an individual survey respondent with demographic, screen-time, lifestyle, and well-being information.

### Dataset Characteristics

| Category               | Description                                  |
| ---------------------- | -------------------------------------------- |
| Number of observations | **400**                                      |
| Unit of observation    | Individual respondent                        |
| Data type              | Survey data                                  |
| Target variable        | Stress Level                                 |
| Main predictors        | Sleep Quality, Mental Wellness, Productivity |
| Sleep Quality scale    | 1–5                                          |
| Stress Level scale     | 0–10                                         |
| Productivity scale     | 0–100                                        |
| Mental Wellness scale  | 0–100                                        |

### Variables

| Variable                    | Description                     | Type        |
| --------------------------- | ------------------------------- | ----------- |
| `user_id`                   | Unique respondent identifier    | Categorical |
| `age`                       | Age of respondent               | Numerical   |
| `gender`                    | Gender of respondent            | Categorical |
| `occupation`                | Occupation category             | Categorical |
| `work_mode`                 | Working mode                    | Categorical |
| `screen_time_hours`         | Total daily screen time         | Numerical   |
| `work_screen_hours`         | Daily work-related screen time  | Numerical   |
| `leisure_screen_hours`      | Daily leisure screen time       | Numerical   |
| `sleep_hours`               | Daily sleep duration            | Numerical   |
| `sleep_quality`             | Perceived sleep quality, 1–5    | Ordinal     |
| `stress_level`              | Stress level, 0–10              | Numerical   |
| `productivity`              | Productivity score, 0–100       | Numerical   |
| `exercise_minutes_per_week` | Weekly exercise duration        | Numerical   |
| `social_hours_per_week`     | Weekly social interaction hours | Numerical   |
| `mental_wellness`           | Mental wellness index, 0–100    | Numerical   |

The variable names `sleep_quality_1_5`, `stress_level_0_10`, `productivity_0_100`, and `mental_wellness_index_0_100` are renamed in the analysis to `sleep_quality`, `stress_level`, `productivity`, and `mental_wellness` for easier modeling.

---

## Research Focus

The analysis investigates the relationship between:

### Dependent Variable

**Stress Level (`stress_level`)**

A score ranging from 0 to 10 representing the respondent's reported stress level.

### Independent Variables

The final regression model uses:

* **Sleep Quality (`sleep_quality`)**
* **Mental Wellness (`mental_wellness`)**
* **Productivity (`productivity`)**

The initial model considers a broader set of demographic, screen-time, lifestyle, and wellness variables before applying variable selection.

---

## Methodology

The statistical workflow consists of several stages.

```text
Raw Dataset
     │
     ▼
Data Preprocessing
     │
     ├── Missing Value Check
     ├── Occupation Filtering
     └── Variable Renaming
     │
     ▼
Multiple Linear Regression (OLS)
     │
     ▼
Backward Elimination
     │
     ▼
Outlier & Influence Detection
     │
     ├── Standardized Residuals
     └── Leverage Values
     │
     ▼
Regression Assumption Testing
     │
     ├── Normality
     ├── Heteroscedasticity
     ├── Autocorrelation
     └── Multicollinearity
     │
     ▼
Heteroscedasticity Detected
     │
     ▼
Generalized Least Squares (GLS)
     │
     ▼
Variance Structure: varPower()
     │
     ▼
Final Model & Residual Evaluation
```

---

## 1. Data Preprocessing

The dataset is first checked for missing values and filtered to retain respondents whose occupation is:

* `Employed`
* `Self Employed`

The original variable names are also simplified for modeling.

```r
data <- data[data$occupation == "Employed" |
             data$occupation == "Self Employed", ]

data <- data %>% 
  rename(
    sleep_quality = sleep_quality_1_5,
    stress_level = stress_level_0_10,
    productivity = productivity_0_100,
    mental_wellness = mental_wellness_index_0_100
  )
```

The analysis also treats `sleep_quality` as a categorical factor and uses quality level 3 as the reference category.

---

## 2. Multiple Linear Regression

An initial multiple linear regression model is developed to examine the relationship between stress level and a broad set of potential explanatory variables.

The initial predictors include:

* Age
* Total screen time
* Work screen time
* Leisure screen time
* Sleep duration
* Sleep quality
* Productivity
* Exercise
* Social interaction
* Mental wellness

The general form of the model is:

$$
Stress_i =
\beta_0 +
\beta_1X_{1i} +
\beta_2X_{2i} +
\cdots +
\beta_kX_{ki} +
\epsilon_i
$$

---

## 3. Variable Selection

A **backward elimination** approach is used to gradually remove predictors that contribute less to the model.

Eight candidate models (`m1`–`m8`) are evaluated with progressively fewer predictors.

The final OLS specification selected for further analysis contains:

$$
Stress =
\beta_0 +
\beta_1 SleepQuality +
\beta_2 MentalWellness +
\beta_3 Productivity +
\epsilon
$$

This allows the analysis to focus on the three most relevant variables identified through the model selection process.

---

## 4. Outlier Detection

Potential outliers are investigated using **standardized residuals**.

Observations with:

$$
|r_i| > 3
$$

are identified as potential outliers.

These observations are removed before refitting the model.

```r
std_resid <- rstandard(model)

outlier_3sd <- which(abs(std_resid) > 3)

data_clean <- subset(
  data,
  abs(.std_resid) <= 3
)
```

This step helps reduce the influence of extreme observations on the estimated regression coefficients.

---

## 5. Leverage / Influence Detection

After removing observations with extreme standardized residuals, leverage values are examined to identify potentially influential observations.

The analysis uses a leverage threshold based on:

$$
h_i < \frac{3p}{n}
$$

where:

* \(h_i\) = leverage value
* \(p\) = number of estimated coefficients
* \(n\) = number of observations

The resulting observations are then used to construct the trimmed regression model.

---

# Regression Assumption Testing

Before applying GLS, the OLS model is evaluated against several classical regression assumptions.

---

## 6. Normality of Residuals

The **Lilliefors test** is used to evaluate whether the regression residuals follow a normal distribution.

### Result

```text
p-value = 0.1062
```

Since:

$$
p > 0.05
$$

there is insufficient evidence to reject the null hypothesis of normally distributed residuals.

**Conclusion:** The residual normality assumption is satisfied.

---

## 7. Homoscedasticity

The **Breusch–Pagan test** is performed to evaluate whether the residual variance is constant.

### Result

```text
p-value = 0.009588
```

Since:

$$
p < 0.05
$$

the null hypothesis of constant variance is rejected.

**Conclusion:**

> The OLS model exhibits **heteroscedasticity**.

This finding motivates the use of **Generalized Least Squares (GLS)** rather than relying solely on the OLS estimates.

---

## 8. Autocorrelation

The **Durbin–Watson test** is used to examine potential autocorrelation among residuals.

### Result

```text
p-value = 0.6939
```

Since:

$$
p > 0.05
$$

there is insufficient evidence of residual autocorrelation.

**Conclusion:** The non-autocorrelation assumption is satisfied.

---

## 9. Multicollinearity

Variance Inflation Factor (**VIF**) is used to evaluate multicollinearity among the explanatory variables.

The analysis indicates that the final predictors do not exhibit problematic multicollinearity.

**Conclusion:** Multicollinearity is not identified as a major issue in the final model.

---

# Generalized Least Squares (GLS)

Because the OLS model violates the homoscedasticity assumption, **Generalized Least Squares** is applied.

GLS is an extension of ordinary least squares that allows the model to account for a non-constant error variance structure.

The final GLS model is specified as:

$$
Stress =
\beta_0 +
\beta_1 SleepQuality +
\beta_2 MentalWellness +
\beta_3 Productivity +
\epsilon
$$

with a **power variance structure**:

```r
gls_model <- gls(
  stress_level ~ sleep_quality +
    mental_wellness +
    productivity,
  data = data_gls,
  weights = varPower(form = ~ fitted(.))
)
```

The `varPower()` structure allows the residual variance to change as a function of the fitted values, making it appropriate for modeling heteroscedastic errors.

---

# Statistical Model

The final GLS model can be represented as:

$$
Y = X\beta + \epsilon
$$

where:

* \(Y\) = stress level
* \(X\) = matrix of predictors
* \(\beta\) = vector of regression coefficients
* \(\epsilon\) = error term with non-constant variance

Unlike OLS, GLS accounts for the covariance structure of the errors:

$$
Var(\epsilon) = \sigma^2\Omega
$$

where \(\Omega\) represents the estimated error variance structure.

In this project, the variance structure is modeled using a power function based on the fitted values.

---

# Model Evaluation

The analysis evaluates the final model through:

### Regression Coefficients

Used to understand the direction and magnitude of the relationship between each predictor and stress level.

### Statistical Significance

Used to determine whether individual predictors provide statistically significant evidence of an association with stress.

### Residual Diagnostics

Residuals from the GLS model are extracted and evaluated to determine whether the heteroscedasticity issue has been adequately addressed.

```r
res_gls <- resid(
  gls_model,
  type = "normalized"
)

fit_gls <- fitted(gls_model)

bptest(res_gls ~ fit_gls)
```

---

# Key Findings

The analysis produces several important methodological findings:

### 1. Stress can be modeled using multiple well-being indicators

Sleep quality, mental wellness, and productivity are retained as the primary explanatory variables in the final regression specification.

### 2. OLS assumptions are not completely satisfied

The residuals satisfy the normality and non-autocorrelation requirements, while the homoscedasticity assumption is violated.

### 3. Heteroscedasticity motivates the use of GLS

The Breusch–Pagan test produces a p-value of **0.009588**, providing evidence that the residual variance is not constant.

### 4. GLS provides a more appropriate modeling framework

Rather than ignoring the unequal variance, GLS explicitly incorporates a variance structure through `varPower()`.

### 5. The project demonstrates a complete regression workflow

The analysis does not stop at fitting a regression model. It includes:

> **Preprocessing → Variable Selection → Outlier Detection → Influence Analysis → Assumption Testing → GLS → Residual Evaluation**

---

# Tools & Technologies

| Tool         | Purpose                                      |
| ------------ | -------------------------------------------- |
| **R**        | Statistical analysis and regression modeling |
| **RStudio**  | Development environment                      |
| **dplyr**    | Data manipulation and preprocessing          |
| **psych**    | Statistical analysis                         |
| **nortest**  | Normality testing                            |
| **lmtest**   | Regression diagnostic tests                  |
| **car**      | Multicollinearity / VIF analysis             |
| **sandwich** | Robust statistical methods                   |
| **nlme**     | Generalized Least Squares modeling           |
| **Excel**    | Dataset storage and inspection               |

---

#  R Packages

The project uses the following R packages:

```r
library(psych)
library(dplyr)
library(nortest)
library(lmtest)
library(car)
library(sandwich)
library(nlme)
```

---

# Repository Structure

```text
GLS-of-Stress-Levels-Based-on-Sleep-Quality-Mental-Wellness-Productivity/
│
├── AoL Regresi Kelompok 5.R
│       └── Complete R analysis workflow
│
├── ScreenTime vs MentalWellness.xlsx
│       └── Dataset used for the analysis
│
├── Code & Output.pdf
│       └── Code execution and statistical outputs
│
├── Paper Regression - Kel 5 - LA06.docx
│       └── Project report
│
├── Paper Regression - Kel 5 - LA06.pdf
│       └── Project report in PDF format
│
├── PPT AoL Group 5 LA06.pptx
│       └── Presentation slides
│
├── Template PKM-AI 2025 jadi.docx
│       └── Supporting project document
│
├── [Turnitin] Paper Regression.pdf
│       └── Similarity-check document
│
└── README.md
        └── Project documentation
```

The repository currently contains the R script, dataset spreadsheet, analysis output PDF, report, presentation, and supporting documents.

---

# How to Run

## 1. Clone the Repository

```bash
git clone https://github.com/zahraafandii/GLS-of-Stress-Levels-Based-on-Sleep-Quality-Mental-Wellness-Productivity.git
```

## 2. Open the Project

Open the repository using **RStudio**.

## 3. Install Required Packages

```r
install.packages(c(
  "psych",
  "dplyr",
  "nortest",
  "lmtest",
  "car",
  "sandwich",
  "nlme"
))
```

## 4. Update the Dataset Path

The original script contains a local file path:

```r
data <- read.csv(
  file = "D:/Kuliah Zahra/Semester 5/Regression Analysis/ScreenTime vs MentalWellness.csv",
  header = TRUE,
  sep = ","
)
```

Update the path according to the location of your dataset.

For example:

```r
data <- read.csv(
  "ScreenTime vs MentalWellness.csv",
  header = TRUE,
  sep = ","
)
```

## 5. Run the Analysis

Run the script:

```text
AoL Regresi Kelompok 5.R
```

The script will perform:

1. Data preprocessing
2. Variable transformation
3. Backward elimination
4. OLS regression
5. Outlier detection
6. Leverage analysis
7. Regression assumption testing
8. GLS modeling
9. GLS residual evaluation

---

# Statistical Techniques Used

This project applies the following statistical techniques:

* Descriptive data inspection
* Multiple Linear Regression
* Backward Elimination
* Standardized Residual Analysis
* Outlier Detection
* Leverage Analysis
* Lilliefors Normality Test
* Breusch–Pagan Test
* Durbin–Watson Test
* Variance Inflation Factor (VIF)
* Generalized Least Squares
* Power Variance Structure
* Normalized Residual Analysis

---

# Why GLS?

A standard linear regression model assumes:

$$
Var(\epsilon_i) = \sigma^2
$$

meaning that the error variance is constant across observations.

However, the Breusch–Pagan test in this analysis indicates:

$$
p = 0.009588 < 0.05
$$

which suggests that the error variance is not constant.

Therefore, applying GLS provides a statistically motivated alternative by explicitly modeling the changing variance.

This makes the project particularly useful as an example of **regression diagnostics leading to model refinement**, rather than simply fitting a model and reporting its coefficients.

---

# Learning Outcomes

Through this project, the following statistical modeling skills were developed:

* Understanding multiple linear regression
* Performing systematic variable selection
* Diagnosing regression assumptions
* Identifying outliers and influential observations
* Interpreting statistical hypothesis tests
* Understanding heteroscedasticity
* Applying Generalized Least Squares
* Specifying variance structures in `nlme`
* Evaluating model residuals
* Translating statistical output into substantive interpretations

---

# Limitations

Several limitations should be considered when interpreting the results:

1. The dataset consists of self-reported survey responses.
2. The analysis is observational, so regression relationships should not automatically be interpreted as causal effects.
3. The dataset represents a limited sample and may not generalize to all populations.
4. Stress, productivity, sleep quality, and mental wellness are subjective measures.
5. The analysis focuses on a selected set of predictors after variable selection.
6. GLS addresses the heteroscedasticity identified in the OLS model but does not eliminate all limitations associated with observational survey data.

---

# Future Improvements

Potential improvements include:

* Compare OLS, Weighted Least Squares (WLS), and GLS performance.
* Compare different variance structures such as `varIdent()`, `varExp()`, and `varPower()`.
* Perform formal model comparison using AIC.
* Report confidence intervals for GLS coefficients.
* Add visual residual diagnostics.
* Evaluate predictive performance using cross-validation.
* Investigate potential nonlinear relationships.
* Explore interaction effects between sleep quality, mental wellness, and productivity.
* Include additional behavioral variables where theoretically justified.

---

# Author
* Bella Nadya Aurelia
* Leora Natania Klarise Purba
* Sanly
* Zahra Annisa Afandi

Computer Science & Statistics Undergraduate
BINUS University

---

## Project Documentation

For a detailed explanation of the methodology, statistical results, and interpretation, see the project report and supporting documents available in this repository.

---

## Project Summary

> **This project applies Generalized Least Squares regression to model stress levels using sleep quality, mental wellness, and productivity. Starting from multiple linear regression, the analysis performs variable selection and regression diagnostics, identifies heteroscedasticity through the Breusch–Pagan test, and subsequently applies GLS with a power variance structure to account for non-constant error variance.**

**Keywords:** `R` · `Regression Analysis` · `OLS` · `GLS` · `Heteroscedasticity` · `Statistical Modeling` · `Sleep Quality` · `Mental Wellness` · `Stress Level` · `Productivity`
