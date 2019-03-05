#! /bin/bash
export LC_COLLATE=C
shopt -s extglob
PS3="Enter new choice : "
select table in "Insert in table "  "delete from table  "  "update table "   "Back to main menu "
do 
counter=1
flag=1
clear 
case $REPLY in  
      1) echo "Insert your data in that sequence :"
         sed -n "/$1/p" $2/metadata_$2 | awk -F: '{for ( i=3 ; i<NF; i+=2) print $i}' 
         #sed -n "/nnn/p" metadata_first | awk -F: '{for ( i=3 ; i<NF; i+=2) print $i}' 
          arr_data=('')
          echo "plz enter pk data"
          read insert_data #primary key
          len=${#insert_data}          
  if ((  $len == 0  )) # check empty length 
    then 
      echo "You entered empty value , please re-enter true value"  
      break
  else 
    var_pk=`sed -n "/$1/p" $2/metadata_$2 | awk -F: '{ i=4 ; print $i}'`
    var_num=`sed -n "/$1/p" $2/metadata_$2 | awk -F: '{ i=2 ; print $i}'`
    #echo " data type of pk $var_pk :no of column in table $var_num"
    count_arr=0
        if [ "$var_pk" == "int" ]
            then 
            case $insert_data in  #start of case insert data 
            +([0-9]) ) 
                 var_duplicate=`cut -d: -f1 $2/$1 | sed -n "/$insert_data/p"`
                 len2=${#var_duplicate}
                     if [ $len2 -ne 0 ] 
                        then 
                         echo "Error ,$insert_data duplicated"
                         break 
                     else
                       arr_data[$count_arr]=$insert_data
                       count_arr+=1  
                       #echo "${arr_data[$count_arr]}"
                     fi # end if of duplicate
               ;;    
            *) echo "Please Enter int value "     
              break                
             ;;
            esac 
            #end case of $insert_data
        else # [ "$var_pk" == "string" ]   # data tyoe of pk is int     
           
            case $insert_data in  #start of case insert data 
            +([a-zA-Z]) ) 
                var_duplicate=`cut -d: -f1 $2/$1 | sed -n "/$insert_data/p"`
                if [ "$var_duplicate" == "$insert_data" ]
                   then 
                  echo "Error ,$insert_data duplicated" 
                else
                  arr_data[$count_arr]=$insert_data
                  #echo "${arr_data[$count_arr]}"
                  count_arr+=1
                fi    # end if of duplicate
            ;;
            *) echo "Please Enter string value"
            break 
            ;;
            esac  #end case of $insert_data
        fi  #end var_pk == string
  fi # end if length  
         for ((i=6;i<=(var_num*2)+2;i+=2)) #start for to take rest of data after pk
          do
             # var_pk=`sed -n "/$1/p" $2/metadata_$2 | awk -F: '{ i=4 ; print $i}'`
             #var_gen=`sed -n "/$1/p" $2/metadata_$2 | awk -F: -v h=$i  '{ j=$h ; print $j}'` #take data type
          var_gen=`sed -n "/$1/p" $2/metadata_$2 | cut -d: -f$i`
          #echo "$var_gen this is "
             if [ $var_gen = "int" ] #start if check type
                then                          
                 echo "enter your  int value "
                 read data 
                 len=${#data}
                     if ((  $len == 0  )) # check empty length 
                        then 
                        echo "You entered empty value , please re-enter true value"  
                      else 
                             case $data in 
                               +([0-9])) 
                                arr_data[$count_arr]=$data
                                count_arr+=1
                               ;;
                              *) echo "please enter write data type -int- "
                                 break
                                ;;
                              esac
                      fi # end if check length 
             else #data is string 
                  echo "enter your string value "
                    read data 
                    len=${#data}
                     if ((  $len == 0  )) # check empty length 
                        then 
                        echo "You entered empty value , please re-enter true value"  
                        break
                      else 
                              case $data in 
                                  +([a-zA-Z]) ) 
                                  arr_data[$count_arr]=$data
                                  count_arr+=1
                                  ;;
                                  *) echo "please enter write data type -string- "
                                      break
                                  ;;
                              esac
                      fi # end if check length 
              fi # end if check type 
                        
          done # end of for 
            #echo "$var_num var_num is " 
            #echo "${#arr_data[@]} size of array"         

          if [ $var_num -eq ${#arr_data[@]} ]  
              then  
              echo  "${arr_data[@]}" >>$2/$1
          else 
              echo "Data not inserted !"
          fi
                            #echo "data of array at append : at index $i : ${arr_data[$i]}"
                           #done  #end for  
                           #echo  "" >>$2/$1
          ;;
            2) 
                  echo "enter pk to be deleted"
                    read pk_del
                    len=${#pk_del}
                     if (( $len == 0 )) # check empty length 
                        then 
                        echo "You entered empty value , please re-enter true value"
                     else 
                     #cut first col then sed on it
                        var_del=`sed -n "/$pk_del/p" $2/$1`      
                         len1=${#var_del}       
                           if [ $len1 -ne 0 ] #exist
                             then      
                             sed -i "/$pk_del/d" $2/$1
                             echo "record that contain $pk_del deleted "
                             else 
                             echo "$pk_del not exist"
                           fi # end exist
                     fi  #   end empty length
                      ;;           
            3) echo "Enter pk for data you want to edit "
            # $1 table name  , $2 database name
             typeset -i ctr=0
             read pk_update
             len=${#pk_update}
             #echo "$pk_update"
if [ $len -eq 0 ] # pk check empty value you entered
    then
    echo "You entered empty value , please re-enter true value"
    break
else # else empty value you entered
   var_update=`sed -n "/$pk_update/p" $2/$1`      
   len1=${#var_update}       
      if [ $len1 -ne 0 ] #check pk exist or not 
          then      
          echo "Your fields to remembers :"
          sed -n "/$1/p" $2/metadata_$2 | awk -F: '{for ( i=3 ; i<NF; i+=2) print $i}' 
          echo "Enter the field you want to update " 
          read update_field
           len2=${#update_field}
             if [ $len2 -ne 0 ] #col check empty value you entered
                 then        
                 var_check=`sed -n "/$update_field/p" $2/metadata_$2 `
                 len3=${#var_check}
                     if [ $len3 -ne 0 ] #col check exist in table
                        then
                        num_field=`sed -n "/$1/p" $2/metadata_$2` #| awk -F: -v x="$update_field" '{for (j=5 ; j<NF; j+=2) {  if ( $j = $x ) h=$j}; print $h }'`
                        tempIFS="$IFS" 
                        IFS=':' 
                        read -r -a arr_update <<<"$num_field" #convert line to array
                        IFS="$tempIFS"
                        #convert array line to array col 
                        arr_count=(`echo ${arr_update[@]} | tr -s " " "\n" | grep -n "${update_field}" |cut -d":" -f 1`)-1
                             for i in "${arr_count[@]}"                                   
                              do 
                                  if [ "${arr_update[$i]}" = "${update_field}"  ]   
                                      then
                                      ctr=i
                                  fi
                              done
                              ctr=ctr/2 
                      else  #col check not exist in table
                        echo "you want to update in col not found "
                        break 
                      fi         
                     
        if [ $ctr -eq 1 ] #check counter to sure if you try to edit in pk col
            then 
            echo "You can't edit data in pk column ."
            break 2      
        else # else col check empty value you entered
                # echo " you entered empty value"
              #fi            
            ctr=$ctr*2
            ctr=$ctr+2
            #echo "$ctr ctr check"
            var_gen22=`sed -n "/$1/p" $2/metadata_$2 `
            #echo "$var_gen22 check" 
            var_gen=`sed -n "/$1/p" $2/metadata_$2 | cut -d: -f$ctr `
            ctr=$ctr-2
            ctr=$ctr/2
            #echo "$var_gen type of var_gen "
               if [ "$var_gen" = "int" ] #start if check type
                  then                          
                  clear
                  echo "enter your  int value "
                  read new_cell
                  len5=${#new_cell}
                       if ((  $len5 == 0  )) # check empty length 
                         then 
                          echo "You entered empty value , please re-enter true value"  
                      else 
                         case $new_cell in 
                          +([0-9]))
                           echo "your data type is true"
                           awk -F" " -v ctr=$ctr -v new_cell=$new_cell -v pk=$pk_update '{if($1==pk){$ctr=new_cell};print $0 }' $2/$1 > temp
                           cat temp > $2/$1
                           rm temp
                           echo "your data updated "
                              ;;
                            *) echo "please enter write data type -int- "
                             break
                             ;;
                          esac
                       fi # end if check length 
         else 
         clear
          echo "enter your string value "
          read new_cell 
          len5=${#new_cell}
                if ((  $len5 == 0  )) # check empty length 
                     then 
                     echo "You entered empty value , please re-enter true value"  
                else 
                     case $new_cell in 
                       +([a-zA-Z]) ) 
                          awk -F" " -v ctr=$ctr -v new_cell=$new_cell -v pk=$pk_update '{if($1==pk){$ctr=new_cell};print $0 }' $2/$1 > temp
                          cat temp > $2/$1
                          rm temp
                          echo "your data updated"
                          ;;
                       *) echo "please enter write data type -string- "
                        break
                         ;;
                      esac
                fi # end if check length 
          fi # end if check type
        fi
       else
         echo " pk you entered not exist in table"
      fi
    fi 
fi   #end exist
       ;;


      4 )
      break 
      ;; 
    *) echo "please choose number from 1 - 4 "
        ;;      
esac
done

                     
  
