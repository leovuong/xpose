# Inspired from ggplot2 ggsave tests
# Define plots to be tested -----------------------------------------------

plot <- dv_vs_ipred(xpdb = xpdb_ex_pk, type = "p", quiet = TRUE)

plot_multiple <- dv_vs_ipred(xpdb = xpdb_ex_pk, type = "p", quiet = TRUE, facets = c('SEX', 'MED1'), ncol = 1, nrow = 1, page = 1:2)

# Tests start here --------------------------------------------------------

test_that('errors are returned for bad plot input', {
  expect_error(xpose_save(plot = NULL), regexp = 'Argument `plot` required')
})

test_that('errors are returned for bad filename input', {
  local_edition(3)
  local_reproducible_output()

  paths_1 <- file.path(tempdir(), paste0('test_plot', c('.abcd', '.bcde', '', '.pdf', '.png')))
  on.exit(unlink(paths_1), add = TRUE)

  # Missing filename
  expect_snapshot(xpose_save(plot = plot), error = TRUE)

  # Unrecognized extension
  expect_snapshot(xpose_save(plot = plot, file = paths_1[1]), error = TRUE)
  
  # Missing extension
  # Note: Now outputs the temp directory in the error and this does not play well with snapshots.
  #       In general this function is only a wrapper around ggsave and these filename issues 
  #       should be properly handled by ggplot2 so it is acceptable to relax the xpose tests.
  # expect_snapshot(xpose_save(plot = plot, file = paths_1[3]), error = TRUE)

  # Length filename > 1
  # Note: No longer an error
  # expect_warning(xpose_save(plot = plot, file = paths_1[4:5]),
  #              regexp = 'Only the first')
})


test_that('common graphical device work properly', {
  paths_2 <- file.path(tempdir(), paste0('test_plot.', c('pdf', 'jpeg', 'png')))
  on.exit(unlink(paths_2))
  
  expect_false(any(file.exists(paths_2)))
  
  # Test pdf
  xpose_save(plot = plot, file = paths_2[1])
  expect_true(file.exists(paths_2[1]))
  
  # Test jpeg
  if (capabilities('jpeg')) {
    xpose_save(plot = plot, file = paths_2[2], dpi = 20) # jpeg
    expect_true(file.exists(paths_2[2]))
  }
  
  # Test png
  if (capabilities('png')) {
    xpose_save(plot = plot, file = paths_2[3], dpi = 20) # png
    expect_true(file.exists(paths_2[3]))
  }
})

test_that('template filenames and auto file extension work properly', {
  paths_3 <- file.path(tempdir(), 'run001_dv_vs_ipred.pdf') 
  on.exit(unlink(paths_3))
  
  expect_false(file.exists(paths_3))
  
  xpose_save(plot = plot, 
             file = '@run_@plotfun',
             dir = tempdir(),
             device = 'pdf')
  expect_true(file.exists(paths_3))
})

test_that('mutlitple pages are properly saved', {
  paths_4 <- file.path(tempdir(), 'run001_dv_vs_ipred.pdf') 
  on.exit(unlink(paths_4))
  
  expect_false(file.exists(paths_4))
  
  xpose_save(plot = plot_multiple, 
             file = '@run_@plotfun',
             dir = tempdir(),
             device = 'pdf')
  expect_true(file.exists(paths_4))
})
