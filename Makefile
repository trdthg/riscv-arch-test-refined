ACT_DIR = $(abspath ./riscv-arch-test)
rv64i-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/i/rv64i.cgf -bi rv64i -p$(shell nproc)

rv32i-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/i/rv32i.cgf -bi rv32i -p$(shell nproc)

.PHONY: rv64i-ctg
rv64i-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/i/rv64i.cgf -bi rv64i -p$(shell nproc)

rv64i-coverage:
	cd riscof-plugins/rv64 \
	&& time riscof coverage --config=config.ini \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--no-browser \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf \
		--cgf-file=$(ACT_DIR)/coverage/i/rv64i.cgf \
		--cgf-file=$(ACT_DIR)/coverage/priv/rv64i_priv.cgf \
		--cgf-file=$(ACT_DIR)/coverage/m/rv64im.cgf

rv64i-run:
	cd riscof-plugins/rv64 \
	&& time riscof run --config=config.ini \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env

rv32i-run:
	cd riscof-plugins/rv32 \
	&& time riscof run --config=config.ini \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env

thtst-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ \
		-cf $(ACT_DIR)/coverage/dataset.cgf \
		-cf $(ACT_DIR)/coverage/xthead/bs.cgf \         
		-bi rv64i -p$(shell nproc)

thtst-coverage:
	cd riscof-plugins/rv64_xthead_bs \
	&& time riscof coverage --config=config.ini \
		--filter=XTheadBs \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--no-browser \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf \
		--cgf-file=$(ACT_DIR)/coverage/i/rv64i.cgf \
		--cgf-file=$(ACT_DIR)/coverage/priv/rv64i_priv.cgf \
		--cgf-file=$(ACT_DIR)/coverage/xthead/bs.cgf


thtst-run:
	cd riscof-plugins/rv64_xthead_bs \
	&& time riscof run --config=config.ini \
		--filter=XTheadBs \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env

zalasr-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/zalasr/rv32zalasr.cgf -bi rv32i -p$(shell nproc)

zilsd-run:
	cd riscof-plugins/rv32_zilsd \
	&& time riscof run --config=config.ini \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env

zilsd-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/zilsd/rv32zilsd.cgf -bi rv32i -p$(shell nproc)

zilsd_priv-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/zilsd/rv32zilsd_priv.cgf -bi rv32i -p$(shell nproc)

svadu32-run:
	cd riscof-plugins/rv32_svadu \
	&& time riscof run --config=config.ini \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env

addi-run:
	cd riscof-plugins/rv64 \
	&& time riscof run --config=config.ini \
		--filter=/addi \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--testfile=$(ACT_DIR)/coverage/dataset.cgf \
		--testfile=$(ACT_DIR)/coverage/i/rv64i.cgf

addi-coverage:
	cd riscof-plugins/rv64 \
	&& time riscof coverage --config=config.ini \
		--filter=/addi \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--no-browser \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf \
		--cgf-file=$(ACT_DIR)/coverage/i/rv64i.cgf \
		--cgf-file=$(ACT_DIR)/coverage/priv/rv64i_priv.cgf \
		--cgf-file=$(ACT_DIR)/coverage/m/rv64im.cgf

compile:
	riscv64-unknown-elf-gcc 
		-march=rv64i
		-static
		-mcmodel=medany
		-fvisibility=hidden
		-nostdlib
		-nostartfiles
		-T $(ACT_DIR)/riscof-plugins/rv64/sail_cSim/env/link.ld
		-I $(ACT_DIR)/riscof-plugins/rv64/sail_cSim/env/
		-I $(ACT_DIR)/riscv-test-suite/env
		-mabi=lp64 
		$(ACT_DIR)/riscv-test-suite/rv64i_m/I/src/sra-01.S
		-o ref.elf
		-DTEST_CASE_1=True -DXLEN=64;
		
		riscv64-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV64  -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=$(ACT_DIR)/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sra-01.S/Reference-sail_c_simulator.signature ref.elf > sra-01.log 2>&1 \

