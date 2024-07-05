.data

filename: .asciiz "C:\\Users\\reest\\OneDrive\\Desktop\\Mips Project\\MedicalTest.txt"
choose_option:	.asciiz "\n\nwelcome to the menu\n1) Add New Medical Test.\n2) Search for a test by patient ID.\n3) Searching for unnormal tests.\n4) Average test value.\n5) Update an existing test result.\n6) Delete a test.\n press 0 to exit the program\nWrite the number of your choice: "

PID: .asciiz "Enter Patient ID: "
P_TestName:  .asciiz "Enter Test Name: "
PTestDate:  .asciiz "Enter Test Date (YYYY-MM): "
PTestResult: .asciiz "Enter Test Result: "


PID_Buffer: .space 21 
Test_Name_Buffer: .space 7 
Test_Date_Buffer: .space 21 
Test_Result_Buffer: .space 15
Total_Buffer: .space 3000 


PID_Num_Of_Digit: .asciiz "Number must be exactly 7 digits. & Only Numbers\n"
Negative_Message: .asciiz "Number must not be negative.\n"
Valid_Message: .asciiz "Valid Input.\n"
InValid_Message: .asciiz "InValid Input.\n"


thankYouMsg: .asciiz "Thank you! Your input has been recorded.\n"
lengthErrorMsg: .asciiz "Error: The test name must be exactly 3 characters long.\n"
charErrorMsg: .asciiz "Error: The test name must contain only characters.\n"
yearLengthError: .asciiz "Invalid year digits. || error in format\n"
MounthLengthError: .asciiz "Invalid mounth digits. || error in format\n"
ValidDate: .asciiz "Valid Date.\n"
Valid_Result: .asciiz "Valid Result.\n"
ErrorInDot: .asciiz "Error in number of dot's.\n"
Done: .asciiz "Doneeeee.\n"
new_line:  .asciiz "\n"  
try_again: .asciiz "PLEASE ENTER CORRECT DATA!!\n"
keep_readig: .asciiz "choose option ,or exit by enter 0\n"


SearchOptions: .asciiz "1. Retrieve all patient tests\n 2.Retrieve all up normal patient tests\n 3.Retrieve all patient tests in a given specific period\n"
readBuffer: .space 5000
Invalid_input_file: .asciiz "invalid file read\n"
Temp_String: .space 50
misMatchMsg: .asciiz "\nMissMatch, there is no id like this \n"
Match_msg: .asciiz "\nMatch Id\n"
Next_Line: .asciiz "To Next Line\n"
try_again_menu: .asciiz "Check Option, Try Again"


ExtractedResult: .space 70
Hgb_Normal_Low: .float 13.8
Hgb_Normal_High: .float 17.2
BGT_Normal_Low: .float 70.0
BGT_Normal_High: .float 99.0
LDL_Normal_High: .float 100.0
BPT_Normal_Sys: .float 120.0
BPT_Normal_Dia: .float 80.0


UPNORMAL_MSG: .asciiz "upnormal :(\n"
Noraml: .asciiz "Normal :)\n"
Start_Period: .asciiz "Enter the beginning of the preiod\n"
End_Period: .asciiz "Enter the End of the preiod\n"

Start_Date: .space 50
End_Date: .space 50
ExtractedDate: .space 70
initialize: .float 0.0
Choose_One: .asciiz "choose one of the following: \n"
ReadResultTwo:.asciiz "Enter the Diastolic Blood Pressure result \n"
SecondResult:.space 50
one_float: .float 1.0
askFornumber: .asciiz "enter the number of line \n"
PTestSecondResult: .asciiz "Enter Test Second Result: \n"


Average_for_Hgb: .asciiz "Average value for Hgb: "
Average_for_LDL: .asciiz "Average value for LDL: "
Average_for_BGT: .asciiz "Average value for BGT: "
Average_for_BPT: .asciiz "Average value for BPT first value: "
Average_for_BPT2: .asciiz "Average value for BPT second value: "

.text

.globl main

# Starrting Program
main: 

# The menu is start from here     
menu:  
       li $v0, 4 	    # syscall code for print string "menu"
       la $a0, choose_option 
       syscall   
       
# Menu Options
       li $v0, 5  # Read Integer
       syscall
        
       beq $v0, 1, Add_New_medical
       beq $v0, 2, Search_By_ID  
       beq $v0, 3, Search_Unnormal  
       beq $v0, 4, Average_test_value
       beq $v0, 5, Update
       beq $v0, 6, Delete
       beq $v0, 0, End_Program
# if choose something not from above	
       li $v0, 4
       la $a0,try_again_menu
       syscall

	j menu

# Function to add new tets
Add_New_medical:
	
    # Print Enter PID String
    li $v0, 4
    la $a0, PID
    syscall

    # Read PID string
    li $v0, 8
    la $a0, PID_Buffer
    li $a1, 21
    syscall

    # Read byte-byte of the PID
    la $a1, PID_Buffer
    lb $t0, 0($a1) 
    li $t2, 45 # ASCII value for minus
    beq $t0, $t2, Negative_Num

    # Couter for counting PID digits
    li $t1, 0
    move $a0, $a1

Digits_Counter:

    lb $t0, 0($a0)
    beq $t0, $zero, Digits_Check # End of string
    beq $t0, 10, Digits_Check # Newline, end of input
    li $t3, 48
    li $t4, 57
    blt $t0, $t3, PID_Invalid # Non-digit
    bgt $t0, $t4, PID_Invalid # Non-digit
    addi $t1, $t1, 1
    addi $a0, $a0, 1
    j Digits_Counter
    
# Check that the PID is exactly 7 digits
Digits_Check:

    li $t5, 7 # Standard number of digits for PID
    bne $t1, $t5, Not_Seven_Digit
    # if Seven Digits
    li $v0, 4
    la $a0, Valid_Message
    syscall
     
    # Print Enter Test Name String
    li $v0, 4
    la $a0, P_TestName
    syscall
    
   # Read the test name
    li $v0, 8
    la $a0, Test_Name_Buffer
    li $a1, 7 
    syscall
    
    
    # Validate the length of the test name
    la $a0, Test_Name_Buffer 
    lb $t0, 3($a0)         # Load the byte at position 3 of testNameBuffer into $t0
    beq $t0, 10, validateCharacters # If the loaded byte is newline, proceed to character validation
    j nameLengthError

validateCharacters:
    la $a0, Test_Name_Buffer 
    li $t2, 3            

validateLoop:
    lb $t0, 0($a0) # Load the current character
    li $t1, 'A'
    li $t3, 'Z'
    li $t4, 'a'
    li $t5, 'z'
    blt $t0, $t1, charError # If char is less than 'A'
    bgt $t0, $t5, charError # If char is greater than 'z'
    bgt $t0, $t3, checkLower # If char is greater than 'Z' but less than 'a', it's an error
    j validChar

checkLower:
    blt $t0, $t4, charError # If char is less than 'a' after being greater than 'Z'

validChar:
    addi $a0, $a0, 1       
    addi $t2, $t2, -1      # Decrement characters left to validate
    bnez $t2, validateLoop # If there are characters left, keep validating

    # If all characters are valid
    li $v0, 4
    la $a0, thankYouMsg
    syscall
    
    
     # Print Enter date String
    li $v0, 4
    la $a0, PTestDate
    syscall
    
    # Read the date String
    li $v0, 8
    la $a0, Test_Date_Buffer
    li $a1, 21 
    syscall
    j Check_Date
    

Check_Date:

    # Couter for counting before '-' for date (year)
    li $t1, 0 
    la $a1, Test_Date_Buffer
    
    #counter for counting After '-' for date (Mounth)
     li $t3, 0 
    
