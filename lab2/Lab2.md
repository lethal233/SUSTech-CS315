# Lab2

**Name: 黎诗龙**

**SID: **11811407

4. 

   (a) It will occur segmentation fault.

   ![image-20200917164539852](./pictures/image-20200917164539852.png)

   (b) It will occur segmentation fault in the command line, **but** it still can be run in the GDB. The return address changes.
   
   I add a sentence `print("Buffer address: %p", buffer)` in the function  `bufferOverflow`, which comes from my classmates Zunyao, Mao, to print the buffer address.
   
   ![image-20200918184038064](./pictures/image-20200918184038064.png)
   
   From the buffer address we can infer that the return address has been **changed**.
   
   
   
   ![image-20200917164832074](./pictures/image-20200917164832074.png)
   
   
   
   (c) They are not the same. 
   
   | method                                 | buffer[] address |
   | -------------------------------------- | ---------------- |
   | gdb BOF                                | 0xbffff204       |
   | /root/Desktop/Lab2-BufferOverflows/BOF | 0xbffff214       |
   | ./BOF                                  | 0xbffff274       |
   
   ![image-20200917170333048](./pictures/image-20200917170333048.png)



![image-20200917170401184](./pictures/image-20200917170401184.png)



![image-20200917170424398](./pictures/image-20200917170424398.png)

