# Libraries ----
library(psych)
library(dplyr)
library(nortest)
library(lmtest)
library(car)
library(sandwich)

# Data Preprocessing ----
# Read data
data <- read.csv(file = "D:/Kuliah Zahra/Semester 5/Regression Analysis/ScreenTime vs MentalWellness.csv", 
                 header = TRUE, sep = ",")

# Check missing value 
sum(is.na(data))

# Drop baris yang column occupationnya bukan Employed atau Self-Employed
data <- data[data$occupation == "Employed" | data$occupation == "Self Employed", ]
head(data)
cat("Jumlah baris: ", nrow(data))

data <- data %>% rename("sleep_quality" = "sleep_quality_1_5",
                        "stress_level" = "stress_level_0_10",
                        "productivity" = "productivity_0_100",
                        "mental_wellness" = "mental_wellness_index_0_100")
head(data)
names(data)

table(data$sleep_quality)

# Buat variable selection (backward elimination)

# Baseline 3: ----
data$sleep_quality<-as.factor(data$sleep_quality)
data$sleep_quality<-relevel(data$sleep_quality, ref = 3)

m1 <- lm(stress_level ~ age + screen_time_hours + work_screen_hours + leisure_screen_hours 
         + sleep_hours + sleep_quality + productivity + exercise_minutes_per_week 
         + social_hours_per_week + mental_wellness, data = data)
summary(m1)

m2 <- lm(stress_level ~ screen_time_hours + work_screen_hours + leisure_screen_hours 
         + sleep_hours + sleep_quality + productivity + exercise_minutes_per_week 
         + social_hours_per_week + mental_wellness, data = data)
summary(m2)

m3 <- lm(stress_level ~ screen_time_hours + work_screen_hours + leisure_screen_hours 
         + sleep_quality + productivity + exercise_minutes_per_week + social_hours_per_week 
         + mental_wellness, data = data)
summary(m3)

m4 <- lm(stress_level ~ screen_time_hours + work_screen_hours + leisure_screen_hours 
         + sleep_quality + productivity + exercise_minutes_per_week + mental_wellness, 
         data = data)
summary(m4)

m5 <- lm(stress_level ~ screen_time_hours + leisure_screen_hours + sleep_quality 
         + productivity + exercise_minutes_per_week + mental_wellness, data = data)
summary(m5)

m6 <- lm(stress_level ~ leisure_screen_hours + sleep_quality + productivity 
         + exercise_minutes_per_week + mental_wellness, data = data)
summary(m6)

m7 <- lm(stress_level ~ sleep_quality + productivity + exercise_minutes_per_week 
         + mental_wellness, data = data)
summary(m7)

m8 <- lm(stress_level ~ sleep_quality + productivity + mental_wellness, data = data)
summary(m8)


data <- data %>% select(-c(user_id, age, gender, occupation, work_mode, screen_time_hours, 
                           work_screen_hours, leisure_screen_hours, sleep_hours,
                           exercise_minutes_per_week, social_hours_per_week, X))

head(data)

model <- lm(stress_level ~ ., data = data)
summary(model)

std_resid <- rstandard(model)
outlier_3sd <- which(abs(std_resid) > 3)
outlier_3sd

data$.std_resid <- rstandard(model)
data_clean <- subset(data, abs(.std_resid) <= 3)
summary(model_clean <- lm(
  stress_level ~ sleep_quality + mental_wellness + productivity,
  data = data_clean
))

h <- hatvalues(model_clean)
summary(h)


idx = which(h < 3 * (length(coef(model)) / nobs(model)))
model_trim = lm(stress_level ~ sleep_quality + mental_wellness + productivity,
                data = model_clean$model[idx, ])

summary(model_trim)


# Uji Error: ----
# Uji Normalitas
e <- resid(model_trim)
lillie.test(e)
# Kesimpulan: Error berdistribusi normal (0.1062 > 0.05 -> gagal tolak H0)

# Uji Heterokedastisitas
bptest(model_trim)
# Kesimpulan: Uji heterokedastisitas tidak terpenuhi (0.009588 < 0.05 -> tolak H0)

# Uji Non-autokorelasi
dwtest(model_trim)
# Kesimpulan: Tidak Ada autokorelasi dalam residual (0.6939 > 0.05 -> gagal tolak H0)

# Uji Multikolinear
vif(model_trim)
# Kesimpulan: Tidak ada multikolinearitas


data_gls <- data_clean[idx, ]
data_gls <- na.omit(data_gls)

str(data_gls)
library(nlme)

gls_model <- gls(
  stress_level ~ sleep_quality + mental_wellness + productivity,
  data = data_gls,
  weights = varPower(form = ~ fitted(.))
)

summary(gls_model)
res_gls <- resid(gls_model, type = "normalized")
fit_gls <- fitted(gls_model)

bptest(res_gls ~ fit_gls)


