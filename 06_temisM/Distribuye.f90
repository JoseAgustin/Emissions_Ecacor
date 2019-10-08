!
!   Distribuye.f90
!   
!
!   Created by Agustin Garcia on 12/04/19.
!   Copyright 2019 CCA_UNAM. All rights reserved.
!
! Distriuye temporal y espacialmente las emisiones
!  con base a salida.csv y los archivos temporales
!
!  ifort -O2 -o dist.exe Distribuye.f90
module variables
integer, parameter :: nh=24  ! Number of hours
integer, parameter :: nf=14  !Number fof TM files
integer :: nfrac !number of fractions in salida.csv
integer :: nline !numer of grids in TMfile
integer*4 ::lfa  ! line number in area file TCOV_2014.txt
integer,allocatable ::grid(:)   ! grid id from emissions file
integer,allocatable ::grid2(:)   ! different grid id from emissions file
integer(kind=8),allocatable :: iscc(:)  ! scc codes for each grid2
real,allocatable :: ea(:,:)      ! emissions in TMfile grid2 , nh
real,allocatable :: fclass(:,:)! aggregation factor by size(grid), hours
character (len=10) :: cdum
character (len=3)  :: cdia
character (len=19) :: current_date

common /date/ nfrac,nline,current_date
end module variables

program Distr
use variables

    call lee_fracc

    call lee_TMfiles

contains
subroutine lee_TMfiles
implicit none
integer i,j,k,ii
real sum(nh)
character(len=14),dimension(nf) ::casn
data casn /'TMCO__2014.csv','TMNH3_2014.csv','TMNO2_2014.csv', &
           ' TMNO_2014.csv','TMSO2_2014.csv','TMCN__2014.csv', &
           'TMCO2_2014.csv','TMCH4_2014.csv','TMPM102014.csv', &
           '    GSO4_M.csv','     POA_M.csv','    OTHE_M.csv', &
           'TMPM2_2014.csv','TMCOV_2014.csv'/
do k=1,nf
    open (unit=10,file=casn(k)//'i',status='old')
    read(10,*)cdum
    read(10,*)lfa,current_date,cdia
    open (unit=11,file=casn(k))
    write(11,*) casn(k),',ID, Hr to Hr24,g/h'
    write(11,*) lfa,",",current_date,",",cdia
    nline=lfa
! SUMA LA EMISION EN LAS CELDAS CORRESPONDIENTES
    print *,"lineas ",nline," en ",casn(k)//'i'
    sum=0.0
    allocate (grid2(nline),ea(nline,nh))
    if (k.ge.nf-1) allocate(iscc(nline))
    do i=1,nline
    if (k.ge.nf-1) then
        read (10,*)grid2(i),iscc(i),(ea(i,j),j=1,nh)
    else
        read (10,*)grid2(i),(ea(i,j),j=1,nh)
    end if
        do ii=1,nfrac
        if(grid2(i).eq.grid(ii)) then
            do j=1,nh
                sum(j)=sum(j)+ea(i,j)
            end do !j
        end if
        end do !ii
    end do ! i
! CALCULA LA NUEVA EMISION
    print *," ****  Suma=",sum
    do i=1,nline
        do ii=1,nfrac
        if(grid2(i).eq.grid(ii)) then
            do j=1,nh
                ea(i,j)=sum(j)*fclass(ii,j)*24
            end do !j
        end if
        end do !ii
        if (k.ge.nf-1) then
            write (11,110)grid2(i),iscc(i),(ea(i,j),j=1,nh)
        else
            write (11,100)grid2(i),(ea(i,j),j=1,nh)
        end if
    end do !i
    deallocate (grid2,ea)
    if(allocated(iscc)) deallocate(iscc)
    close (10) !original
    close (11) !modificado
end do ! k
100 format(I7,",",23(ES12.4,","),ES12.4)
110 format(I7,",",I10,",",23(ES12.4,","),ES12.4)
end subroutine
subroutine lee_fracc
implicit none
integer i,j
    open (unit=10,file='salida.csv',status='old')
    read(10,'(A)')cdum
    i=0
    do
        read(10,'(A)', END=200)cdum
        i=i+1
    end do
200 continue
    nfrac=i
    rewind(10)
    allocate(fclass(nfrac,nh),grid(nfrac))
    read(10,'(A)')cdum
    do i=1,nfrac
        read(10,*) grid(i),(fclass(i,j),j=1,nh)
    end do
    close (10)
end subroutine lee_fracc
end program
