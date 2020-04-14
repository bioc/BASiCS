context("Methods")

test_that("show", {
  data(ChainSC)
  data(ChainSCReg)
  expect_output(show(ChainSC), "An object of class BASiCS_Chain")
  expect_output(show(ChainSCReg), "An object of class BASiCS_Chain")
  expect_output(show(Summary(ChainSC)), "An object of class BASiCS_Summary")
  d <- BASiCS_TestDE(ChainSCReg, ChainSCReg)
  expect_output(show(d), "An object of class BASiCS_ResultsDE, containing")
  v <- BASiCS_DetectHVG(ChainSCReg)
  expect_output(show(v), "An object of class BASiCS_ResultVG.")
})

test_that("subset", {
  data(ChainSC)
  data(ChainSCReg)
  sc <- subset(
    ChainSC,
    Genes = rownames(ChainSC)[1:3],
    Cells = colnames(ChainSC)[1:2],
    Iterations = 1:10
  )
  expect_equal(dim(sc@parameters$mu), c(10, 3))
  expect_equal(dim(sc@parameters$nu), c(10, 2))
  sc <- subset(
    ChainSCReg,
    Genes = rownames(ChainSC)[1:3],
    Cells = colnames(ChainSC)[1:2],
    Iterations = 1:10
  )
  expect_equal(dim(sc@parameters$epsilon), c(10, 3))
  expect_equal(dim(sc@parameters$nu), c(10, 2))
})

test_that("dimnames", {
  data(ChainSC)
  expect_equal(colnames(ChainSC), colnames(ChainSC@parameters$nu))
  expect_equal(rownames(ChainSC), colnames(ChainSC@parameters$mu))
  expect_equal(dimnames(ChainSC), list(rownames(ChainSC), colnames(ChainSC)))
})

test_that("subsets for BASiCS_ResultsDE", {
  data(ChainSC)
  data(ChainSCReg)
  d <- BASiCS_TestDE(ChainSCReg, ChainSCReg)
  g <- d[[1]]@Table$GeneName[1:10]
  ds <- d[g, ]
  expect_equal(ds[[1]]@Table, d[[1]]@Table[1:10, ])
})