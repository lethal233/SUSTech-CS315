# lab6 CS315

**Name: **黎诗龙

**SID: **11811407



## Part1

### 2a

I found it in the Zephyr official website: https://docs.zephyrproject.org/latest/security/security-overview.html#security-functionality 

The security functionality in Zephyr hinges mainly on the inclusion of cryptographic algorithms, and on its monolithic system design.

In the later release, Stack protection mechanisms are provided to protect against stack overruns. In addition, applications can take advantage of thread separation features to split the system into privileged and unprivileged execution environments. Memory protection features provide the capability to partition system resources (memory, peripheral address space, etc) and assign resources to individual threads or groups of threads. Stack, thread execution level, and memory protection constraints are enforced at the time of context switch.

### 2b

Both the application code and kernel code execute in a single shared address space.

[*Refer* to https://docs.zephyrproject.org/latest/introduction/index.html#distinguishing-features]

### 2c

**For non-executable stack**

This solution is from my classmate *Qiushi Nie*, who searched it online via http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-10023.

*The shell subsystem contains a buffer overflow, whereby an adversary with physical access to the device is able to cause a memory corruption, resulting in denial of service or possibly code execution within the Zephyr kernel. See NCC-NCC-019 This issue affects: zephyrproject-rtos zephyr version 1.14.0 and later versions. version 2.1.0 and later versions.*

Some versions doesn't have non-executable stack since code execution, DoS, and memory corruption can be done in them, according to the website. 



**For ASLR**

It doesn't have ASLR, for justification, I run the program twice and get the same `buffer` address. It means it doesn't have ASLR.

![image-20201109113524014](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109113524014.png)



<img src="C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109113557543.png" alt="image-20201109113557543" style="zoom:80%;" />

I have run it for 2 times, and every time it is `0x00103172`, so it doesn't have ASLR.

### 2d

Buffer overflow works, which is shown in the question 3.

### 3

I modify the `main.c` to this:

![image-20201109104418157](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109104418157.png)

And the `EIP` shows that I have succeeded, which is `0xdeadbeef`. 

![image-20201109104323645](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109104323645.png)



## Part2

This part seems like very easy to operate, but it indeed costed me **PLENTY** of TIME because of the hardware support problem! 

Windows has such bad support for this part, so I borrowed my roommate **MacBook** to do this part, and do this part2 with my teammates Jiaxi Zhang, Qiushi Nie, and Zunyao Mao.

### 2a

Monitor mode only applies to wireless networks. Monitor mode (RFMON) enables a wireless nic to capture packets without associating with an access point or ad-hoc network.



Promiscuous mode can be used on both wired and wireless networks. Promiscuous mode allows you to view all wireless packets on a network to which you have associated. The need to associate means that you must have some means of authenticating yourself with an access point. In promiscuous mode, you will not see packets until you have associated. Not all wireless drivers support promiscuous mode.



[**Refer** to http://lazysolutions.blogspot.com/2008/10/difference-promiscuous-vs-monitor-mode.html]

### 2b

The password should not be set as simple as `admin123`, `password`, and so on. It should be set complex, otherwise it is easy to attack.

### 3

**Note:** In this question I use airport in Mac by command `sudo airport en0 sniff 1` to capture the packets, since I always have trouble solving the problem by Wireshark.

`lslnb` is the WiFi name of my router, and I set the channel of my WiFi to 1.

I first set the password to `admin123`, which is on the list of the simple password, then using my phone to connect it, then capture the handshaking packets, and get the `.cap` files.

`aircrack-ng -w /usr/share/wordlists/fern-wifi/common.txt ~/Desktop/admin123.cap 
Opening /root/Desktop/admin123.cap`

From the picture we see that the 1 handshake.

![image-20201109031051708](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109031051708.png)

And choosing the WiFi that we want to crack:

![image-20201109031112453](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109031112453.png)

We can get the `KEY FOUND ` message, where we can see the password.



Then I change my password to `lslnb123`, which is not on the list, and repeat doing the things above.

`aircrack-ng -w /usr/share/wordlists/fern-wifi/common.txt ~/Desktop/admin123.cap 
Opening /root/Desktop/lslnb123.cap`

![image-20201109031209982](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109031209982.png)



![image-20201109031235458](C:\Users\Lori\Desktop\Course\ComputerScience\CS315\lab6\pictures\image-20201109031235458.png)

Then the `aircrack-ng` fails to crack the WiFi.

**I cooperate with my classmates to solve this problem, as mentioned above, with Jiaxi Zhang, Qiushi Nie, and Zunyao Mao.**