Digits_Counter_Date:

    lb $t0, 0($a1) 
    beq $t0, $zero, Check_Month# End of string
    beq $t0, 10, Check_Month # Newline, end of input
    beq $t0, 45, Check_Year
    addi $t3, $t3, 1 
    li $t4, 48 #'0'
    li $t5, 57 #'9'
    blt $t0, $t4, date_Invalid # Non-digit
    bgt $t0, $t5, date_Invalid # Non-digit
    addi $a1, $a1, 1
    j Digits_Counter_Date

# 4 digits before '-'   
Check_Year:
	move $t1, $t3
	li $t3, 0
	li $t6, 4
	addi $a1, $a1, 1 
	bne $t1,$t6, invalidYear
	j Digits_Counter_Date
	
invalidYear:
	li $v0, 4
        la $a0, yearLengthError
        syscall
        li $v0, 4
    	la $a0, try_again
    	syscall
    	j Add_New_medical
        
Check_Month:
	bne $t3,2, invalidMonth
	bne $t1,4,date_Invalid
	
	li $v0, 4
        la $a0, ValidDate
        syscall
        
        
        # Print result String
    	li $v0, 4
    	la $a0, PTestResult
    	syscall

   	 # Read result string
   	li $v0, 8
    	la $a0, Test_Result_Buffer
    	li $a1, 15
    	syscall
    	j Check_Test_Result
    	

Check_Test_Result:
    # counter for number of dot's
    li $t1, 0 
    la $a1, Test_Result_Buffer
      		
Digits_Counter_Result:

    lb $t0, 0($a1) 
    beq $t0, $zero, Check_Result# End of string
    beq $t0, 10, Check_Result # Newline, end of input
    beq $t0, 46, Check_dot
    li $t4, 48 #'0'
    li $t5, 57 #'9'
    blt $t0, $t4, Result_Invalid # Non-digit
    bgt $t0, $t5, Result_Invalid # Non-digit
    addi $a1, $a1, 1
    j Digits_Counter_Result
    
    
Check_Result:
 	li $v0, 4
    	la $a0, Valid_Result
    	syscall
    	
    	la $s1, Test_Name_Buffer
    	
    	addi $s1,$s1,1
    	lb $t8,0($s1)
    	beq $t8, 'P',ReadSecondResult 	
    	
FinalConcatinat:   	
	#addi $s2, $s2, 2
    la   $a0, Total_Buffer  # Load the address of the buffer into $a0
    li   $t1, 100     # Load the size of the buffer into $t1

empty_buffer:
    li   $t0, 0       # Load zero into $t0
    sb   $t0, 0($a0)  # Store byte of zero at the address in $a0
    addi $a0, $a0, 1  # Increment the address
    addi $t1, $t1, -1 # Decrement the counter
    bnez $t1, empty_buffer # Loop until the counter is zero




la $a0, PID_Buffer
la $a1,Total_Buffer
concatination_loop:

    	lb $t0, 0($a0)
    	beq $t0, $zero, StepOne# End of string
    	beq $t0, 10, StepOne# Newline, end of input
    	sb $t0,0($a1)
    	addi $a0, $a0, 1
    	addi $a1, $a1, 1
    	j concatination_loop
    
StepOne:
    li $t2, ':'  # ASCII for ':'
    sb $t2, 0($a1)  # Store ':' at the current position of Total_Buffer
    addi $a1, $a1, 1
    li $t2, ' '  # ASCII for space
    sb $t2, 0($a1)  # Store space after ':'
    addi $a1, $a1, 1
   la $a0, Test_Name_Buffer
    j Name_Buffer
	

Name_Buffer:
 
	lb $t0, 0($a0)
    	beq $t0, $zero, StepTwo# End of string
    	beq $t0, 10, StepTwo# Newline, end of input
    	sb $t0,0($a1)
    	addi $a0, $a0, 1
    	addi $a1, $a1, 1
    	j Name_Buffer
   
StepTwo:
    	li $t2, ','  # ASCII for ','
   	 sb $t2, 0($a1)  # Store ',' at the current position of Total_Buffer
    	addi $a1, $a1, 1
   	 li $t2, ' '  # ASCII for space
   	 sb $t2, 0($a1)  # Store space after ':'
   	 addi $a1, $a1, 1
	 la $a0, Test_Date_Buffer
	 j Date_Buffer
	 
Date_Buffer:
	
	lb $t0, 0($a0)
    	beq $t0, $zero, StepThree# End of string
    	beq $t0, 10, StepThree# Newline, end of input
    	sb $t0,0($a1)
    	addi $a0, $a0, 1
    	addi $a1, $a1, 1 
    	j Date_Buffer
    
StepThree:
    	li $t2, ','  # ASCII for ','
   	 sb $t2, 0($a1)  # Store ',' at the current position of Total_Buffer
    	addi $a1, $a1, 1
   	 li $t2, ' '  # ASCII for space
   	 sb $t2, 0($a1)  # Store space after ':'
   	 addi $a1, $a1, 1
	 la $a0, Test_Result_Buffer
	 j Result_Buffer
	 
Result_Buffer:
	
	lb $t0, 0($a0)
    	beq $t0, $zero, Check_Step4# End of string
    	beq $t0, 10, Check_Step4 # Newline, end of input
    	sb $t0,0($a1)
    	addi $a0, $a0, 1
    	addi $a1, $a1, 1 
    	j Result_Buffer
    	

ReadSecondResult:

   	
   	# Print result String
    	li $v0, 4
    	la $a0, ReadResultTwo
    	syscall

   	 # Read result string
   	li $v0, 8
    	la $a0, SecondResult
    	li $a1, 50
    	syscall
    	
    	j Check_Test_Result2
    	

Check_Test_Result2:
    # counter for number of dot's
    li $t1, 0 
    la $a1, SecondResult
      		
Digits_Counter_Result2:

    lb $t0, 0($a1) 
    beq $t0, $zero, Check_Result2# End of string
    beq $t0, 10, Check_Result2 # Newline, end of input
    beq $t0, 46, Check_dot2
    li $t4, 48 #'0'
    li $t5, 57 #'9'
    blt $t0, $t4, Result_Invalid # Non-digit
    bgt $t0, $t5, Result_Invalid # Non-digit
    addi $a1, $a1, 1
    j Digits_Counter_Result2
    
Check_Result2:
 	li $v0, 4
    	la $a0, Valid_Result
    	syscall 
    
    	j FinalConcatinat	
    	  	  	
Check_dot2:
	addi $t1, $t1, 1 #increment dot counter by one 
	addi $a1, $a1, 1
	bgt  $t1, 1,Dot_Error2
	j Digits_Counter_Result2
	
Dot_Error2:
	li $v0, 4
    	la $a0, ErrorInDot
    	syscall
	li $v0, 4
    	la $a0, try_again
    	syscall
    	j Add_New_medical    	  	  	  	
    	  	  	  	  	
    	  	  	  	  	  	
Check_Step4:

	la $s1, Test_Name_Buffer
    	
    	addi $s1,$s1,1
    	lb $t8,0($s1)
    	beq $t8, 'P',StepFour
    	
    	j WriteToFile
   	  	  	  	  	  	  	
   	  	  	  	  	  	  	   	  	  	  	  	  	  	

StepFour:
    	li $t2, ','  # ASCII for ','
   	 sb $t2, 0($a1)  # Store ',' at the current position of Total_Buffer
    	addi $a1, $a1, 1
   	 li $t2, ' '  # ASCII for space
   	 sb $t2, 0($a1)  # Store space aft
   	 addi $a1, $a1, 1
	 la $a0, SecondResult
	 j Result_Buffer2
	 
