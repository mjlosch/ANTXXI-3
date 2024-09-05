C*******************************************************************************
C***  bot_form2.for formatiert Bottlefiles 
C***  Boris Cisewski 15.04.2005
C***  Dieses Programm konvertiert die Dateinen *.fbt in *.bof
C***  Die neuen Dateien enthalten ausschlieﬂlich hydrographische Parameter!
C*******************************************************************************
      character inline*190, fileIn*80, fileIn2*80, fileOut*80
      character cfn*5,inline2*113
      integer m,ikl,b,mm
     
C***  LESE DATEN EIN                                                         ***
  
      print *,' start file (5 char):'
      read (*,*) istart
      print *,' end file (5 char):'
      read (*,*) istop          

      do ikl=istart,istop
      write (cfn,'(i5.5)') ikl
      fileIn=''//cfn//'.fbt'
      fileOut=''//cfn//'.bof'
      open(unit=1,file=fileIn,status='old',recl=190,err=25)
      open(unit=2,file=fileOut,status='new')
      print *, ' file:', fileIn  

C***  LESE HEADER EIN                                                          ***

      do i=1,900
      read(1,111,end=11,err=10) inline

      n=(i.ge.1).AND.(i.le.5)
      if (n) then
      write(2,111), inline
400   format(A113)
      endif

      if(i.eq.6) then
      write(2,400)'%     BOTTLE  PRESS  TEMP1(T90)  COND1  SALT1  PTEMP1
     *(T90)  SIGTH1  TEMP2(T90)  COND2  SALT2  PTEMP2(T90)  SIGTH2'
      endif

      if(i.gt.6) then
      read(inline(1:113),'(A113)') inline2
      write(2,400), inline2
      endif
      enddo
     

111   format(A190)

11    continue
      print*,'end'
        
10    continue
      print*,'error'
 
      close(1)
      close(2)

25    continue ! from fileopen error
      enddo    ! fileloop         

      end