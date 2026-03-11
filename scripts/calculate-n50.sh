awk '
{
    len[NR]=$1
    total+=$1
}
END{
    half=total/2
    running=0
    for(i=1;i<=NR;i++){
        running+=len[i]
        if(running>=half){
            print "N50 =", len[i]
            break
        }
    }
}' output/iso_lengths_sorted.txt
