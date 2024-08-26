libs = c(
  'hubUtils', 'hubEnsembles', 'hubValidations',
  'hubAdmin', 'hubData'
)
invisible(lapply(libs, require, character.only=TRUE))

# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubUtils")
# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubEnsembles")
# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubValidations")
# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubAdmin")
# remotes::install_github("Infectious-Disease-Modeling-Hubs/hubData")

HUB_PATH = '.'
###############################################################################
# Validate config file 
###############################################################################
validate_config(
  hub_path=HUB_PATH,
  config=c("admin"),
  config_path=NULL,
  schema_version="from_config",
  branch="main"
)
###############################################################################
# Validate tasks
###############################################################################
validate_config(
  hub_path=HUB_PATH,
  config=c("tasks"),
  config_path=NULL,
  schema_version="from_config",
  branch="main"
)
###############################################################################
# Validate Model YML files
###############################################################################
# Validate all YML files ------------------------------------------------------
details = file.info(list.files(path="./model-metadata", pattern="*.yml"))
details = details[with(details, order(as.POSIXct(mtime))), ]
cFiles = rownames(details)
sapply(cFiles, hubValidations::validate_model_metadata, hub_path='.')
# Examine individual file -----------------------------------------------------
file_path = 'CDPH-VBDS.yml'
hubValidations::validate_model_metadata(
  file_path=file_path,
  hub_path=HUB_PATH
)
###############################################################################
# Validate Submissions
###############################################################################
# Validate full CSV set -------------------------------------------------------
details = file.info(list.files(
  path="./model-output", pattern="*-*-*.csv", recursive=TRUE
))
details = details[with(details, order(as.POSIXct(mtime))), ]
cFiles = rownames(details)
# print(cFiles)
sapply(cFiles, hubValidations::validate_submission, hub_path='.')
# Examine individual files ----------------------------------------------------
file_path = "/CDPH-VBDS/2024-08-31-CDPH-VBDS.csv"
hubValidations::validate_submission(
  file_path=file_path,
  hub_path=HUB_PATH
)
# read_model_out_file(file_path)
###############################################################################
# Count Submissions
###############################################################################
folder = "/data/home/CDPHINTRA.CA.GOV/hsanchez/wnvca-2024/model-output/"
files = list.files(
  folder, pattern=".", 
  all.files=FALSE, recursive=TRUE, full.names=TRUE
)
length(files)
dir_list = split(files, dirname(files))
files_in_folder = sapply(dir_list, length)
files_in_folder