sra-isac:
	cd riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sra-01.S \
	&& riscv64-unknown-elf-gcc -march=rv64i          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles         -T $(ACT_DIR)/riscof-plugins/rv64/sail_cSim/env/link.ld         -I $(ACT_DIR)/riscof-plugins/rv64/sail_cSim/env/         -I $(ACT_DIR)/riscv-test-suite/env -mabi=lp64  $(ACT_DIR)/riscv-test-suite/rv64i_m/I/src/sra-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=64;riscv64-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV64  -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=$(ACT_DIR)/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sra-01.S/Reference-sail_c_simulator.signature ref.elf > sra-01.log 2>&1 \
	&& riscv_isac --verbose info coverage -d \
		-t sra-01.log --parser-name c_sail -o coverage.rpt \
		--sig-label begin_signature  end_signature \
		--test-label rvtest_code_begin rvtest_code_end \
		-e ref.elf -c .$(ACT_DIR)/coverage/dataset.cgf \
		-c .$(ACT_DIR)/coverage/i/rv64i.cgf \
		-c .$(ACT_DIR)/coverage/priv/rv64i_priv.cgf \
		-c .$(ACT_DIR)/coverage/m/rv64im.cgf -x64 \
		-l sra

sraw-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/i/rv64i.cgf -bi rv64i --filter "sraw"

sraw-isac:
	cd riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sraw-01.S \
	&& riscv64-unknown-elf-gcc -march=rv64i          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles         -T $(ACT_DIR)/riscof-plugins/rv64/sail_cSim/env/link.ld         -I $(ACT_DIR)/riscof-plugins/rv64/sail_cSim/env/         -I $(ACT_DIR)/riscv-test-suite/env -mabi=lp64  $(ACT_DIR)/riscv-test-suite/rv64i_m/I/src/sraw-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=64;riscv64-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV64  -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=$(ACT_DIR)/riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sraw-01.S/Reference-sail_c_simulator.signature ref.elf > sraw-01.log 2>&1 \
	&& riscv_isac --verbose info coverage -d                         -t sraw-01.log --parser-name c_sail -o coverage.rpt                          --sig-label begin_signature  end_signature                         --test-label rvtest_code_begin rvtest_code_end                         -e ref.elf -c $(ACT_DIR)/coverage/dataset.cgf -c $(ACT_DIR)/coverage/i/rv64i.cgf -c $(ACT_DIR)/coverage/priv/rv64i_priv.cgf -c $(ACT_DIR)/coverage/m/rv64im.cgf -x64   -l sraw    ;

zacas-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/zacas/rv64zacas.cgf -bi rv64i
	cd tests && mv amocas.w-01.S amocas.q-01.S amocas.d_64-01.S $(ACT_DIR)/riscv-test-suite/rv64i_m/Zacas/src/
zacas-coverage:
	cd riscof-plugins/rv64_zacas \
	&& riscof coverage --filter='amocas' --config=config.ini \
		--no-browser \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf \
		--cgf-file=$(ACT_DIR)/coverage/zacas/rv64zacas.cgf

zfinx-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ \
		--flen 64 \
		-cf $(ACT_DIR)/coverage/dataset.cgf \
		-cf $(ACT_DIR)/coverage/cgfs_fext/RV64Zdinx/fcvt.d.l.cgf \
		-cf $(ACT_DIR)/coverage/cgfs_fext/RV64Zdinx/fcvt.d.lu.cgf \
		-cf $(ACT_DIR)/coverage/cgfs_fext/RV64Zdinx/fcvt.l.d.cgf \
		-cf $(ACT_DIR)/coverage/cgfs_fext/RV64Zdinx/fcvt.lu.d.cgf \
		-bi rv64i
	# cd tests && mv amocas.w-01.S amocas.q-01.S amocas.d_64-01.S $(ACT_DIR)/riscv-test-suite/rv64i_m/Zacas/src/

