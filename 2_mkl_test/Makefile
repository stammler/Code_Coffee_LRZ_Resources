FCOMP = gfortran
FFLAGS = -O3

EXE = mkl_test

$(EXE): Makefile
		$(FCOMP) $(FFLAGS) -o $(EXE) $(EXE).f90

clean:
		rm -rf *.o &> /dev/null;

clobber: clean
		rm -rf $(EXE) &> /dev/null;