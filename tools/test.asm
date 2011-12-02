# Echo program in asm for Aod8
# ----------------------------
#
# Any line starting with a '#' is a comment.
# Instruction format has to be the same as in the processor
# documentation. Unnecessary spaces in between are not allowed.
# Also, jumps & loops with a value 'X' more than 140 seems to give
# errors. So break it into multiple jumps/loops.

# scanf until the user presses Enter.
mov a,0
mov sp,a
nice:
input 
mov a,[sp]
cmp a,10
je done
inc sp
loop nice
done:

# print the entered string back
mov a,0
mov sp,a
duh:
mov a,[sp]
cmp a,10
# can also be done without labels
je 5
output 
inc sp
loop 8
over:
halt