Result_Buffer2:
	
	lb $t0, 0($a0)
    	beq $t0, $zero, WriteToFile# End of string
    	beq $t0, 10, WriteToFile # Newline, end of input
    	sb $t0,0($a1)
    	addi $a0, $a0, 1
    	addi $a1, $a1, 1 
    	j Result_Buffer2  	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	  	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	  	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	
   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	     	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	   	  	  	  	  	  	  	
    	    	    	    	    	    	    	    	    	    	    	    	
WriteToFile:
   # Open the file
    li $v0, 13  # System call for open file
    la $a0, filename  
    li $a1, 9  
    li $a2, 0 
    syscall
    move $t0, $v0 
    blez $t0, End_Program

    # Calculate the length of the string in Total_Buffer
    la $a0, Total_Buffer  
    li $t1, 0  
calculate_length:
    lb $t2, 0($a0)  
    beq $t2, $zero, finish_length_calculation 
    addiu $a0, $a0, 1  
    addiu $t1, $t1, 1  
    j calculate_length

finish_length_calculation:
   
    # Write to the file
    li $v0, 15  # System call for write to file
    move $a0, $t0  
    la $a1, Total_Buffer  
    move $a2, $t1  
    syscall

    # Write newline character to the file
    li $v0, 15         
    move $a0, $t0     
    la $a1, new_line  
    li $a2, 1          
    syscall  

  
    # Close the file
    li $v0, 16  # System call for close file
    move $a0, $t0  
    syscall
    
    j menu

    	
Check_dot:
	addi $t1, $t1, 1 #increment dot counter by one 
	addi $a1, $a1, 1
	bgt  $t1, 1,Dot_Error
	j Digits_Counter_Result
	
	
	
Dot_Error:
	li $v0, 4
    	la $a0, ErrorInDot
    	syscall
	li $v0, 4
    	la $a0, try_again
    	syscall
    	j Add_New_medical
        
        
        
Result_Invalid:

	li $v0, 4
        la $a0, InValid_Message
        syscall
        li $v0, 4
    	la $a0, try_again
    	syscall
    	j Add_New_medical
   
      
invalidMonth:
	li $v0, 4
        la $a0, MounthLengthError
        syscall
         li $v0, 4
    	la $a0, try_again
    	syscall
    	j Add_New_medical
        
date_Invalid:
	
	li $v0, 4
        la $a0, InValid_Message
        syscall
        li $v0, 4
    	la $a0, try_again
    	syscall
    	j Add_New_medical
	
nameLengthError:
    li $v0, 4
    la $a0, lengthErrorMsg
    syscall
    li $v0, 4
    la $a0, try_again
    syscall
    j Add_New_medical

charError:
    li $v0, 4
    la $a0, charErrorMsg
    syscall
    li $v0, 4
    la $a0, try_again
    syscall
    j Add_New_medical
   

Negative_Num:

    li $v0, 4
    la $a0, Negative_Message
    syscall
    li $v0, 4
    la $a0, try_again
    syscall
    j Add_New_medical

#message display the number entered is not 7 digits
Not_Seven_Digit:
    li $v0, 4
    la $a0, PID_Num_Of_Digit
    syscall
    li $v0, 4
    la $a0, try_again
    syscall
    j Add_New_medical

#Print Invalid message
PID_Invalid:
    li $v0, 4
    la $a0, PID_Num_Of_Digit
    syscall
    
    li $v0, 4
    la $a0, try_again
    syscall
    j Add_New_medical
 
 
 
Search_By_ID:
#print choose search option
  	li $v0, 4
    	la $a0, SearchOptions
    	syscall
    	
    	li $v0, 4
    	la $a0, Choose_One
    	syscall
    	
   #read user input
   	li $v0, 5 
	syscall
	# small menu 
	beq $v0,1,all_patient_tests
	beq $v0,2,all_upnormal_tests
	beq $v0,3,all_period_tests

all_patient_tests:
					
	jal readFromFile
	
# Prompt to enter PID
    li $v0, 4
    la $a0, PID
    syscall

    # Read PID from user
    li $v0, 8
    la $a0, PID_Buffer
    li $a1, 21
    syscall

la $s0,readBuffer # address of the buffer
la $s1,Temp_String

li $t4,0

Buffer_To_String:
	lb $t0, 0($s0)
	beq $t0, $zero,Compare_id# If null terminator, end of buffer reached
    	beq $t0, 10, Compare_id  # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_String
    	

Compare_id:

la $s1,Temp_String
la $s3, PID_Buffer
Loop:
	lb $t1,0($s1)
	lb $t2,0($s3)
	bne $t1,$t2,misMatch
	addi $s1,$s1,1
    	addi $s3,$s3,1
    	addi $t4,$t4,1
    	beq $t4,7,printMatch
    	j Loop
  
misMatch:
    	li $t4,0
    	j nextLine

printMatch:
	li $v0, 4             # syscall: print string
   	la $a0,Temp_String     # address of the buffer
    	syscall
    	
    	 # Print newline character 
	li $v0, 4             
    	la $a0, new_line   
   	syscall 

    	li $t4,0
    	j nextLine

nextLine:

    	la   $a0, Temp_String  # Load the address of the buffer into $a0
    	li   $t1, 50     # Load the size of the buffer into $t1

	empty_buffer2:
   	 li   $t0, 0       
   	 sb   $t0, 0($a0)  
    	addi $a0, $a0, 1 
    	addi $t1, $t1, -1 
    	bnez $t1, empty_buffer2 


	loop2:
	lb $t0, 0($s0)
	beq $t0, $zero,menu
    	beq $t0, 10, Next_Byte
    	addi $s0,$s0,1
    	j loop2 
    	   	
Next_Byte:
	la $s1,Temp_String
	addi $s0,$s0,1
	
	j Buffer_To_String


all_upnormal_tests:

    jal readFromFile
	
    
    # Prompt to enter PID
    li $v0, 4
    la $a0, PID
    syscall

    # Read PID from user
    li $v0, 8
    la $a0, PID_Buffer
    li $a1, 21
    syscall

	la $s0,readBuffer # address of the buffer
	la $s1,Temp_String
	# counter 
	li $t4,0

Buffer_To_String_UPnormal:
	lb $t0, 0($s0)
	beq $t0, $zero,Compare_id_UPnormal # If zero, end of buffer reached
    	beq $t0, 10, Compare_id_UPnormal  # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_String_UPnormal
    	

Compare_id_UPnormal:

la $s1,Temp_String
la $s3, PID_Buffer
Loop_UPnormal:
	lb $t1,0($s1)
	lb $t2,0($s3)
	bne $t1,$t2,misMatch_UPnormal
	addi $s1,$s1,1
    	addi $s3,$s3,1
    	addi $t4,$t4,1
    	beq $t4,7,printMatch_UPnormal
    	j Loop_UPnormal

 
misMatch_UPnormal:
    	li $t4,0
    	j nextLine_UPnormal

printMatch_UPnormal:
    	jal Extract_Test_Name_UPnormal
    	  	
    	j nextLine_UPnormal

nextLine_UPnormal:

	la   $a0, Temp_String  # Load the address of the buffer into $a0
    	li   $t1, 50    

	empty_buffer50:
   	 li   $t0, 0       
   	 sb   $t0, 0($a0)  
    	addi $a0, $a0, 1 
    	addi $t1, $t1, -1 
    	bnez $t1, empty_buffer50 


    	li $t4,0
    	
	loop2_UPnormal:
	lb $t0, 0($s0)
	beq $t0, $zero,menu
    	beq $t0, 10, Next_Byte_UPnormal
    	addi $s0,$s0,1
    	j loop2_UPnormal 
    	
    	
Next_Byte_UPnormal:
	la $s1,Temp_String
	addi $s0,$s0,1
	
	j Buffer_To_String_UPnormal
    	
    	
Extract_Test_Name_UPnormal: 
	
	
	la $s2,ExtractedResult
	
	addi $s1, $s1, 2	
	lb $t5, 0( $s1)
	beq $t5, 'H',Hgb_Test
	beq $t5, 'L',LDL_Test
	beq $t5, 'B',B_Tests