cmo-ctg:
	riscv_ctg -v debug -d $(ACT_DIR)/tests/ -cf $(ACT_DIR)/coverage/dataset.cgf -cf $(ACT_DIR)/coverage/cmo/cbom.cgf -cf $(ACT_DIR)/coverage/cmo/cbop.cgf -cf $(ACT_DIR)/coverage/cmo/cboz.cgf -bi rv64i -p$(shell nproc)

cmo-coverage:
	cd riscof-plugins/rv64_cmo \
	&& riscof coverage --filter='cbo|prefetch' --config=config.ini \
		--no-browser \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cmo/cbom.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cmo/cbop.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cmo/cboz.cgf

# TODO
cmo-run:
	cd riscof-plugins/rv64_cmo \
	&& riscof run --config=config.ini \
		--no-browser \
		--suite=$(ACT_DIR)/riscv-test-suite/ \
		--env=$(ACT_DIR)/riscv-test-suite/env \
		--testfile=$(ACT_DIR)/coverage/dataset.cgf \
		--testfile=$(ACT_DIR)/coverage/cmo/cbom.cgf \
		--testfile=$(ACT_DIR)/coverage/cmo/cbop.cgf \
		--testfile=$(ACT_DIR)/coverage/cmo/cboz.cgf

# cmo-run:
# 	cd riscof-plugins/rv64_cmo \
# 	&& riscof testlist --config=config.ini --suite=$(ACT_DIR)/riscv-test-suite/ --env=$(ACT_DIR)/riscv-test-suite/env \
# 	&& riscof run --config=config.ini --suite=$(ACT_DIR)/riscv-test-suite/ --env=$(ACT_DIR)/riscv-test-suite/env

cmo-isac:
	cd riscof-plugins/rv64_cmo/riscof_work/rv64i_m/CMO/src/cbo.clean-01.S \
	&& riscv64-unknown-elf-gcc -march=rv64izicbom_zicsr          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles         -T $(ACT_DIR)/riscof-plugins/rv64_cmo/sail_cSim/env/link.ld         -I $(ACT_DIR)/riscof-plugins/rv64_cmo/sail_cSim/env/         -I $(ACT_DIR)/riscv-test-suite/env -mabi=lp64  $(ACT_DIR)/riscv-test-suite/rv64i_m/CMO/src/cbo.clean-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=64;riscv64-unknown-elf-objdump -D ref.elf > ref.disass \
	&& riscv_sim_RV64  --enable-zicbom --enable-zicboz -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=$(ACT_DIR)/riscof-plugins/rv64_cmo/riscof_work/rv64i_m/CMO/src/cbo.clean-01.S/Reference-sail_c_simulator.signature ref.elf > cbo.clean-01.log 2>&1 \
	&& riscv_isac --verbose info coverage -d                         -t cbo.clean-01.log --parser-name c_sail -o coverage.rpt                          --sig-label begin_signature  end_signature                         --test-label rvtest_code_begin rvtest_code_end                         -e ref.elf -c $(ACT_DIR)/coverage/dataset.cgf -c $(ACT_DIR)/coverage/cmo/cbom.cgf -c $(ACT_DIR)/coverage/cmo/cbop.cgf -c $(ACT_DIR)/coverage/cmo/cboz.cgf -x64   -l cbo.clean    ;

