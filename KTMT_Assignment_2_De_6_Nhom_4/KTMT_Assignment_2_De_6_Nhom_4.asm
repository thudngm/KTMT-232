#Chuong trinh BTL2.D6: Selection sort 10 so nguyen
#-----------------------------------
#Data segment
		.data
		#Cac cau nhac nhap du lieu
str1:		.asciiz "Cac buoc sap xep: \n"
str2:		.asciiz "Mang can sap xep: "
str3:		.asciiz "Mang sau khi sap xep: "
str4:		.asciiz "\n"
str5:		.asciiz " "
str6:		.asciiz "\n Thoi gian chay: "
str7:		.asciiz "ms"
filename:	.asciiz "INT10.BIN"	# Tên tệp nhị phân
#-----------------------------------
#Code segment
		.text
		.globl	main
#-----------------------------------
#Chuong trinh chinh
#-----------------------------------
main: 	
		# Do thoi gian cua chuong trinh luu vao $a3
		li	$v0, 30
		syscall
		add	$a3, $zero, $a0
		
		li	$s2, 10			# $s2=10
		sll	$s0, $s2, 2		# $s0=n*4
		sub	$sp, $sp, $s0		# Lenh nay tao mot khung ngan xep du lon de chua mang

		# Mo tep nhi phan
		la	$a0, filename		# Dia chi cua ten tep
		li	$a1, 0			# Che do doc
		li	$v0, 13			# Ma he thong cho open
		syscall
		move	$s3, $v0		# Luu giu file descriptor

		# Doc du lieu tu tep nhi phan
		move	$s1, $zero		# i=0
for_get:	
		bge	$s1, $s2, exit_get	# neu i>=n di den exit_for_get
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $t0, $sp		# $t1=$sp+i*4

		move	$a0, $s3		# File descriptor
		move	$a1, $t1		# Buffer
		li	$a2, 4			# Kich thuoc
		li	$v0, 14			# Ma he thong cho read
		syscall

		addi	$s1, $s1, 1		# i=i+1
		j	for_get

exit_get:	
		# Dong tep nhi phan
		move	$a0, $s3		# File descriptor
		li	$v0, 16			# Ma he thong cho close
		syscall
		
		la	$a0, str2		# In chuoi str2
		li	$v0, 4
		syscall		
				
		move	$a0, $sp		# $a0=dia chi co so cua mang
		move	$a1, $s2		# $a1=kich thuoc cua mang
		jal	isort			# isort(a,n)
		# Tai thoi diem nay, mang da duoc sap xep va nam trong khung ngan xep	
		
		la	$a0, str3		# In chuoi str3
		li	$v0, 4
		syscall

		move	$s1, $zero		# i=0
for_print:	
		bge	$s1, $s2, exit_print	# neu i>=n di den exit_print
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $sp, $t0		# $t1=dia chi cua a[i]
		lw	$a0, 0($t1)		#
		li	$v0, 1			# in phan tu a[i]
		syscall				#

		la	$a0, str5		# In chuoi str5
		li	$v0, 4
		syscall
		
		addi	$s1, $s1, 1		# i=i+1
		j	for_print
		
exit_print:	
		add	$sp, $sp, $s0		# loai bo khung ngan xep
		
		#tinh thoi gian chay cua chuong trinh
		la	$a0, str6		# In "\n Thoi gian chay: "
		li	$v0, 4
		syscall
		li	$v0, 30
		syscall
		sub	$a0, $a0, $a3		# Tinh thoi gian chay $a0 = $a0 - $a3
		li	$v0, 1
		syscall
		la	$a0, str7		# In "ms"
		li	$v0, 4
		syscall
		              
		li	$v0, 10			# THOAT
		syscall			
# selection_sort
isort:		
		addi	$sp, $sp, -20		# luu giu gia tri vao ngan xep
		sw	$ra, 0($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		# dia chi co so cua mang
		move	$s1, $zero		# i=0
		
		subi 	$s2, $s2, 1
		jal 	print_array		# in mang can sap xep
		addi 	$s2, $s2, 1
		
		la	$a0, str1		# In chuoi str1
		li	$v0, 4
		syscall
		
		subi	$s2, $a1, 1		# do dai -1
isort_for:	
		bge 	$s1, $s2, isort_exit	# neu i >= do dai-1 -> thoat vong lap
		
		move	$a0, $s0		# dia chi co so
		move	$a1, $s1		# i
		move	$a2, $s2		# do dai - 1
		
		jal	mini
		move	$s3, $v0		# gia tri tra ve cua mini
		
		bne	$s1, $s3, do_swap	# neu i != mini -> thuc hien swap
		j	isort_continue		# nguoc lai, tiep tuc vong lap

do_swap:	
		move	$a0, $s0		# mang
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap
		jal 	print_array

isort_continue:	
		addi	$s1, $s1, 1		# i += 1
		j	isort_for		# quay lai dau vong lap
		
isort_exit:	
		lw	$ra, 0($sp)		# khoi phuc gia tri tu ngan xep
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		# khoi phuc con tro ngan xep
		jr	$ra			# tra ve

#-----------------------------------
#Cac chuong trinh con khac
#----------------------------------- 

# Tim index_minimum 
mini:		
		move	$t0, $a0		# co so cua mang
		move	$t1, $a1		# mini = dau tien = i
		move	$t2, $a2		# cuoi cung
		
		sll	$t3, $t1, 2		# dau tien * 4
		add	$t3, $t3, $t0		# index = mang co so + dau tien * 4		
		lw	$t4, 0($t3)		# min = v[dau tien]
		
		addi	$t5, $t1, 1		# i = 0
mini_for:	
		bgt	$t5, $t2, mini_end	# di den mini_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = mang co so + i * 4		
		lw	$t7, 0($t6)		# v[index]

		bge	$t7, $t4, mini_if_exit	# bo qua if khi v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	
		addi	$t5, $t5, 1		# i += 1
		j	mini_for
mini_end:	
		move 	$v0, $t1		# tra ve mini
		jr	$ra

# Swap
swap:		
		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw 	$t3, 0($t2) 		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra

# In mang
print_array:	
		move	$s4, $zero			# j=0
print_loop:	
		bgt	$s4, $s2, end_print_array	# neu j > do dai-1 -> thoat vong lap
		sll	$t0, $s4, 2			# $t0=j*4
		add	$t1, $t0, $s0			# $t1=$s0+j*4
		lw	$a0, 0($t1)		
		li	$v0, 1				# in phan tu a[j]
		syscall				

		la	$a0, str5
		li	$v0, 4
		syscall
		addi	$s4, $s4, 1			# j=j+1
		j	print_loop
end_print_array:	
		la	$a0, str4
		li	$v0, 4
		syscall
		jr	$ra
#----------------------------------- 