Extract_Result:
	
	lb $t6, 0( $s1)
    	beq $t6, 10, Choose_And_Compare
    	sb $t6, 0($s2)
    	addi $s1, $s1, 1
    	addi $s2, $s2, 1
    	j Extract_Result
    	
Choose_And_Compare:
	la $a0, ExtractedResult 
    	jal Str_Float  
    	
    beq $t5, 'H',Compare_HGB
    beq $t5, 'L',Compare_LDL
    beq $t5, 'G',Compare_BGT
    #beq $t5, 'P',Compare_BPT 		    		 
    		    		    		     		    		    		 
    		    		    		 
Hgb_Test:
	
	addi $s1, $s1, 14
	j Extract_Result
	
	
Compare_HGB:

	# Load low and high normal ranges into floating-point registers
	l.s $f20, Hgb_Normal_Low
	l.s $f21, Hgb_Normal_High

	# Compare the result with the high and low normal ranges
	c.lt.s $f12, $f20  
	bc1t upnormal    
	              
	c.lt.s $f21, $f12   
	bc1t upnormal    
	 
	
	j Normal_test
	
LDL_Test:

	addi $s1, $s1, 14
	j Extract_Result
	
Compare_LDL:

	# Load low and high normal ranges into floating-point registers
	l.s $f22, LDL_Normal_High

	# Compare the result with the high and low normal ranges
	c.lt.s $f22, $f12   
	bc1t upnormal     
	nop           
		
	j Normal_test	
			
B_Tests:
	addi $s1, $s1, 1
	lb $t5, 0($s1)
	beq $t5,'G',BGT_Test
	beq $t5,'P', BPT_Test

BGT_Test:
	
	addi $s1, $s1, 13
	j Extract_Result

BPT_Test:
	addi $s1, $s1, 13
	j Extract_Two_Results
	

Extract_Two_Results:
	
	la $s2,ExtractedResult
	
	Extract_Result1:		
	lb $t6, 0( $s1)
    	beq $t6, ',', Extract_Result2
    	sb $t6, 0($s2)
    	addi $s1, $s1, 1
    	addi $s2, $s2, 1
    	j Extract_Result1
    	
Extract_Result2:
	
	addi $s1, $s1, 2
	la $s4,SecondResult
	
	loop_to_extract:		
	lb $t6, 0( $s1)
    	beq $t6, 10, Compare_BPT
    	sb $t6, 0($s4)
    	addi $s1, $s1, 1
    	addi $s4, $s4, 1
    	j loop_to_extract
    						
									
															
Compare_BGT:

	# Load low and high normal ranges into floating-point registers
	l.s $f23, BGT_Normal_Low
	l.s $f24, BGT_Normal_High

	# Compare the result with the high and low normal ranges
	c.lt.s $f12, $f23  
	bc1t upnormal     
	              
	c.lt.s $f24, $f12   
	bc1t upnormal     
	 
	
	j Normal_test	

			
Compare_BPT:

	la $a0, ExtractedResult 
    	jal Str_Float

	# Load low and high normal ranges into floating-point registers
	l.s $f25, BPT_Normal_Dia
	l.s $f26, BPT_Normal_Sys

	# Compare the result with the high and low normal ranges
	c.lt.s $f25, $f12  
	bc1t upnormal     
	       
	la $a0,SecondResult
	jal Str_Float      
	c.lt.s $f26, $f12  
	bc1t upnormal    
	
	j Normal_test
	
				
										
upnormal:
	
 	li $v0, 4            
   	la $a0,Temp_String     
    	syscall
    	
    	 # Print newline character 
	li $v0, 4             
    	la $a0, new_line    
   	syscall 
   	
   	
    	la   $a0, Temp_String  
    	li   $t1, 50     

	empty_buffer3:
    	li   $t0, 0       
    	sb   $t0, 0($a0)  
    	addi $a0, $a0, 1  
    	addi $t1, $t1, -1 
   	bnez $t1, empty_buffer3 
    	
    	j nextLine_UPnormal
	
Normal_test:
    	
    	j nextLine_UPnormal	
 
 
all_period_tests:

	jal readFromFile

	 # Prompt to enter PID
    li $v0, 4
    la $a0, PID
    syscall

    # Read PID from user
    li $v0, 8
    la $a0, PID_Buffer
    li $a1, 21
    syscall
    
    	li $v0, 4
    	la $a0,Start_Period 
   	syscall 

   	li $v0, 8
        la $a0, Start_Date
   	li $a1, 50
    	syscall

	li $v0, 4
 	la $a0,End_Period 
    	syscall 

   	li $v0, 8
   	la $a0, End_Date
    	li $a1, 50
   	syscall
   	
la $s0,readBuffer # address of the buffer
la $s1,Temp_String

li $t4,0

Buffer_To_String_Period:
	lb $t0, 0($s0)
	beq $t0, $zero,Compare_id_Period# If null terminator, end of buffer reached
    	beq $t0, 10, Compare_id_Period # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_String_Period
    	

Compare_id_Period:

la $s1,Temp_String
la $s3, PID_Buffer
Loop_Period:
	lb $t1,0($s1)
	lb $t2,0($s3)
	bne $t1,$t2,misMatch_Period
	addi $s1,$s1,1
    	addi $s3,$s3,1
    	addi $t4,$t4,1
    	beq $t4,7,printMatch_Period
    	j Loop_Period
  

 
misMatch_Period:
    	li $t4,0
    	j nextLine_Period

printMatch_Period:

	jal Extract_And_Compare_Date
	
    	j nextLine_Period

nextLine_Period:

	la   $a0, Temp_String  
    	li   $t1, 50     

	empty_buffer4:
   	li   $t0, 0       
   	sb   $t0, 0($a0) 
    	addi $a0, $a0, 1  
   	addi $t1, $t1, -1 
   	bnez $t1, empty_buffer4 # Loop until the counter is zero

	li $t4,0

	loop2_Period:
	lb $t0, 0($s0)
	beq $t0, $zero,menu
    	beq $t0, 10, Next_Byte_Period
    	addi $s0,$s0,1
    	j loop2_Period 
    	
    	
Next_Byte_Period:
	la $s1,Temp_String
	addi $s0,$s0,1
	
	j Buffer_To_String_Period

	  
        
            
Extract_And_Compare_Date:
	
	la $s2,ExtractedDate
	addi $s1, $s1, 7	
	
	j Extract_Date
	
Extract_Date:
	
	lb $t6, 0( $s1)
    	beq $t6, ',', Compare_Year
    	sb $t6, 0($s2)
    	addi $s1, $s1, 1
    	addi $s2, $s2, 1
    	j Extract_Date

Compare_Year:

	la $s2,ExtractedDate
	la $s4,Start_Date

	Start_Year_Loop:
	lb $t7, 0( $s2)
	lb $t8, 0( $s4)
	beq $t7, '-',Ending
	blt $t7, $t8, nextLine_Period
	addi $s2, $s2, 1
    	addi $s4, $s4, 1
	j Start_Year_Loop
    	
	
Ending:	
	la $s2,ExtractedDate
	la $s5,End_Date
	
	End_Year_Loop:
	lb $t7, 0( $s2)
	lb $t8, 0( $s5)
	beq $t7, '-',Check_Equality
	bgt $t7, $t8, nextLine_Period
	addi $s2, $s2, 1
    	addi $s5, $s5, 1
	j End_Year_Loop
	
	
Check_Equality:	

	la $s2,ExtractedDate
	la $s4,Start_Date
	la $s5,End_Date
	
	li $t7,0 # counter for start period ( to check equality)
	
	start_equality:
		lb $t4, 0( $s2)
		lb $t9, 0( $s4)
		beq $t4, '-',Check_End_Equality
		beq $t4, $t9, Start_Count
		addi $s2, $s2, 1
    		addi $s4, $s4, 1
		j start_equality
	

