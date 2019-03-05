#! /bin/bash
export LC_COLLATE=C
shopt -s extglob
PS3="Enter new choice : "
function show
{
echo "1-Create new Database"
echo "2-Delete Database "
echo "3-Select Database "
echo "4-Exit"
}
n=1
while (( $n ==1 ))
do 
clear
select db in "create new Database"  "delete database"  "select Database" "Exit"
do 
clear 
show
case $REPLY in 
       1) echo  "Enter name of Database to be created "
       read db_name
        len=${#db_name}
             if [  $len -eq 0  ] # check empty length 
             then 
             echo "You entered empty value , please re-enter true value"
             else 
                  case $db_name in 
                  +([A-Za-z]) )
                  if [ -d $db_name ] #start if exist
                  then 
                  echo "Error , database $db_name exist , please Enter another name."
                  else 
                  mkdir $db_name
                  touch $db_name/metadata_$db_name
                  echo "Database $db_name created."
                  fi #end if exist
                  ;;
                  *) echo "enter valid name "
                  ;;
                 esac #end of esac  
       fi # end empty length 
       ;;
       2) echo "Enter name of Database to be deleted"
          read db_name 
             len=${#db_name}
             if [ $len -eq 0 ] # check empty length 
                  then 
                  echo "You entered empty value , please re-enter true value"
             else
                  case $db_name in 
                       +([A-Za-z]) )
                         if [ -d $db_name ] #exist
                               then           
                                  rm -r $db_name 
                                     echo "database $db_name deleted "              
                             else        
                                echo "Database $db_name not exist !, please Enter the right name "   
                             fi #end exist
                       ;;
                       *) echo "enter valid name "
                       ;;
                  esac #end of esac                      
            fi # end empty length 
       ;;
       3) echo "Enter name of Database to be Selected"
       read db_name    
        len=${#db_name}
        if [ $len -ne 0 ]
        then
            if [ -d $db_name ]
            then 
             # cd $db_name 
             # echo "Entered DataBase $PWD"
             clear
              select table in "Table Options " "back to db Options"  #start of case table 
              do 
              clear 
              case $REPLY in
             # var_db="$db_name"  // modified to $2
              1)  ./create_table.sh $db_name       
              ;;
              2) break 
              ;;              
              *) echo "please select 1 or 2 "
              ;;
              esac #end of case table 
              done #end of select table 
            else 
            echo "Database not exist "
            fi
         else 
           echo "You entered empty value"
         fi         
       ;;
       4) break 2 
       n=0
       ;;
       *)
       echo " wrong option , please choose 1 , 2 , 3 "
       esac       
done #end select

done #end while
 
