CC=gcc
CXX=g++
NVCC=nvcc
RM=rm
WARNINGS := -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-align \
			-Wwrite-strings -Wmissing-declarations -Wredundant-decls \
			-Winline -Wno-long-long -Wuninitialized -Wconversion
CWARNINGS := $(WARNINGS) -Wmissing-prototypes -Wnested-externs -Wstrict-prototypes
CXXWARNINGS := $(WARNINGS)
CFLAGS := -g -fPIC -std=c99 $(CWARNINGS)
CXXFLAGS := -g $(CXXWARNINGS)
LDFLAGS := -lcuda -lgtest
CUDAINC=/opt/cuda/include
VALGRINDFLAGS := --error-exitcode=1 --leak-check=full --suppressions=valgrind.suppressions

all: test

# When building CUDA files (as all of these test cases are), nvcc does a better
# job at linking.
test_%: test_%.o
	nvcc $(LDFLAGS) -o $@ $<
vtest_%: vtest_%.o
	nvcc $(LDFLAGS) -o $@ $<

# This builds the test runner via dependency and runs it with and without
# Panoptes
run_%: %
	(test .$<.norm_passed -nt $<                                              ) || (                                        				 ./$< && touch .$<.norm_passed)
	(test .$<.pano_passed -nt $< && test .$<.pano_passed -nt ../libpanoptes.so) || (LD_PRELOAD="../libpanoptes.so"          				 ./$< && touch .$<.pano_passed)

# This builds the test runner (via the run_%) dependency and then runs it with
# Valgrind as well
vrun_%: % run_%
	(test .$<.valg_passed -nt $< && test .$<.valg_passed -nt ../libpanoptes.so) || (LD_PRELOAD="../libpanoptes.so" valgrind $(VALGRINDFLAGS) ./$< && touch .$<.valg_passed)

# Anything prefixed with test_ gets tested.  Anything prefixed with vtest_ is
# tested and run under Valgrind.  Tests which deliberately cause memory
# errors should not be run under Valgrind.
RUNNERS := $(patsubst %.cu,%,$(wildcard *test_*.cu)) $(patsubst %.cpp,%,$(wildcard *test_*.cpp))
test: $(patsubst %.cu,run_%,$(wildcard test_*.cu)) $(patsubst %.cu,vrun_%,$(wildcard vtest_*.cu))

%.o: %.c Makefile
	$(CC) $(CFLAGS) -fPIC -MMD -MP -c $< -o $@

%.o: %.cpp Makefile
	$(CXX) $(CXXFLAGS) -fPIC -MMD -MP -I$(CUDAINC) -c $< -o $@

%.o: %.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@

test_k_assert.o: test_k_assert.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_ballot.o: vtest_k_ballot.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_bitfield.o: vtest_k_bitfield.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_blas.o: vtest_k_blas.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_block_reductions.o: vtest_k_block_reductions.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_brev.o: vtest_k_brev.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_brkpt.o: vtest_k_brkpt.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_11

vtest_k_carry.o: vtest_k_carry.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_clz.o: vtest_k_clz.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_copysign.o: vtest_k_copysign.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_global_reductions.o: vtest_k_global_reductions.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_mulhi.o: vtest_k_mulhi.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_pmevent.o: vtest_k_pmevent.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_printf.o: vtest_k_printf.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_popc.o: vtest_k_popc.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_rsqrt.o: vtest_k_rsqrt.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_testp.o: vtest_k_testp.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_threadfence.o: vtest_k_threadfence.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_tex1d_sm20.o: vtest_k_tex1d_sm20.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

vtest_k_uniform.o: vtest_k_uniform.cu Makefile
	$(NVCC) -g $(INCLUDEDIR) -c $< -o $@ -arch sm_20

clean:
	-$(RM) -f *.d *.o .*.*_passed $(RUNNERS)

.PHONY: all clean