Start_Count: 
	
	addi $t7,$t7,1
	beq $t7, 4, Check_Mounth_Start
	
	addi $s2, $s2, 1
    	addi $s4, $s4, 1
    	
    	j start_equality

Check_End_Equality:


	la $s2,ExtractedDate
	
	li $t8,0 # counter for end period ( to check equality)

	End_equality:
		lb $t4, 0( $s2)
		lb $t9, 0( $s5)
		beq $t4, '-', Print_Line_Test
		beq $t4, $t9, End_Count
		addi $s2, $s2, 1
    		addi $s5, $s5, 1
		j End_equality
	
End_Count:
	addi $t8,$t8,1
	beq $t8, 4, Check_Mounth_End
	
	addi $s2, $s2, 1
    	addi $s5, $s5, 1
    	
    	j End_equality	

	
Check_Mounth_Start:
	addi $s2, $s2, 2
    	addi $s4, $s4, 2
    	
    	loop_Mounth_start:
    	lb $t4, 0( $s2)
	lb $t9, 0( $s4)
    	beq $t4, $zero,Check_End_Equality
    	blt $t4, $t9, nextLine_Period
    	addi $s2, $s2, 1
    	addi $s4, $s4, 1
    	j loop_Mounth_start
	
	
	
Check_Mounth_End:
	
	addi $s2, $s2, 2
    	addi $s5, $s5, 2
    	
    	loop_Mounth_end:
    	 	
    	lb $t4, 0( $s2)
	lb $t9, 0( $s5)	
    	
    	beq $t4, $zero,Print_Line_Test
    	bgt $t4, $t9, nextLine_Period
    	bgt $t9, $t4, Print_Line_Test
    	
    	addi $s2, $s2, 1
    	addi $s5, $s5, 1
    	j loop_Mounth_end
						
Print_Line_Test:
	
	li $v0, 4             # syscall: print string
   	la $a0,Temp_String    # address of the buffer
    	syscall
    	

    	 # Print newline character 
	li $v0, 4             # syscall: print string
    	la $a0, new_line    # address of newline character
   	syscall  
        	
    	jr $ra

Search_Unnormal:

	jal readFromFile


    li $v0, 4
    la $a0,P_TestName 
    syscall

   
    li $v0, 8
    la $a0, Test_Name_Buffer
    li $a1, 21
    syscall
 
la $s0,readBuffer # address of the buffer
la $s1,Temp_String
# counter 
li $t4,0

Buffer_To_Temp:
	lb $t0, 0($s0)
	beq $t0, $zero,Extract_TEST_Name #f null terminator, end of buffer reached
    	beq $t0, 10, Extract_TEST_Name  # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_Temp   	
    	
Extract_TEST_Name :
    	la $s1,Temp_String
    	la $s2 Test_Name_Buffer
    	addi $s1,$s1,9
    	
    	Compare_Name_Loop:
    		lb $t0,0($s1)
    		lb $t1,0($s2)
    		beq $t0,',',Extract_Test_Result
    		bne $t0,$t1,move_to_next_line
    		addi $s2,$s2,1
    		addi $s1,$s1,1
    		j Compare_Name_Loop

Extract_Test_Result:
	addi $s1,$s1,11
	la $s3,ExtractedResult
	
   	la $s2 Test_Name_Buffer	
   	lb $t5,1($s2)
	beq $t5, 'P',Jump_Here	
	loop_to_extract_result:
		lb $t2, 0( $s1)
    		beq $t2, 10, Choose_And_Compare2
    		sb $t2, 0($s3)
    		addi $s1, $s1, 1
    		addi $s3, $s3, 1
    		j loop_to_extract_result
    		
Choose_And_Compare2:    
	la $s2 Test_Name_Buffer
   	lb $t4,0($s2)
   			    		 
    	beq $t4, 'H',Compare_HGB_all_Patients
    	beq $t4, 'L',Compare_LDL_all_Patients
    	beq $t5, 'G',Compare_BGT_all_Patients		
    	    		    		     		    		    		 
    		    		    	
Compare_HGB_all_Patients:
	
	la $a0, ExtractedResult
   	jal Str_Float 
   	
	# Load low and high normal ranges into floating-point registers
	l.s $f1, Hgb_Normal_Low
	l.s $f2, Hgb_Normal_High

	# Compare the result with the high and low normal ranges
	c.lt.s $f12, $f1   
	bc1t upnormal_all_Patients     
	              
	c.lt.s $f2, $f12   
	bc1t upnormal_all_Patients     
	 
	
	j Normal_test_all_Patients

	
Compare_LDL_all_Patients:
	
	la $a0, ExtractedResult
   	jal Str_Float 
   	
	# Load low and high normal ranges into floating-point registers
	l.s $f1, LDL_Normal_High

	# Compare the result with the high and low normal ranges
	c.lt.s $f1, $f12   
	bc1t upnormal_all_Patients     
	nop               		
	j Normal_test_all_Patients	
			


	
Compare_BGT_all_Patients:
	
	la $a0, ExtractedResult
   	jal Str_Float 
   	
	# Load low and high normal ranges into floating-point registers
	l.s $f1, BGT_Normal_Low
	l.s $f2, BGT_Normal_High

	# Compare the result with the high and low normal ranges
	c.lt.s $f12, $f1   
	bc1t upnormal_all_Patients    
	                        
	c.lt.s $f2, $f12   
	bc1t upnormal_all_Patients     
	 
	
	j Normal_test_all_Patients	

			
						
Jump_Here:
						
 la $s2,ExtractedResult
 
	 Extract_Result1_all_Patients:		
	lb $t6, 0( $s1)
    	beq $t6, ',', Extract_Result2_all_Patients
    	sb $t6, 0($s2)
    	addi $s1, $s1, 1
    	addi $s2, $s2, 1
    	j Extract_Result1_all_Patients
    	
Extract_Result2_all_Patients:

	addi $s1, $s1, 2
	la $s4,SecondResult
	
	
	loop_to_extract_all_Patients:		
	lb $t6, 0( $s1)
    	beq $t6, 10, Compare_BPT_all_Patients
    	sb $t6, 0($s4)
    	addi $s1, $s1, 1
    	addi $s4, $s4, 1
    	j loop_to_extract_all_Patients
    	
    																															
Compare_BPT_all_Patients:

la $a0,ExtractedResult
	jal Str_Float   
	l.s $f1, BPT_Normal_Dia
	l.s $f2, BPT_Normal_Sys

	# Compare the result with the high and low normal ranges
	c.lt.s $f2, $f12   
	bc1t upnormal_all_Patients   
	       
	la $a0,SecondResult
	jal Str_Float      
	c.lt.s $f1, $f12   
	bc1t upnormal_all_Patients     
	
	j Normal_test_all_Patients
	
				
										
upnormal_all_Patients:
	 	
 	li $v0, 4             # syscall: print string
   	la $a0,Temp_String     # address of the buffer
    	syscall
    	
    	 # Print newline character 
	li $v0, 4             # syscall: print string
    	la $a0, new_line    # address of newline character
    	syscall
    	
    	j move_to_next_line
	
Normal_test_all_Patients:

    	j move_to_next_line
    		
move_to_next_line:
	loop2_all_Patients:
	lb $t0, 0($s0)
	beq $t0, $zero,menu
    	beq $t0, 10, Next_Byte_all_Patients
    	addi $s0,$s0,1
    	j loop2_all_Patients 
    	
    	
Next_Byte_all_Patients:
    la   $a0, Temp_String 
    li   $t1, 50     

