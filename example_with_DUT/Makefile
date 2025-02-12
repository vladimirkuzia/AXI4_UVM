GUI=
test=
opts=

sim: ## Run simualtion (test="test name", GUI="1 or 0")
	@clear 
	@mkdir sdf || true 
	@source ./env.sh \
		&& gui=$(GUI) \
		&& test=$(test) \
		&& opts=$(opts) \
		&& source ./run.sh

clean: ## Delete unnecessary files
	@rm -rf ./cov_work/scope || true
	@rm -rf ./run_dir/ || true
	@rm -rf *.log || true
	@rm -rf waves.shm || true
	@rm -rf *shm || true
	@rm -rf .simvision || true
	@rm -rf irun.key || true
	@rm -rf *.diag || true
	@rm -rf iccr.log || true
	@rm -rf *.txt || true
	@rm -rf *.history || true
	@rm -rf *.elog || true
	@rm -rf *.ecom || true
	@rm -rf extract || true
	@rm -rf .iev_lock || true

kill: ## Close xrun/irun processes
	@bash ./kns.sh

#//
#//===============================================================
#//              Your macros for running tests
#//===============================================================
#//

AXI_test: #N 'make sim test=spi_test_1' / to view the coverage 'make iccr test=spi_test_1'
	@make sim test=AXI4_test_1