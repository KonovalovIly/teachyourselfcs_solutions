[[Practice Problems 10]]

In this chapter we will cover how our program can use standart and unix io operation
 10.1 Unix I/O	
    All io devices in unix system looks like file, doesn’t matter is it network response or disk data
10.2 Files	
	Files has pathname which represent location of this file. Pathname may be relative or absolute.
 10.3 Opening and Closing Files	
    For opening the file we set permission and other instruction flags. It helpfull for system to recognize our intention and open file in right way
 10.4 Reading and Writing Files	
	We have read and write function witch return number of bytes or -1 in error case
10.5 Robust Reading and Writing with the Rio Package	
       It is more powerful copy of base io operation, they are thread safe and has less memory usage
       10.5.1 Rio Unbuffered Input and Output Functions	
	    This functions copy file data directly to the pointer and they interrupt safe
    10.5.2 Rio Buffered Input Functions	
        We may use buffered version rio functions 
 10.6 Reading File Metadata
    Two ways for reading metadata of selected file, we can read concreat data or get all structure with info
10.7 Reading Directory Contents
    From C code we can read all files from directory, and go throw all this files or directories
10.8 Sharing Files
	Descriptor table helps our processes and programs tracks stream owner and pass it to child.
10.9 I/O Redirection
    Function wich redirect output to other output for example we can redirect terminal output to file output. Special character in terminal ls > text.txt
10.11 Putting It Together: Which I/O Functions Should I Use?
      Recommendations for picking function to read data.
10.12 Summary
	We cover unix and c lang functions for open read and write files. All IO operations execute like on file