empty_buffer5:
    li   $t0, 0       
    sb   $t0, 0($a0)  
    addi $a0, $a0, 1  
    addi $t1, $t1, -1 
    bnez $t1, empty_buffer5 

	la $s1,Temp_String
	addi $s0,$s0,1
	
	j Buffer_To_Temp
	

	
Average_test_value:

	jal readFromFile

la $s0,readBuffer # address of the buffer
la $s1,Temp_String #address of temp lin

l.s $f5,initialize #counter for hgb
l.s $f6,initialize #counter for ldl
l.s $f7,initialize #counter for bgt
l.s $f8,initialize #counter for bpt
l.s $f15,initialize #counter for bpt second

l.s $f9, initialize #sum of hgb
l.s $f10, initialize #sum of ldl
l.s $f11, initialize #sum of bgt
l.s $f13, initialize #sum of bpt
l.s $f16, initialize #sum of bpt second

l.s $f14,one_float

Buffer_To_Temp_Avg:
	lb $t0, 0($s0)
	beq $t0, $zero,calc_avg#f null terminator, end of buffer reached
    	beq $t0, 10, Check_Test_Name_Avg # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_Temp_Avg	

Check_Test_Name_Avg:
    
	la $s1,Temp_String
	addi $s1,$s1,9
	lb $t1,0($s1)
	
	beq $t1,'H',Hgb_counter
	beq $t1,'L',LDL_counter
	beq $t1,'B',Bs_counter
	
Hgb_counter:
	
	add.s $f5,$f5,$f14
	addi $s1,$s1,14
	j Extract_Result_Avg

LDL_counter:
	add.s $f6,$f6,$f14	
	addi $s1,$s1,14
	j Extract_Result_Avg	
	 
Bs_counter:
	addi $s1,$s1,1
	lb $t1,0($s1)	 			 				 			 					 				 			 			 			 				 			 			 			 				 			 		
	beq $t1,'G',BGT_counter
	beq $t1,'P',BPT_counter			 			 		
	 			 			 			 		
BGT_counter:
	add.s $f7,$f7,$f14	
	addi $s1,$s1,13
	j Extract_Result_Avg	

BPT_counter:
	add.s $f8,$f8,$f14
	add.s $f15,$f15,$f14	
	addi $s1,$s1,13
	j Extract_BPT_Results	

Extract_Result_Avg:
	
	la $s3,ExtractedResult
	
	loop_to_extract_result_Avg:
		lb $t2, 0( $s1)
    		beq $t2, 10, Choose_Sum
    		sb $t2, 0($s3)
    		addi $s1, $s1, 1
    		addi $s3, $s3, 1
    		j loop_to_extract_result_Avg	 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 			 		

Choose_Sum:
	
	beq $t1,'H',Hgb_Sum
	beq $t1,'L',LDL_Sum
	beq $t1,'G',BGT_Sum
	beq $t1,'P',BPT_Sum

Hgb_Sum:
	
	la $a0,ExtractedResult
	jal Str_Float
	
	add.s $f9,$f9,$f12
	
	j next_line

LDL_Sum:
	la $a0,ExtractedResult
	jal Str_Float
	add.s $f10,$f10,$f12
	j next_line

BGT_Sum:
	la $a0,ExtractedResult
	jal Str_Float
	add.s $f11,$f11,$f12
	j next_line

BPT_Sum:
	la $a0,ExtractedResult	
	jal Str_Float
	add.s $f13,$f13,$f12
	
	la $a0,SecondResult	
	jal Str_Float
	add.s $f16,$f16,$f12
	
	j next_line

Extract_BPT_Results:
	la $s3,ExtractedResult
	
	loop_first:
	lb $t2, 0( $s1)
    	beq $t2, ',', loop_second
    	sb $t2, 0($s3)
    	addi $s1, $s1, 1
    	addi $s3, $s3, 1
	j loop_first

loop_second:

la $s4,SecondResult
addi $s1, $s1, 2

	loop_extract: 
	lb $t2, 0( $s1)
    	beq $t2, 10, Choose_Sum
    	sb $t2, 0($s4)
    	addi $s1, $s1, 1
    	addi $s4, $s4, 1
	j loop_extract		

next_line:
	loop22:
	lb $t0, 0($s0)
	beq $t0, $zero,calc_avg
    	beq $t0, 10, Next_Byte_Avg
    	addi $s0,$s0,1
    	j loop22 
    	
    	
Next_Byte_Avg:
	la $s1,Temp_String
	addi $s0,$s0,1

	
	la   $a0, Temp_String  # Load the address of the buffer into $a0
    	li   $t1, 50     # Load the size of the buffer into $t1

	empty_buffer47:
   	li   $t0, 0     
    	sb   $t0, 0($a0)  
   	addi $a0, $a0, 1  
   	addi $t1, $t1, -1 
   	bnez $t1, empty_buffer47 
	
	j Buffer_To_Temp_Avg

calc_avg:

	li $v0, 4             # syscall: print string
   	la $a0,Average_for_Hgb     # address of the buffer
    	syscall

	div.s $f12,$f9,$f5
	li $v0,2
	syscall
	
	 li $v0, 11          # syscall code for printing character
   	 li $a0, 10          # ASCII value for newline
    	syscall
	
	
	li $v0, 4             # syscall: print string
   	la $a0,Average_for_LDL     # address of the buffer
    	syscall
    	
	div.s $f12,$f10,$f6
	li $v0,2
	syscall
	
	li $v0, 11          # syscall code for printing character
        li $a0, 10          # ASCII value for newline
    	syscall
    	
    	li $v0, 4             # syscall: print string
   	la $a0,Average_for_BGT     # address of the buffer
    	syscall
    	
	div.s $f12,$f11,$f7
	li $v0,2
	syscall
	
	li $v0, 11          # syscall code for printing character
   	li $a0, 10          # ASCII value for newline
    	syscall
    	
    	li $v0, 4             # syscall: print string
   	la $a0,Average_for_BPT     # address of the buffer
    	syscall
	
	div.s $f12,$f13,$f8
	li $v0,2
	syscall
	
	li $v0, 11          # syscall code for printing character
   	li $a0, 10          # ASCII value for newline
        syscall
        
        li $v0, 4             # syscall: print string
   	la $a0,Average_for_BPT2     # address of the buffer
    	syscall
    	
    	div.s $f12,$f16,$f15
	li $v0,2
	syscall
	
	li $v0, 11          # syscall code for printing character
   	li $a0, 10          # ASCII value for newline
    	syscall
j menu


	
Update:
	jal readFromFile

Print_Lines:
la $s0,readBuffer
la $s1,Temp_String
li $t4,1 #counter
		
		
	Buffer_To_Temp_update:
	lb $t0, 0($s0)
	beq $t0, $zero,read_data#f null terminator, end of buffer reached
    	beq $t0, 10,Print_temp # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_Temp_update	

Print_temp :
	move $a0,$t4
	li $v0,1
	syscall	
		
    	
    	li $a0, '.'              # Prepare to print colon and space after line number
    	li $v0, 11                 # syscall for printing string
    	syscall
    	
    	li $a0, ' '              # Prepare to print colon and space after line number
    	li $v0, 11                 # syscall for printing string
    	syscall
    	
    	li $v0, 4             # syscall: print string
   	la $a0,Temp_String     # address of the buffer
    	syscall	
    	
    	
    	 la   $a0, Temp_String  # Load the address of the buffer into $a0
    	li   $t1, 50     # Load the size of the buffer into $t1

empty_buffer8:
    li   $t0, 0       # Load zero into $t0
    sb   $t0, 0($a0)  # Store byte of zero at the address in $a0
    addi $a0, $a0, 1  # Increment the address
    addi $t1, $t1, -1 # Decrement the counter
    bnez $t1, empty_buffer8 # Loop until the counter is zero

	la $s1,Temp_String
