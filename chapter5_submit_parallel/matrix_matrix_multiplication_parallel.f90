program matrix_matrix_multiplication_parallel

    implicit none

    integer, parameter :: M = 1000          ! Problem size
    integer, parameter :: N = 2000
    integer, parameter :: K = 4000

    double precision   :: A(M, K)           ! Matrices
    double precision   :: B(K, N)

    double precision   :: C1(M, N)          ! Result matrices
    double precision   :: C2(M, N)

    integer            :: count_rate        ! Time keeping
    integer            :: iTime1, iTime2

    integer            :: i, j, l           ! Iteration variables

    ! Get count rate
    call system_clock(count_rate=count_rate)

    ! Initializing matricess with random numbers
    call random_number(A)
    call random_number(B)
    ! Initialize result vectors with zeros
    C1(:, :) = 0.d0
    C2(:, :) = 0.d0

    ! Standard execution with loops
    ! Start timer
    call system_clock(iTime1)
    !$OMP PARALLEL SHARED(A, B, C1)
        !$OMP DO SIMD SCHEDULE(static)
            do i=1, M
                do l=1, K
                    do j=1, N
                        C1(i, j) = C1(i, j) + A(i, l) * B(l, j)
                    end do
                end do
            end do
        !$OMP END DO SIMD
    !$OMP END PARALLEL
    ! Stop timer
    call system_clock(iTime2)
    write(*,*) "EXECUTION TIME"
    write(*,*) "Loops:", real(iTime2-iTime1)/real(count_rate)

    ! Matrix-vector multiplication with ?GEMM
    ! Start timer
    call system_clock(iTime1)
    call dgemm("N", "N", M, N, K, 1.d0, A(:, :), M, B(:, :), K, 0.d0, C2(:, :), M)
    ! Stop timer
    call system_clock(iTime2)
    write(*,*) "DGEMM:", real(iTime2-iTime1)/real(count_rate)
    write(*,*) "Max Error: ", maxval( abs( (C1(:, :) - C2(:, :))/C2(:, :) ) )

end program matrix_matrix_multiplication_parallel
