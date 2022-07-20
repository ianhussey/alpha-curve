library(rvest)
library(tidyverse)
domain <- "https://ipip.ori.org/"
ipip <- read_html(str_c(domain, "newIndexofScaleLabels.htm"))
scale_pages <- ipip %>% html_nodes("a[href]") %>% html_attr("href")
scale_pages <- setdiff(scale_pages, "index.htm")
scale_pages <- str_match(scale_pages, "^(.+?)#")[,2]
scale_pages <- unique(scale_pages)

scale_alphas <- data.frame(scale=character(0), alpha = numeric(0))
for(i in seq_along(scale_pages)) {
  scale <- read_html(str_c(domain, scale_pages[i]))
  headings <- scale %>% html_nodes("td")
  alphas <- headings %>% html_text() %>%
    str_match(string = ., pattern = ".*(\\.\\d\\d).*")
  scales <- alphas[,1]
  alphas <- alphas[,2]
  scales <- scales[!is.na(alphas)]
  alphas <- alphas[!is.na(alphas)]
  scale_alphas <- rbind(scale_alphas, data.frame(scale = scales, alpha = as.numeric(alphas)))
}

scale_alphas <- distinct(scale_alphas)

library(broom)
library(betareg)
library(extraDistr)

model_beta <- betareg(alpha ~ 1 | 1, data = scale_alphas,
          link = "logit")

beta_mu_intercept <- model_beta %>%
  tidy() %>%
  filter(component == "mean", term == "(Intercept)") %>%
  pull(estimate)

# # average alpha according to model
# plogis(beta_mu_intercept)
# ## [1] 0.8174543

beta_phi_intercept <- model_beta %>%
  tidy() %>%
  filter(component == "precision", term == "(Intercept)") %>%
  pull(estimate)

ggplot(scale_alphas, aes(alpha)) +
  geom_vline(xintercept = c(0.7, 0.8, 0.9), linetype = "dotted") +
  geom_histogram(aes(y = ..density..), binwidth = 0.01,
                 fill = "#21908CFF") +
  stat_function(fun = extraDistr::dprop, size = 1,
                args = list(size = exp(beta_phi_intercept),
                            mean = plogis(beta_mu_intercept)))






domain <- "https://zis.gesis.org/"
zif <- read_html(str_c(domain))
scale_pages <- zif %>% html_nodes("a[href]") %>% html_attr("href")
scale_pages <- scale_pages[str_detect(scale_pages, "^/skala/openScale")]
scale_pages <- unique(scale_pages)


httr::POST("https://zis.gesis.org/kategorie/clickedAccordionLabel?selectedAccord=openGuetekrit&skalaId=268&lang=de", body = list(skalaId = 268), content_type = "application/json")


scale_alphas <- data.frame(scale=character(0), alpha = numeric(0))
for(i in seq_along(scale_pages)) {
  scale <- read_html(str_c(domain, scale_pages[i]))
  headings <- scale %>% html_nodes("td")
  alphas <- headings %>% html_text() %>%
    str_match(string = ., pattern = ".*(\\.\\d\\d).*")
  scales <- alphas[,1]
  alphas <- alphas[,2]
  scales <- scales[!is.na(alphas)]
  alphas <- alphas[!is.na(alphas)]
  scale_alphas <- rbind(scale_alphas, data.frame(scale = scales, alpha = as.numeric(alphas)))
}

scale_alphas <- distinct(scale_alphas)

ggplot(scale_alphas, aes(alpha)) +
  geom_histogram()