j go_to_nextline_update


go_to_nextline_update:
	
	loop_update:
	lb $t0, 0($s0)
	beq $t0, $zero,read_data
    	beq $t0, 10, Next_Byte_update
    	addi $s0,$s0,1
    	j loop_update 
    	
    	
Next_Byte_update:
	la $s1,Temp_String
	addi $t4,$t4,1
    	addi $s0,$s0,1
	# Print newline character 
	li $v0, 4             # syscall: print string
    	la $a0, new_line    # address of newline character
   	syscall
   	
	j Buffer_To_Temp_update



read_data:


       li $v0, 4 # syscall code for print string
       la $a0, askFornumber
       syscall   
       
       li $v0, 5  # Read Integer
       syscall	
       
       li $t1,1 #counter to get correct line 
       
la $s0,readBuffer
la $s1,Temp_String

        Find_line_loop:
        bne $v0,$t1, next_line_update 
        beq $v0,$t1, To_update   # get line to update  
    	j Find_line_loop	
            
       
next_line_update:

        loop25:
	lb $t0, 0($s0)
	beq $t0, $zero,menu
    	beq $t0, 10, Next_Byte_for_update
    	addi $s0,$s0,1
    	j loop25 
    	
    	
Next_Byte_for_update:
	addi $s0,$s0,1
	addi $t1,$t1,1
	
	j Find_line_loop
       
To_update:	
	
	addi $s0, $s0, 10	
	lb $t5, 0( $s0)
	beq $t5, 'g',Update_Date_Value
	beq $t5, 'D',Update_Date_Value
	beq $t5, 'G',Update_Date_Value
	beq $t5, 'P',Update_Date_TwoValue
	
Update_Date_Value:
		
       # Enter Result	
       li $v0, 4 	    
       la $a0, PTestResult 
       syscall 

       li $v0, 8
       la $a0, Test_Result_Buffer
       li $a1, 15
       syscall

       # Enter Date
       li $v0, 4 	    
       la $a0, PTestDate 
       syscall   
	        
       li $v0, 8
       la $a0, Test_Date_Buffer
       li $a1, 21 
       syscall
       
       
       addi $s0, $s0, 4
       
       la $s3,Test_Date_Buffer
      	
       Update_Date:		
       lb $t6, 0( $s3)
       lb $t5, 0( $s0)
       beq $t5, ',', To_Update_Result
       sb $t6, 0($s0)
       addi $s0, $s0, 1
       addi $s3, $s3, 1
       j Update_Date		

      
        
To_Update_Result:   
    
        addi $s0, $s0, 2
      
        la $s2,Test_Result_Buffer
    
       Update_Result:		
       lb $t6, 0($s2)
       lb $t5, 0($s0)
       beq $t5, 10, Print_Temp_String
       sb $t6, 0($s0)
       addi $s0, $s0, 1
       addi $s2, $s2, 1
       j Update_Result
       
Print_Temp_String:
	
	
	#li $v0, 4             # syscall: print string
   	#la $a0,Temp_String     # address of the buffer
    	#syscall	
la $s0,readBuffer
la $s1,Temp_String

	move_to_tempString:
	lb $t0, 0($s0)
	beq $t0, $zero,menu#f null terminator, end of buffer reached
    	beq $t0, 10,WriteToFile2 # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j move_to_tempString
    	
    			
   	
WriteToFile2:
   # Open the file
    li $v0, 13  # System call for open file
    la $a0, filename  # Address of the filename
    li $a1, 1  # Flag for write
    li $a2, 0  # Mode
    syscall
    move $t0, $v0  # Save the file descriptor
    blez $t0, End_Program

    # Calculate the length of the string in Total_Buffer
    la $a0, readBuffer  # Load the address of Total_Buffer
    li $t1, 0  # Initialize counter
calculate_length2:
    lb $t2, 0($a0)  # Load a byte from Total_Buffer
    beq $t2, $zero, finish_length_calculation2  # End of string
    addiu $a0, $a0, 1  # Move to the next byte
    addiu $t1, $t1, 1  # Increment counter
    j calculate_length2

finish_length_calculation2:
    # Now $t1 contains the length of the string

    # Write to the file
    li $v0, 15  # System call for write to file
    move $a0, $t0  # File descriptor
    la $a1, readBuffer  # Address of the buffer to write
    move $a2, $t1  # Number of bytes to write (calculated length)
    syscall

    # Write newline character to the file
    li $v0, 15         # syscall code for 'write'
    move $a0, $t0      # file descriptor
    la $a1, new_line    # address of newline character
    li $a2, 1          # number of bytes to write (1 byte for newline character)
    syscall            # invoke syscall to write newline character to file

  
    # Close the file
    li $v0, 16  # System call for close file
    move $a0, $t0  # File descriptor
    syscall

next_line_file:

        loop26:
	lb $t0, 0($s0)
	beq $t0, $zero,menu
    	beq $t0, 10, Next_Byte_for_file
    	addi $s0,$s0,1
    	j loop26 
    	
    	
Next_Byte_for_file:
	addi $s0,$s0,1
	
	j move_to_tempString
    			
																

Update_Date_TwoValue:

	# Enter Result	
       li $v0, 4 	    
       la $a0, PTestResult 
       syscall 

       li $v0, 8
       la $a0, Test_Result_Buffer
       li $a1, 15
       syscall
       
       	# Enter Second Result	
       li $v0, 4 	    
       la $a0, PTestSecondResult 
       syscall 

       li $v0, 8
       la $a0, SecondResult
       li $a1, 50
       syscall
       
       # Enter Date
       li $v0, 4 	    
       la $a0, PTestDate 
       syscall   
	        
       li $v0, 8
       la $a0, Test_Date_Buffer
       li $a1, 21 
       syscall
       
       
       addi $s0, $s0, 4
       
       la $s3,Test_Date_Buffer
      	
       Update_Date2:		
       lb $t6, 0( $s3)
       lb $t5, 0( $s0)
       beq $t5, ',', To_Update_First_Result
       sb $t6, 0($s0)
       addi $s0, $s0, 1
       addi $s3, $s3, 1
       j Update_Date2		

      
        
To_Update_First_Result:   
    
       addi $s0, $s0, 2
      
       la $s2,Test_Result_Buffer
    
        Update_Result2:		
       lb $t6, 0($s2)
       lb $t5, 0($s0)
       beq $t5, ',', To_Update_Second_Result
       sb $t6, 0($s0)
       addi $s0, $s0, 1
       addi $s2, $s2, 1
       j Update_Result2	 		
	 			 		
	 			 			 		
To_Update_Second_Result:

	addi $s0, $s0, 2
	la $s4,SecondResult
	
	Update_Result3:	
	lb $t6, 0($s4)
        lb $t5, 0($s0)
        beq $t5, 10, Print_Temp_String
        sb $t6, 0($s0)
        addi $s0, $s0, 1
        addi $s4, $s4, 1
    	j Update_Result3
		 			 			 			 			 			 			 			 		
	 			 			 			 			 		
Delete:

	jal readFromFile

Print_Lines2:
la $s0,readBuffer
la $s1,Temp_String
li $t4,1 #counter
		
		
	Buffer_To_Temp_delete:
	lb $t0, 0($s0)
	beq $t0, $zero,read_input_delete#f null terminator, end of buffer reached
    	beq $t0, 10,Print_temp_delete # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s0,$s0,1
    	addi $s1,$s1,1
    	j Buffer_To_Temp_delete	

