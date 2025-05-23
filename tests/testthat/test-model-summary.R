# Define files to be tested -----------------------------------------------
software <- 'nonmem'
model    <- xpdb_ex_pk$code
model2   <- model[0, ]

## Special model for testing conditional number
model3 <- structure(list(
  problem = c(3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0), 
  level = c(34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 36, 37, 37), 
  subroutine = c("lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "lst", "oth", "oth", "oth"), 
  code = c("1", " ************************************************************************************************************************", 
           " ******************** ********************", " ******************** FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION ********************", 
           " ******************** EIGENVALUES OF COR MATRIX OF ESTIMATE ********************", 
           " ******************** ********************", " ************************************************************************************************************************", 
           " 1 2 3 4 5 6 7 8 9 10 11 12", " 13 14 15 16 17 18 19 20 21 22 23 24", 
           " 25", " 8.65E-02 1.33E-01 1.92E-01 2.31E-01 2.72E-01 3.00E-01 3.39E-01 4.20E-01 5.69E-01 5.81E-01 6.53E-01 7.52E-01", 
           " 7.61E-01 9.33E-01 9.54E-01 9.99E-01 1.12E+00 1.18E+00 1.28E+00 1.48E+00 1.61E+00 1.72E+00 2.19E+00 2.57E+00", 
           " 3.68E+00", "1", " ************************************************************************************************************************", 
           " ******************** ********************", " ******************** FIRST ORDER CONDITIONAL ESTIMATION WITH INTERACTION ********************", 
           " ******************** EIGENVALUES OF COR MATRIX OF ESTIMATE ********************", 
           " ******************** ********************", " ************************************************************************************************************************", 
           " 1 2 3 4 5 6 7 8 9 10 11 12", " 13 14 15 16 17 18 19 20 21", 
           " 7.61E-03 4.44E-02 4.82E-02 6.23E-02 1.12E-01 2.08E-01 2.69E-01 3.57E-01 3.93E-01 5.83E-01 5.96E-01 8.08E-01", 
           " 9.21E-01 9.59E-01 1.04E+00 1.32E+00 1.50E+00 2.20E+00 2.52E+00 3.08E+00 3.97E+00", 
           " 1 2 3 4 5 6 7 8 9 10 11 12", " 13 14 15 16 17 18 19 20 21 22 23 24", 
           " 25", " 8.65E-02 1.33E-01 1.92E-01 2.31E-01 2.72E-01 3.00E-01 3.39E-01 4.20E-01 5.69E-01 5.81E-01 6.53E-01 7.52E-01", 
           " 7.61E-05 9.33E-01 9.54E-01 9.99E-01 1.12E+00 1.18E+00 1.28E+00 1.48E+00 1.61E+00 1.72E+00 2.19E+00 2.57E+00", 
           " 3.68E+10", "1", " #CPUT: Total CPU Time in Seconds, 6.040", 
           "Stop Time:", "Mon Oct 16 13:34:35 CEST 2017"), 
  comment = c("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Add non-consecutive values in eigen value format to test parser", "", "", "", "", "", "", "", "", "")
), row.names = c(NA, -34L), class = c("nm_model", "tbl_df", "tbl", "data.frame"), file  = "run001.lst", dir = "data", software = "nonmem")

model3 <- dplyr::bind_rows(slice(xpdb_ex_pk$code, 1:(nrow(xpdb_ex_pk$code) - 3)), model3)


file     <- 'pk/model/run001.lst'
rounding <- 2

sum_out <- function(sum_fun, prob = 1) {
  as.character(sum_fun[prob, c('label', 'value')])
}

# Handle differences across R versions
eta_shk_string <- ifelse(getRversion() >= "4.0.0", 
                         yes = "9.33 [1], 28.72 [2], 23.65 [3]",
                         no  = "9.33 [1], 28.71 [2], 23.65 [3]")

# Tests start here --------------------------------------------------------

test_that('summary is properly created with the appropriate information', {
  expect_equal(sum_out(sum_software(software)), c('software', 'nonmem'))
  
  expect_equal(sum_out(sum_version(model, software)), c('version', '7.3.0'))
  
  expect_equal(sum_out(sum_file(file)), c('file', 'run001.lst'))
  
  expect_equal(sum_out(sum_run(file)), c('run', 'run001'))
  
  expect_equal(sum_out(sum_directory(file)), c('dir', 'pk/model'))
  
  expect_equal(sum_out(sum_reference(model, software)), c('ref', '000'))
  
  expect_equal(sum_out(sum_probn(model, software), 1), c('probn', '1'))
  expect_equal(sum_out(sum_probn(model, software), 2), c('probn', '2'))
  
  expect_equal(sum_out(sum_timestart(model, software)), c('timestart', 'Mon Oct 16 13:34:28 CEST 2017'))
  
  expect_equal(sum_out(sum_timestop(model, software)), c('timestop', 'Mon Oct 16 13:34:35 CEST 2017'))
  
  expect_equal(sum_out(sum_description(model, software)), c('descr', 'NONMEM PK example for xpose'))
  
  expect_equal(sum_out(sum_label(model, software), 1), c('label', 'Parameter estimation'))
  expect_equal(sum_out(sum_label(model, software), 2), c('label', 'Model simulations'))
  
  expect_equal(sum_out(sum_input_data(model, software), 1), c('data', '../../mx19_2.csv'))
  expect_equal(sum_out(sum_input_data(model, software), 2), c('data', '../../mx19_2.csv'))
  
  expect_equal(sum_out(sum_nobs(model, software), 1), c('nobs', '476'))
  expect_equal(sum_out(sum_nobs(model, software), 2), c('nobs', '476'))
  
  expect_equal(sum_out(sum_nind(model, software), 1), c('nind', '74'))
  expect_equal(sum_out(sum_nind(model, software), 2), c('nind', '74'))
  
  expect_equal(sum_out(sum_nsim(model, software)), c('nsim', '20'))
  
  expect_equal(sum_out(sum_simseed(model, software)), c('simseed', '221287'))
  
  expect_equal(sum_out(sum_subroutine(model, software)), c('subroutine', '2'))
  
  expect_equal(sum_out(sum_runtime(model, software)), c('runtime', '00:00:02'))
  
  expect_equal(sum_out(sum_covtime(model, software)), c('covtime', '00:00:03'))
  
  expect_equal(sum_out(sum_term(model, software)), c('term', 'MINIMIZATION SUCCESSFUL'))
  
  expect_equal(sum_out(sum_warnings(model, software), 1), c('warnings', '(WARNING 2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.'))
  expect_equal(sum_out(sum_warnings(model, software), 2), c('warnings', '(WARNING 2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.\n(WARNING 22) WITH $MSFI AND \"SUBPROBS\", \"TRUE=FINAL\" ...'))
  
  #expect_equal(sum_out(sum_errors(model, software)), c('errors', 'na'))
  
  expect_equal(sum_out(sum_nsig(model, software)), c('nsig', '3.3'))
  
  expect_equal(sum_out(sum_condn(model3, software, rounding), 1), c('condn', '21.5'))
  expect_equal(sum_out(sum_condn(model3, software, rounding), 2), c('condn', '42.54'))
  expect_equal(sum_out(sum_condn(model3, software, rounding), 3), c('condn', '521.68'))
  
  #expect_equal(sum_out(sum_nesample(model, software)), c('nesample', 'na'))
  
  #expect_equal(sum_out(sum_esampleseed(model, software)), c('esampleseed', 'na'))
  
  expect_equal(sum_out(sum_ofv(model, software)), c('ofv', '-1403.905'))
  
  expect_equal(sum_out(sum_method(model, software), 1), c('method', 'foce-i'))
  expect_equal(sum_out(sum_method(model = dplyr::tibble(problem = 1L, level = 1L, subroutine = 'est', 
                                                        code = 'METH=0', comment = ''), software), 1), c('method', 'fo'))
  expect_equal(sum_out(sum_method(model, software), 2), c('method', 'sim'))
  
  expect_equal(sum_out(sum_shk(model, software, 'eps', rounding)), c('epsshk', '14.86 [1]'))
  expect_equal(sum_out(sum_shk(model, software, 'eta', rounding)), c('etashk', eta_shk_string))
})

test_that('summary default summary is returned for missing information', {
  expect_equal(sum_out(sum_version(model2, software)), c('version', 'na'))
  
  expect_equal(sum_out(sum_reference(model2, software)), c('ref', 'na'))
  
  expect_equal(sum_out(sum_probn(model2, software)), c('probn', 'na'))
  
  expect_equal(sum_out(sum_timestart(model2, software)), c('timestart', 'na'))
  
  expect_equal(sum_out(sum_timestop(model2, software)), c('timestop', 'na'))
  
  expect_equal(sum_out(sum_description(model2, software)), c('descr', 'na'))
  
  expect_equal(sum_out(sum_label(model2, software)), c('label', 'na'))
  
  expect_equal(sum_out(sum_input_data(model2, software)), c('data', 'na'))
  
  expect_equal(sum_out(sum_nobs(model2, software)), c('nobs', 'na'))
  
  expect_equal(sum_out(sum_nind(model2, software)), c('nind', 'na'))
  
  expect_equal(sum_out(sum_nsim(model2, software)), c('nsim', 'na'))
  
  expect_equal(sum_out(sum_simseed(model2, software)), c('simseed', 'na'))
  
  expect_equal(sum_out(sum_subroutine(model2, software)), c('subroutine', 'na'))
  
  expect_equal(sum_out(sum_runtime(model2, software)), c('runtime', 'na'))
  
  expect_equal(sum_out(sum_covtime(model2, software)), c('covtime', 'na'))
  expect_equal(sum_out(sum_covtime(model = dplyr::tibble(problem = 1L, level = 1L, subroutine = 'lst', 
                                                         code = 'Elapsed covariance time in seconds: ********', 
                                                         comment = ''), software), 1), c('covtime', 'na'))
  
  expect_equal(sum_out(sum_term(model2, software)), c('term', 'na'))
  
  expect_equal(sum_out(sum_warnings(model2, software)), c('warnings', 'na'))
  
  expect_equal(sum_out(sum_errors(model2, software)), c('errors', 'na'))
  
  expect_equal(sum_out(sum_nsig(model2, software)), c('nsig', 'na'))
  
  expect_equal(sum_out(sum_condn(model2, software, rounding)), c('condn', 'na'))
  
  expect_equal(sum_out(sum_nesample(model2, software)), c('nesample', 'na'))
  
  expect_equal(sum_out(sum_esampleseed(model2, software)), c('esampleseed', 'na'))
  
  expect_equal(sum_out(sum_ofv(model2, software)), c('ofv', 'na'))
  
  expect_equal(sum_out(sum_method(model2, software)), c('method', 'na'))
  
  expect_equal(sum_out(sum_shk(model2, software, 'eps', rounding)), c('epsshk', 'na'))
  expect_equal(sum_out(sum_shk(model2, software, 'eta', rounding)), c('etashk', 'na'))
})

test_that("Termination messages are parsed when minimization is terminated",{
  
  relevant_lst_part <- "#TERM:
0MINIMIZATION TERMINATED
 DUE TO PROXIMITY OF NEXT ITERATION EST. TO A VALUE
 AT WHICH THE OBJ. FUNC. IS INFINITE
0AT THE LAST COMPUTED INFINITE VALUE OF THE OBJ. FUNCT.:
 ERROR IN NCONTR WITH INDIVIDUAL       1   ID= 1.00000000000000E+00
 NUMERICAL HESSIAN OF OBJ. FUNC. FOR COMPUTING CONDITIONAL ESTIMATE
 IS NON POSITIVE DEFINITE
 THETA=
  2.79E+00   1.04E-02   4.38E-02   1.90E-01   1.69E+00   1.02E+00   0.00E+00   0.00E+00   0.00E+00   0.00E+00
  0.00E+00   0.00E+00   0.00E+00   0.00E+00  -1.00E+00   0.00E+00  -7.84E-01  -1.13E+00   1.57E+00  -9.40E-01
 -9.05E-01  -7.71E-01  -8.34E-01  -1.43E+00   7.66E-01  -6.55E-01  -8.89E-01   5.02E-01  -9.12E-01  -9.84E-01
 -2.27E+00  -7.53E-01  -8.85E-01  -1.04E+00  -7.16E-01  -4.04E-01  -6.25E+00  -1.15E+00

 NO. OF FUNCTION EVALUATIONS USED:     5329
 NO. OF SIG. DIGITS UNREPORTABLE

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
" 
  expected_result <- tibble::tibble(problem = 1, subprob = 0, label = 'term', value = "MINIMIZATION TERMINATED\nDUE TO PROXIMITY OF NEXT ITERATION EST. TO A VALUE\nAT WHICH THE OBJ. FUNC. IS INFINITE\n0AT THE LAST COMPUTED INFINITE VALUE OF THE OBJ. FUNCT.:\nERROR IN NCONTR WITH INDIVIDUAL       1   ID= 1.00000...\nNUMERICAL HESSIAN OF OBJ. FUNC. FOR COMPUTING CONDITI...\nIS NON POSITIVE DEFINITE\nTHETA=\n2.79E+00   1.04E-02   4.38E-02   1.90E-01   1.69E+00 ...\n0.00E+00   0.00E+00   0.00E+00   0.00E+00  -1.00E+00 ...\n-9.05E-01  -7.71E-01  -8.34E-01  -1.43E+00   7.66E-01...\n-2.27E+00  -7.53E-01  -8.85E-01  -1.04E+00  -7.16E-01...\n")
  model <- tibble::tibble(problem = 1, level = 60, subroutine = 'lst', code = unlist(stringr::str_split(relevant_lst_part, "\\n")), comment = "")
  expect_equal(sum_term(model, "nonmem"), expected_result)
})

