program mkl_test

    implicit none

    integer, parameter :: N = 1000          ! Problem size
    double precision   :: A(N, N)           ! Matrix
    double precision   :: Y(N)              ! Vector

    double precision   :: R1(N)             ! Result vectors
    double precision   :: R2(N)

    integer            :: count_rate        ! Time keeping
    integer            :: iTime1, iTime2

    integer            :: i, j              ! Iteration variables

    ! Get count rate
    call system_clock(count_rate=count_rate)

    ! Initializing matrix and vector with random numbers
    call random_number(A)
    call random_number(Y)
    ! Initialize result vectors with zeros
    R1(:) = 0.d0
    R2(:) = 0.d0

    !do i=1, N
    !    Y(i) = i*1.d0
    !end do
    !A(:, :) = 0.d0
    !do i=1, N
    !    do j=1, N
    !        if(j==i+1) then
    !            A(i, j) = 1.d0
    !        end if
    !    end do
    !    if(i==N) then
    !        A(i, 1) = 1.d0
    !    end if
    !end do

    ! Standard execution with loops
    ! Start timer
    call system_clock(iTime1)
    do i=1, N
        do j=1, N
            R1(i) = R1(i) + A(i, j) * Y(j)
        end do
    end do
    ! Stop timer
    call system_clock(iTime2)
    write(*,*) "EXECUTION TIME"
    write(*,*) "Loops:", real(iTime2-iTime1)/real(count_rate)

    ! Matrix-vector multiplication with ?GEMM
    ! Start timer
    call system_clock(iTime1)
    call dgemm("N", "N", N, N, 1, 1.d0, A, N, Y, N, 0.d0, R2, N)
    ! Stop timer
    call system_clock(iTime2)
    write(*,*) "DGEMM:", real(iTime2-iTime1)/real(count_rate)
    write(*,*) "Max Error: ", maxval( abs( R1(:) - R2(:) ) )

end program mkl_test