Print_temp_delete :
	move $a0,$t4
	li $v0,1
	syscall	
		
    	
    	li $a0, '.'              # Prepare to print colon and space after line number
    	li $v0, 11                 # syscall for printing string
    	syscall
    	
    	li $a0, ' '              # Prepare to print colon and space after line number
    	li $v0, 11                 # syscall for printing string
    	syscall
    	
    	li $v0, 4             # syscall: print string
   	la $a0,Temp_String     # address of the buffer
    	syscall	
    	
    	
    	la   $a0, Temp_String  # Load the address of the buffer into $a0
    	li   $t1, 50     # Load the size of the buffer into $t1

empty_buffer9:
    li   $t0, 0       # Load zero into $t0
    sb   $t0, 0($a0)  # Store byte of zero at the address in $a0
    addi $a0, $a0, 1  # Increment the address
    addi $t1, $t1, -1 # Decrement the counter
    bnez $t1, empty_buffer9 # Loop until the counter is zero

	la $s1,Temp_String
j go_to_nextline_delete


go_to_nextline_delete:
	
	loop_delete:
	lb $t0, 0($s0)
	beq $t0, $zero,read_input_delete
    	beq $t0, 10, Next_Byte_delete
    	addi $s0,$s0,1
    	j loop_delete 
    	
    	
Next_Byte_delete:
	la $s1,Temp_String
	addi $t4,$t4,1
    	addi $s0,$s0,1
	# Print newline character 
	li $v0, 4             # syscall: print string
    	la $a0, new_line    # address of newline character
   	syscall
   	
	j Buffer_To_Temp_delete	 	
	 			 			 			 			 			 		
	
	 			 			 			 			 			 				 			 			 			 			 		
read_input_delete:

	 			 			 			 			 			 				 			 			 			 			 		 			 			 			 			 			 				 			 			 			 			 		 			 			 			 			 			 				 			 			 			 			 				 			 			 			 			 			 				 			 			 			 			 		 			 			 			 			 			 				 			 			 			 			 		 			 			 			 			 			 				 			 			 			 			 		
       li $v0, 4 # syscall code for print string
       la $a0, askFornumber
       syscall   
       
       li $v0, 5  # Read Integer
       syscall
       
       li $t1,1 #counter to get correct line 
       
la $s0,readBuffer
la $s5,Total_Buffer

        Find_line_loop_for_delete:
        bne $v0,$t1, move_to_another_buffer 
        beq $v0,$t1, Line_to_skip  
    	j Find_line_loop_for_delete	
            
       
Line_to_skip:

        loop30:
	lb $t0, 0($s0)
	beq $t0, $zero,Print_Total_Buffer
    	beq $t0, 10, Next_Byte_for_delete2
    	addi $s0,$s0,1
    	j loop30 
    	
    	
Next_Byte_for_delete2:
	addi $s0,$s0,1
	addi $t1,$t1,1
	
	j Find_line_loop_for_delete
       
move_to_another_buffer:


	move_to_TotalBuffer:
	lb $t0, 0($s0)
	beq $t0, $zero,Print_Total_Buffer#f null terminator, end of buffer reached
    	beq $t0, 10,Add_New_Line # If newline character, end of line reached
    	sb $t0, 0($s5)
    	addi $s0,$s0,1
    	addi $s5,$s5,1
    	j move_to_TotalBuffer
              
                  
Add_New_Line:
	
	li $t2, 10 
	sb $t2, 0($s5)
	
	addi $s5,$s5,1
	
	j Line_to_skip
	

	      
	      	      
Print_Total_Buffer:	      	      	      
	      	      	      	      
la $s5,Total_Buffer
la $s1,Temp_String

	move_to_tempString2:
	lb $t0, 0($s5)
	beq $t0, $zero,WriteToFile3#f null terminator, end of buffer reached
    	beq $t0, 10,WriteToFile3 # If newline character, end of line reached
    	sb $t0, 0($s1)
    	addi $s5,$s5,1
    	addi $s1,$s1,1
    	j move_to_tempString2      	      	      	      	      
	      	      	      	      	      	      
   	      	      	      	      	      	      	      	      	      	      	      	      
WriteToFile3:

              
     # Open the file
    li $v0, 13  # System call for open file
    la $a0, filename  # Address of the filename
    li $a1, 1  # Flag for write
    li $a2, 0  # Mode
    syscall
    move $t0, $v0  # Save the file descriptor
    blez $t0, End_Program

    # Calculate the length of the string in Total_Buffer
    la $a0, Total_Buffer  # Load the address of Total_Buffer
    li $t1, 0  # Initialize counter
calculate_length3:
    lb $t2, 0($a0)  # Load a byte from Total_Buffer
    beq $t2, $zero, finish_length_calculation3  # End of string
    addiu $a0, $a0, 1  # Move to the next byte
    addiu $t1, $t1, 1  # Increment counter
    j calculate_length3

finish_length_calculation3:
    # Now $t1 contains the length of the string

    # Write to the file
    li $v0, 15  # System call for write to file
    move $a0, $t0  # File descriptor
    la $a1, Total_Buffer  # Address of the buffer to write
    move $a2, $t1  # Number of bytes to write (calculated length)
    syscall

    # Write newline character to the file
    li $v0, 15         # syscall code for 'write'
    move $a0, $t0      # file descriptor
    la $a1, new_line    # address of newline character
    li $a2, 1          # number of bytes to write (1 byte for newline character)
    syscall            # invoke syscall to write newline character to file

  
    # Close the file
    li $v0, 16  # System call for close file
    move $a0, $t0  # File descriptor
    syscall
       
       
       
       
        			 			 			 			 			 				 			 			 			 			 				 			 			 			 			 		
        j menu			 			 			 			 			 				 			 			 			 			 				 			 			 			 			 		 			 			 			 			 			 				 			 			 			 			 				 			 			 			 			 		 			 			 			 			 			 				 			 			 			 			 				 			 			 			 			 		
	 			 			 			 			 			 				 			 			 			 			 				 			 			 			 			 				 			 			 			 			 		
	 			 			 			 			 			 			 			 			 			 		
	 			 			 			 			 			 			 			 			 			 			 			 			 		
readFromFile: 
	li $v0,13# system call to open a file
	la $a0,filename# store the address of the file
	li $a1,0#set the flag to zero (read only)
	syscall

	move $t0,$v0#store the file descreptor
	li $v0,14#system call to read the file
	move $a0,$t0#load file descriptor
	la $a1,readBuffer# buffer to store the content of the file
	li $a2,3000#max number of characters to read 
	syscall
	
	# Print the line read
    	li $v0, 4             # syscall: print string
   	la $a0, readBuffer        # address of the buffer
    	syscall
    	
	move $a0,$t0#file descriptor
	li $v0,16#system call to close a file
	syscall
	
	jr $ra
		

Str_Float:
   
    li $t1, 0                
    li $t2, 0                
    li $t3, 10               
    li $t7, 1                

integer_part:
    lbu $t0, 0($a0)          
    beq $t0, $zero, convert_to_float 
    beq $t0, '.', fraction_part 
    subi $t0, $t0, '0'       
    mul $t1, $t1, $t3        
    add $t1, $t1, $t0        
    addi $a0, $a0, 1         
    j integer_part           

fraction_part:
    addi $a0, $a0, 1         
    lbu $t0, 0($a0)          
    beq $t0, $zero, convert_to_float 
    subi $t0, $t0, '0'       
    mul $t2, $t2, $t3        
    add $t2, $t2, $t0        
    mul $t7, $t7, $t3        
    addi $a0, $a0, 1         
    j fraction_part          

convert_to_float:
    mtc1 $t1, $f1            
    cvt.s.w $f1, $f1         
    mtc1 $t2, $f2            
    cvt.s.w $f2, $f2        
    mtc1 $t7, $f3            
    cvt.s.w $f3, $f3         
    div.s $f2, $f2, $f3      

    add.s $f12, $f1, $f2     
   
   jr $ra
   
# End The progarm
End_Program:
	li $v0, 10 # Exit program
	syscall