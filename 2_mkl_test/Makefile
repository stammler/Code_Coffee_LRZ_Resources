FCOMP = ifort
FFLAGS = -O3

EXE = mkl_test

$(EXE): Makefile
		$(FCOMP) $(FFLAGS) -o $(EXE) $(EXE).f90 $(MKL_INC) $(MKL_SHLIB)

clean:
		rm -rf *.o &> /dev/null;

clobber: clean
		rm -rf $(EXE) &> /dev/null;
