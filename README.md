# BST 270 Course Individual Project - Reproducing Figures from FiveThirtyEight Police Settlement Article

# BST 270: Individual Project

In this repository is my attempt to reproduce some of the figures from
FiveThirtyEight's [Cities Spend Millions On Police Misconduct Every
Year. Here’s Why It’s So Difficult to Hold Departments
Accountable.](https://fivethirtyeight.com/features/police-misconduct-costs-cities-millions-every-year-but-thats-where-the-accountability-ends/).

## Environment

The R programming language was used to conduct this project. The
packages used for this project are managed through CRAN and exact
versions are described using the sessionInfo() listed below.
Additionally, a Conda environment can be created using the provided
`environment.yml` file:

```{bash}
conda env create -f environment.yml
```

## Project Structure

The main codes used for this analysis are in the parent directory in two
formats: (1) as a Quarto file `main_policesettlements_quarto.qmd` or
alternatively, (2) an Rmd file `main_rmd_policesettlements.Rmd`. These
files can be compiled through the command line or on IDEs like RStudio.

These files above call the helper functions made for each of the figures
used in this reproduction analysis. The attempt to reproduce the figures
from the linked article for each figure are available at
`./helper_functions` folder.

Images of the original plots is also provided in the `./original`
directory.

The plots that have been produced by the code shared in this repository
can be compared and accessible in the `./plots` folder.

Additionally, the knitted outputs obtained are located in the parent
directory as a html or pdf file.

### Getting Started

1.  Clone the GitHub repository.

2.  Option 1: Open the `.rmd` file in R Studio or Option 2: Open the
    quarto file in R studio. Note, make sure to install the R packages,
    as described in the environment.yml file or as listed in the
    sessionInfo() copied below.

    `sessionInfo() R version 4.4.2 (2024-10-31) Platform: aarch64-apple-darwin20 Running under: macOS Sonoma 14.5`

    `Matrix products: default BLAS: /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib; LAPACK version 3.12.0`

    `locale: [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8`

    `time zone: America/New_York tzcode source: internal`

    `attached base packages: [1] stats graphics grDevices datasets utils methods base`

    `other attached packages: [1] tinytex_0.54 scales_1.3.0 here_1.0.1 this.path_2.6.0 tidylog_1.1.0 [6] plyr_1.8.9 lubridate_1.9.4 forcats_1.0.0 dplyr_1.1.4 purrr_1.0.2 [11] readr_2.1.5 tibble_3.2.1 tidyverse_2.0.0 readxl_1.4.3 stringr_1.5.1 [16] tidyr_1.3.1 ggplot2_3.5.1`

    `loaded via a namespace (and not attached): [1] sass_0.4.9 generics_0.1.3 renv_1.0.11 stringi_1.8.4 hms_1.1.3 [6] digest_0.6.37 magrittr_2.0.3 evaluate_1.0.3 grid_4.4.2 timechange_0.3.0 [11] fastmap_1.2.0 cellranger_1.1.0 rprojroot_2.0.4 jsonlite_1.8.9 jquerylib_0.1.4 [16] cli_3.6.3 rlang_1.1.5 munsell_0.5.1 withr_3.0.2 cachem_1.1.0 [21] yaml_2.3.10 tools_4.4.2 tzdb_0.4.0 colorspace_2.1-1 vctrs_0.6.5 [26] R6_2.5.1 lifecycle_1.0.4 clisymbols_1.2.0 pkgconfig_2.0.3 pillar_1.10.1 [31] bslib_0.8.0 gtable_0.3.6 glue_1.8.0 Rcpp_1.0.14 xfun_0.50 [36] tidyselect_1.2.1 rstudioapi_0.17.1 knitr_1.49 htmltools_0.5.8.1 rmarkdown_2.29 [41] compiler_4.4.2`

3.  Click "Preview" or "Run" to execute, or if loaded the conda
    environment, can run the rmarkdown via terminal using 
    `R -e "rmarkdown::render('main_rmd_policesettlements.Rmd')"`

## Data

The data set used to reproduce the figures for this analysis is provided
at `./data/processed`, containing csv files corresponding to the
preprocessed data for each city, as there was varied organization and
fields for each city's dataset. For this particular reproduction
analysis, the preprocessed data has been copied into one folder, and
there is an additional folder containing the intermediate data files
that were cleaned, where cleaning steps are provided in generating the
figure 1 with script located in `./helper_functions`. However the
preprocessing steps that were performed separately for each city's data
sheet is provided on the original [FiveThirtyEight
GitHub](https://github.com/fivethirtyeight/police-settlements/). The
data that has been copied into this repository stores the files from the
final folder in each of the respective city folders from the original
GitHub. Further data cleaning was performed to match elements across
datasets in order to generate the final figures.

The general description for each of the variables is provided below and
copied from the original [FiveThirtyEight
GitHub]('https://github.com/fivethirtyeight/police-settlements/blob/main/README.md?plain=1').
However, note that each file per city has some variation in defining
closed_date, amount_awarded, calendar_year, and summary_allegations,
among other variables. See the general descriptions copied from original GitHub below.

| Variable | Definition |
|---------------------------|---------------------------------------------|
| incident_date | Date on which incident took place |
| incident_year | Pulled from filed_year |
| filed_date | Date claim or lawsuit was filed |
| filed_year | Pulled from filed_date |
| closed_date | Date at which settlement was reached OR paid (depending on what was provided) |
| calendar_year | Pulled from settlement date or closed_date |
| city | City name |
| state | State abbreviation |
| amount_awarded | Amount awarded to claimant in the settlement |
| other_expenses | Additional expenses, such as legal fees (e.g. in Charleston, North Charleston), when available |
| total_incurred | Total expenses: amount_awarded + other_expenses |
| collection | Whether money was collected? |
| case_outcome | Case status as of the date the data was collected, e.g. whether a case was settled, went to jury, or is still pending |
| docket_number | Case docket number, when available |
| claim_number | Claim number, when available |
| court | Court in which the settlement was reached, when available |
| plaintiff_name | Name of plaintiff/claimant |
| matter_name | Case name (generally of the form "Plaintiff v Defendant") |
| plaintiff_attorney | Legal representation of plaintiff |
| location | Location at which the incident happened, when available |
| summary_allegations | Description of allegations -- sometimes aggregated into categories, sometimes very detailed. We retained as much detail as was available. Separated by ";" |
| claim_or_lawsuit | Indicator of whether the entry was a claim or a lawsuit, when available |
| defendant | Name of defendant(s), when available. Sometimes a list of police officers was provided separately. |

### Original data sources

The article describes that the data provided was from the police
department from each of the cities in this study. As the study
describes, many of the data files were not fully complete for the time
period 2010-2019 (in most cases although there is some variation with
inclusion of 2020 or around this time period based on city). The authors
of this study noted that partly due to the differences in available data
and organization across the city police departments, they would not
advise comparing trends between cities, and the plots they generate
convey some of the possible misrepresentations that can result from
these types of comparisons.