cmo-prefetch:
	riscv64-unknown-elf-gcc -march=rv64izicbom_zicsr          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles         -T $(ACT_DIR)/riscof-plugins/rv64_cmo/sail_cSim/env/link.ld         -I $(ACT_DIR)/riscof-plugins/rv64_cmo/sail_cSim/env/         -I $(ACT_DIR)/riscv-test-suite/env -mabi=lp64  $(ACT_DIR)/riscv-test-suite/rv64i_m/CMO/src/cbo.clean-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=64;riscv64-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV64 --enable-zicbom --enable-zicboz --enable-zicbop -i -v --trace=step --pmp-count=16 --pmp-grain=0 --ram-size=8796093022208 --signature-granularity=8  --test-signature=$(ACT_DIR)/riscof-plugins/rv64_cmo/riscof_work/rv64i_m/CMO/src/cbo.clean-01.S/Reference-sail_c_simulator.signature ref.elf > cbo.clean-01.log 2>&1;
	riscv_isac --verbose info coverage -d \
		-t prefetch.i-01.log --parser-name c_sail -o coverage.rpt \
		--sig-label begin_signature  end_signature \
		--test-label rvtest_code_begin rvtest_code_end \
		-e ref.elf -c $(ACT_DIR)/coverage/dataset.cgf \
		-c $(ACT_DIR)/coverage/cmo/cbop.cgf -x64 -l prefetch.i;

zfh:
	cd riscof-plugins/rv32 \
	&& riscof coverage --config=config.ini \
		--suite=riscv-arch-test/riscv-test-suite/ \
		--env=riscv-arch-test/riscv-test-suite/env \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.d.h.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.h.d.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.h.s.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.s.h.cgf

test-sraw:
	$(MAKE) ctg-sraw
	test $(shell diff tests/sraw-01.S riscv-test-suite/rv64i_m/I/src/sraw-01.S | wc -l) = 4
	# $(MAKE) isac-sraw
	# tail riscof-plugins/rv64/riscof_work/rv64i_m/I/src/sraw-01.S/coverage.rpt

isac-zfh:
	cd riscof-plugins/rv32 \
	&& riscof coverage --filter='fcvt.d.h|fcvt.h.d|fcvt.h.s|fcvt.s.h' --config=config.ini \
		--no-browser \
		--suite=riscv-arch-test/riscv-test-suite/  --env=riscv-arch-test/riscv-test-suite/env     \
		--cgf-file=$(ACT_DIR)/coverage/dataset.cgf    \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.d.h.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.h.d.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.h.s.cgf \
		--cgf-file=$(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.s.h.cgf

demo:
	cd riscof-plugins/rv32/riscof_work/rv32i_m/D/src/fcvt.d.s_b1-01.S;riscv32-unknown-elf-gcc -march=rv32ifd_zicsr          -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -T $(ACT_DIR)/riscof-plugins/rv32/sail_cSim/env/link.ld                -I $(ACT_DIR)/riscof-plugins/rv32/sail_cSim/env/                -I $(ACT_DIR)/riscv-test-suite/env -mabi=ilp32  $(ACT_DIR)/riscv-test-suite/rv32i_m/D/src/fcvt.d.s_b1-01.S -o ref.elf -DTEST_CASE_1=True -DXLEN=32 -DFLEN=64;riscv32-unknown-elf-objdump -D ref.elf > ref.disass;riscv_sim_RV32  -i -v --trace=step  --pmp-count=16 --pmp-grain=0  --test-signature=$(ACT_DIR)/riscof-plugins/rv32/riscof_work/rv32i_m/D/src/fcvt.d.s_b1-01.S/Reference-sail_c_simulator.signature ref.elf > fcvt.d.s_b1-01.log 2>&1;riscv_isac --verbose info coverage -d                         -t fcvt.d.s_b1-01.log --parser-name c_sail -o coverage.rpt                          --sig-label begin_signature  end_signature                         --test-label rvtest_code_begin rvtest_code_end                         -e ref.elf -c $(ACT_DIR)/coverage/dataset.cgf -c $(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.d.h.cgf -c $(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.h.d.cgf -c $(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.h.s.cgf -c $(ACT_DIR)/coverage/cgfs_fext/RV32H/rv32h_fcvt.s.h.cgf -x32   -l fcvt.d.s_b1    ;
