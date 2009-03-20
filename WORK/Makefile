######################################################################
##                HEADER RECOGNIZER TOP TESTBENCH
##
##
## Description: Baseline Makefile
##
## Switches:
##
#######################################################################

VCS_HOME = $(shell getwrappervar vcs VCS_HOME)

## Verdi paths
DEBUSSY_HOME = /tools/novas/debussy/2009.01
DEBUSSY_PLI  = -P /tools/novas/Debussy/2009.01/share/PLI/.vcsd2008.12/LINUX/vcsd.tab
DEBUSSY_LIB  = /tools/novas/Debussy/2009.01/share/PLI/.vcsd2008.12/LINUX/pli.a
#DEBUSSY_HOME = /tools/novas/debussy/2008.01
#DEBUSSY_PLI  = /tools/novas/Debussy/2008.01/share/PLI/vcsd2006.06/LINUX/vcsd.tab
#DEBUSSY_LIB  = /tools/novas/Debussy/2008.01/share/PLI/vcsd2006.06/LINUX/pli.a

## Teal/Truss paths
TEAL_HOME  = ${PROJ_DIR}/dv/lib/teal
TRUSS_HOME = ${PROJ_DIR}/dv/lib/truss
TRUSS_SRC  = ${TRUSS_HOME}/src

## Synopsys paths
DESIGNWARE_HOME   = /home/solarflare/technology/ipcores/synopsys/designwarehome
SYNOPSYS_PCIE_DIR = ${DESIGNWARE_HOME}/vip/pcie/latest
SYNOPSYS_VMT_DIR  = ${DESIGNWARE_HOME}/vip/vmt/3.00a
SYNOPSYS_PCIE_VERA_INC_DIR = ${SYNOPSYS_PCIE_DIR}/pcie_txrx_vmt/vera/include
SYNOPSYS_PCIE_VERA_SRC_DIR = ${SYNOPSYS_PCIE_DIR}/pcie_txrx_vmt/vera/src

BASE_DIR     = ${PROJ_DIR}/dv/tb/comm
COMMON_DIR   = ${PROJ_DIR}/dv/common
DRV_DIR      = ${PROJ_DIR}/dv/tb/drivers
DM_DIR       = ${PROJ_DIR}/dv/tb/dutmodel
INTF_DIR     = ${PROJ_DIR}/dv/tb/intf
NOTIFY_DIR   = ${PROJ_DIR}/dv/tb/notify
RBUILD_DIR   = ${PROJ_DIR}/dv/share/regdef/generated/${PLATFORM}
RDEF_DIR     = ${PROJ_DIR}/dv/share/regdef
SCENARIO_DIR = ${PROJ_DIR}/dv/tb/tests/scenario
TEST_DIR     = ${PROJ_DIR}/dv/tb/tests
TCASE_DIR    = ${PROJ_DIR}/dv/tb/tests/tcase
TCOM_DIR     = ${PROJ_DIR}/dv/tb/tests/common
XACT_DIR     = ${PROJ_DIR}/dv/tb/xactors

## local stuff
BENCH_DIR    = ${PROJ_DIR}/dv/blk/prsr_disp/mips/MIPS_ver/TESTBENCH
RTL_DIR      = ${PROJ_DIR}/dv/blk/prsr_disp/mips/MIPS_ver/RTL


BASE_INC_FILES = \

BENCH_INC_FILES =  \

XACT_INC_FILES = \

BENCH_FILES = \
  ${BENCH_DIR}/Memory.v \
  ${BENCH_DIR}/stim.v \
  ${BENCH_DIR}/testbench.v

NOTIFY_FILES = \

RTL_FILES = \
   ${RTL_DIR}/bob.v  \
   ${RTL_DIR}/alu.v \
   ${RTL_DIR}/branch_unit.v \
   ${RTL_DIR}/decode_stage.v \
   ${RTL_DIR}/fetch_stage.v \
   ${RTL_DIR}/execute_stage.v \
   ${RTL_DIR}/memory_stage.v \
   ${RTL_DIR}/wback_stage.v \
   ${RTL_DIR}/mips_top.v


XACT_FILES = \

INTF_FILES = \

TCASE_FILES = \

INC_FILES = \
	${BENCH_INC_FILES} \
	${BASE_INC_FILES} \
	${XACT_INC_FILES}

TB_SV_FILES = \
	${BASE_FILES} \
	${NOTIFY_FILES} \
	${XACT_FILES} \
	${RTL_FILES} \
	${BENCH_FILES}

# Compile Exclusion options
COMP_EXCLUDE_FLAGS += \
	+define

# Synopsys PCIE BFM Related Compile Flags
PLATFORM_FLAGS += \
	-timescale=1ns/1ns

COMP_FLAGS = \
        -o ./build/simv \
	-l ./build/vcs.hr.log \
	+vcs+lic+wait \
	+v2k \
	-V \
	+vcs+flush+log \
	-sverilog \
	-debug_all \
	-ntb_opts dtm \
	+libext+.v \
	+systemverilogext+.sv \
	+systemverilogext+.svh \
	+vcsd \
	+vpi \
	+memcbk \
	${DEBUSSY_PLI} ${DEBUSSY_LIB} \
	+define+PURE=extern \
	+define+ASSERT_ON \
	+incdir+${VCS_HOME}/packages/sva \
	-y ${VCS_HOME}/packages/sva \
	+define+PGEN_STANDALONE

#	+cli+3 \
#	+rad \
#	-race \
#	-line \
#	+memopt \

COMP_LOG = ./build/simv.log

RUN_FLAGS = ./build/simv +vcs+lic+wait -l ${RUN_LOG} +test_name=${TEST} +fsdb=${FSDB} +vpd=${VPD} 

ifeq (${FSDB}, 1)
RUN_FLAGS += \
	+fsdb=${FSDB}
else
ifeq (${VPD}, 1)
RUN_FLAGS += \
	+vpd=${VPD}
endif
endif

RUN_LOG = run.log

INCDIR = \
	+incdir+${TEAL_HOME} \
	+incdir+${TRUSS_HOME}/inc \
	+incdir+${TRUSS_HOME}/src \
	+incdir+${BASE_DIR} \
	+incdir+${COMMON_DIR} \
	+incdir+${BENCH_DIR} \
	+incdir+${NOTIFY_DIR} \
	+incdir+${RDEF_DIR} \
	+incdir+${RBUILD_DIR} \
	+incdir+${TCOM_DIR} \
	+incdir+${XACT_DIR} \
	+incdir+${LXACT_DIR} \
	+incdir+${RTL_DIR} \
	+incdir+${LDEF_DIR}

run:	simv
	.wrapper_vcs.pl ${RUN_FLAGS}

gui:    simv
	.wrapper_vcs.pl ${RUN_FLAGS} -gui -tbug

# Run No Recompile
run_nc:   
	../bin/sim_preprocessor.pl ${TEST}
	.wrapper_vcs.pl ${RUN_FLAGS}

# GUI No Recompile
gui_nc:   
	.wrapper_vcs.pl ${RUN_FLAGS} -gui -tbug

includes: ${INC_FILES}

simv:	${TB_SV_FILES} 
	vcs ${DEBUSSY_PLI} ${DEBUSSY_LIB} ${COMP_FLAGS} ${PLATFORM_FLAGS} ${INCDIR}  \
		${TB_SV_FILES}


clean: 	
	@rm -rf csrc simv* .res* ucli* .ucli* *.db ./build/simv* ./build/*.log 

deb:
	verdi -sv +systemverilogext+.sv -autoalias ${INCDIR} \
	 ${TB_SV_FILES} -nologo 

