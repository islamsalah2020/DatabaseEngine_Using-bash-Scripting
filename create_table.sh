#! /bin/bash
export LC_COLLATE=C
shopt -s extglob
PS3="Enter new choice : "
select table in "Create new table  "  "delete exist table "  "select table " "Back to main menu"
do 
counter=1
flag=0
clear 
case $REPLY in         
           
        1) echo "Enter name of Table"
          read table_name 
          len=${#table_name}
          if [  $len -eq 0  ] # check empty length 
             then 
             echo "You entered empty value , please re-enter true value"
             else 
                  case $table_name in 
                  +([A-Za-z]) )
                  if [ -f $1/$table_name ] #start if exist
                  then 
                  echo "Error , Table $table_name exist , please Enter another name."
                  else 
                  clear
                  echo "Enter number of columns "
                  read columns_num
                    len6=${#columns_num}
                     if [  $len6 -eq 0  ] # check empty length 
                     then 
                     echo "you entered empty value"
                     break
                     fi
                  if [ $columns_num -lt 2 ] 
                  then
                  echo "you Entered wrong value for column number $columns_num : min 2 columns ."
                  break
                  fi 
              column_name=('')
              datatype=('')
            
          if [  $len6 -eq 0  ] # check empty length 
             then 
             echo "you entered empty value"
             else
               case $columns_num in 
                         +([0-9]) )
                  for ((i=0;i<columns_num;i++))
                  do
                        echo "Enter column $i name"
                        read col_name
                         case $col_name in 
                         +([A-Za-z]) )

                              column_name[i]=$col_name
                              echo "Select column $i datatype" 
                              select col in "string"  "int"   
                              do 
                              case $REPLY in
                              1) datatype[i]="string"
                              break
                              ;;
                              2) datatype[i]="int"
                              break
                              ;;
                              *)echo "wrong choice , please enter 1 or 2"
                              ;;
                              esac
                              done #end select type
                          ;;
                          *) echo "Please enter right value String :"    
                          break 2
                          ;;
                          esac     
                    
                  done # end of for
                   ;;
                   *) echo "Please enter right value int :"    
                          break 2
                          ;;
                     esac
                     touch $1/$table_name     
                     flag=1
                     echo "$table_name created"
               fi # end of size of len6
                  for ((i=0;i<columns_num;i++))
                  do 
                  if ((flag == 1))
                  then
                  echo  -n "$table_name:$columns_num" >> $1/metadata_$1 
                  flag=0
                  fi
                  echo -n ":${column_name[$i]}:${datatype[$i]}" >>$1/metadata_$1
                  done  #end for  
                  echo "" >>$1/metadata_$1            
                  
                  fi #end if exist
                  ;;
                  *) echo "enter valid name of table"
                  ;;
                 esac #end of esac       
       fi # end empty length 
       flag=0
       
       ;;
        2) echo "Enter Tablename to be deleted"
           read table_name 
             len=${#table_name}
             if (( $len == 0 )) # check empty length 
             then 
             echo "You entered empty value , please re-enter true value"
             else         

               case $table_name in 
                  +([A-Za-z]) )
                  if [ -f $1/$table_name ] #exist
                  then           
                  rm $1/$table_name
                  sed -i "/$table_name/d" $1/metadata_$1  
                  echo "table $table_name deleted "
                  else 
                  echo "table $table_name not exist"        
                  fi #end exist
                       ;;
                       *) echo "enter valid name "
                       ;;
               esac #end of esac          
     
        fi # end empty length 
        ;; 
        3)
        echo "Enter table to be selected"
        read table_name
          len=${#table_name}
             if (( $len == 0 )) # check empty length 
             then 
             echo "You entered empty value , please re-enter true value"
             else              
                if [ -f $1/$table_name ] #exist
                then
                echo "table $table_name selected "
                select table in "modify Options "  "back to db Options"   #start of case table 
                 do 
                 clear 
                case $REPLY in
                1)  . ./modify_table.sh $table_name $1 # modified to send parameter $1      
                  ;;
               
               2) break 2 
              ;;
               *) echo "please select 1 or 2 "
               ;;
               esac #end of case table 
                done #end of select table 
                else 
                echo "table $table_name not exist"        
             fi #end exist
             fi # end empty length 
        ;;
        4) clear
        break 2

        ;;
        *) echo "default"
        clear
        echo "please choose number from 1 - 4 "
        ;;
      
      esac
      done
