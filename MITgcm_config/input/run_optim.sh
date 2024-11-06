#!/bin/bash
# tabula rasa:
rm ecco_c* OPWARM.* m1qn3_output.txt
#
myiter=0
cat > data.optim <<EOF #
# ********************************
# Off-line optimization parameters
# ********************************
&OPTIM
 optimcycle=${myiter},
 numiter=10,
 nfunc=10,
 dfminFrac = 0.1,
 iprint=10,
 nupdate=8,
/

&M1QN3
/
EOF

while (( $myiter < 101 ))
do
    # formatter iteration count
    it=`echo $myiter | awk '{printf "%03i",$1}'`
    echo "iteration ${myiter}"
    # increment counter in data.optim
    sed -e "s/.*optimcycle.*/ optimcycle=${myiter},/" data.optim > data.optim.${it}
    \cp -f data.optim.${it} data.optim
    mpirun -np 4 ./mitgcmuv_ad
    \mv STDOUT.0000 stdout.${it}
    ./optim.x > opt${it}.txt
    m1qn3out=`grep "m1qn3: output mode" m1qn3_output.txt`
    if test "x${m1qn3out}" != x; then
	    echo "m1qn3 has finished"
	    break
    fi
    # increase counter for next iteration
    ((myiter++))
done
