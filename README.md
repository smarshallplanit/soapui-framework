


# SOAPUI-framework


A simple SOAPUI framework to get people started with basic Groovy scripts for data-driven testing on the SOAPUI free version. And a guide to help you understand what is going on.  

## **Please Note: This is a guide from my experiences and I'm relatively new to these concepts also and will strive to polish this guide as time goes on**

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

What things you need to install the software and how to install them

Install SOAPUI Open Source 
```
https://www.soapui.org/downloads/soapui.html
```
Download JXL library 

```
http://www.java2s.com/Code/Jar/j/Downloadjxl26jar.htm
```
add the JXL.jar file in the lib folder in your SOAPUI install directory typically "C:\Program Files\SmartBear\SoapUI-*.*.*\lib"

## Setting up a SOAPUI project

### First Steps 

Open SOAPUI and select one of these options 

 - Empty 
 - REST
 - SOAP
 - Import

For this example, we will select REST 
and enter this URI
```
https://petstore.swagger.io/
```
### Swagger Open API 
The [Open API](https://swagger.io/specification/) Specification (OAS) defines a standard, language-agnostic interface to RESTful APIs which allows both humans and computers to discover and understand the capabilities of the service without access to source code, documentation, or through network traffic inspection. When properly defined, a consumer can understand and interact with the remote service with a minimal amount of implementation logic.

An OpenAPI definition can then be used by documentation generation tools to display the API, code generation tools to generate servers and clients in various programming languages, testing tools, and many other use cases.

**Reading a OPEN API spec**
We will look at this [Petstore](https://petstore.swagger.io/) OpenAPI spec
Within an Open API spec you can see all the available endpoints. 

![
](https://lh3.googleusercontent.com/cDNpTmSGQdpAHgwwVP_Pnd7R9adHs8WKpLLCj4FSFwbS8ZGnC2hL46GTQ_ydDW3kvn8kVPd-AGk "openapispec")

And within those end points you can see what the requst parameters/ body looks like 

![
](https://lh3.googleusercontent.com/n4Yd9Gch5U_wz0bj6A4TlIsYHbwK2WglKzvDY0kV6w0ilrq2YEK7bdah1nne-AAKGMdOm8OPk5M "request")

and also what response you should be expecting 

![response](https://lh3.googleusercontent.com/n56lxuGUo5CksRqtclwaOhUDydaY-cvIphE0eXGk7sB-nfAy6KlG0ZINZP5cDbMBHA67e8TsjJY)

There is a feature to "Try it out" and send an example request without going through SOAPUI 

![tryitout](https://lh3.googleusercontent.com/26Bbj-OpriFhb_6Lwd2QtZ-bJTx4mK6vNBe1Y-Xd2e9e4PL7yBoIuWsTmTqwiwurcSnxAixyiHo)

### Project structure

Within SOAPUI the project structure is important to understand 

![Basic SOAPUI project structure](https://lh3.googleusercontent.com/zk7hlD3KUVPjichmtpkVEtg0Tz7dR8Z1FQdT8JA-b3CLJTBlH-UGhIOKDSSs4Haf8mI7vLbroXE "Project structure")

 - *Project*: The project is saved as an XML file and this contains everything you add in SOAPUI this is not a folder where you can save
   datasheets or other files, itself will be contained within a
   directory on your machine
   
 - *Test Suite*: A project can have many Test Suites, these are used to separate sections of the API/Webservices you are testing.....
   
  - *Test Case*:  A Test suite can have multiple test cases within it......
   
  - *Test Steps*:  In SOAPUI there are many different test steps you can use.

**Test Steps**

![
](https://lh3.googleusercontent.com/6v-gFu74HSwL4nS49Zcw7ZOilLO2Zj0N05Qe4xk1UB7BeSyXXbvUKclB4kc3Q2Ck0NlxsxC8qYg "Test Steps")
The most popular test steps are *Groovy Scripts* and *Requests* 

**Groovy**: [Groovy Script](http://www.groovy-lang.org/)  test step is included for custom automation test script creation in SoapUI / Pro. It can be used for functional/ load/regression.

Groovy is a scripting language which internally includes all the Java libraries, therefore all java related keywords and functions can be used in the groovy script directly. 




## Getting into it...

Going to go over some key features and concepts to remember when using SOAPUI open source. 

### Properties


 Properties in SOAPUI can be set at the Test Suite, Test Case and also at the Test Step level.

Properties can be set manually by selecting the Suite, Test Case and adding custom properties with Name and Value. 

![
](https://lh3.googleusercontent.com/0O02hYmD81mQIlb3YY0B1jX12aA9x7t2mfZZhAa6PguXu7a-ZMDCnPn0l-U0ze4TqBlN3W0yQNA "Custom properties")

or they can be sent by **Groovy** scripts 

This example is for setting a property at the test suite level
```
testRunner.testCase.testSuite.setPropertyValue("PropertyName","value")
```
and this example is for setting a property at the test case level 

```
testRunner.testCase.setPropertyValue("PropertyName","value")
```
Using properties 
properties can be used in request bodys/parameter by using this syntax

    ${TestSuite/TestCase#propertyName}

example shown below

![
using prop](https://lh3.googleusercontent.com/a8XeKSobqn4E063kRzj9CtUVLPV2Y6eylfIsnDdvjr_SJ7UIgOU8ndi5W91iac51jTxaR85tCkQ "using prop")
In this example an example custom property that needs to be set is the FileName under the test suite. 
eg `FileName = newusers.xls`

### Data-driven 

SOAPUI open source doesn't provide you with a Data source feature like ReadyAPI, therefore, you need to use Groovy script to read from datasheets.

This datadriver.groovy script reads the contents of an excel spreadsheet and creates properties for each column and populates them. 

**Before:** make sure you set the custom property FileName @ the testsuite level to the correct file name. In this case newusers.xls.....
```groovy
// IMPORT THE LIBRARIES WE NEED
import com.eviware.soapui.support.XmlHolder
import jxl.*
import jxl.write.* //Import JXL from http://www.java2s.com/Code/Jar/j/Downloadjxl26jar.htm


 
// DECLARE THE VARIABLES

def myTestCase = context.testCase //myTestCase contains the test case
 
def counter, next, previous, size, columns //Variables used to handle the loop and to move inside the file

def groovyUtils = new com.eviware.soapui.support.GroovyUtils(context)

def projectDir = groovyUtils.projectPath // Get the project path 


def filename= testRunner.testCase.testSuite.getPropertyValue("FileName") //Get the property value of filename in your test suite.
 
Workbook workbook1 = Workbook.getWorkbook(new File(projectDir+"/"+filename)) //file containing the data
 
Sheet sheet1 = workbook1.getSheet(0) //save the first sheet in sheet1
 
size= sheet1.getRows().toInteger() //get the number of rows, each row is a data set

columns = sheet1.getColumns().toInteger() //number of columns
 
counter = testRunner.testCase.testSuite.getPropertyValue("Count").toString() //counter variable contains iteration number
 
counter = counter.toInteger() 

 
next = (counter > size-2? 0: counter+1) //set the next value


//Get the headers from the datasheet

def columnhead = []
def n=  0
while(columns!=n){

Cell head = sheet1.getCell(n,0)//(column,row)
header = head.getContents()
columnhead.add(header)
n++

}
log.info "HEADERS" + columnhead




// Obtaining the data you need from the datasheet.

n = 1 //n starts at one to avoid taking the top row (headers)
col = 0
def rowdata = []//Create an Arraylist to store the row data 
while(n!=size){
//Increment through each column and add it to the Arraylist    
while (col!=columns){
    
Cell rdata = sheet1.getCell(col,counter)//(column,row) Top row 
data    = rdata.getContents()
rowdata.add(data)
col++

}
n++
    }

log.info "ROWDATA" + rowdata

workbook1.close() //close the file
 
//Assigning the Property names and values from the two Arraylists
n = 0
//
while(n!=columns){
testRunner.testCase.testSuite.setPropertyValue(columnhead[n],rowdata[n])
n++
 
}

 
testRunner.testCase.testSuite.setPropertyValue("Count", next.toString()) //increase Count value
  
testRunner.testCase.testSuite.setPropertyValue("Next", next.toString()) //set Next value on the properties step
 
//Decide if the test has to be run again or not
 
if (counter == size-1)
 
{

testRunner.testCase.testSuite.setPropertyValue("StopLoop","T")

log.info "Setting the stoploop property now..."

testRunner.testCase.testSuite.setPropertyValue("Count","1")//Set count back to one to avoid extracting header row

}
 
else if (counter==0)
 
{

 testRunner.testCase.testSuite.setPropertyValue("StopLoop","F")
 
}
 
else
 
{
    
    testRunner.testCase.testSuite.setPropertyValue("StopLoop","F")
 
}
 
```

### Looping through the rows 
This script reads the Stoploop property set in the Datadriver and decides if the datadriver needs to run again to collect another row of data. 


```groovy
// loop.groovy

endLoop = testRunner.testCase.testSuite.getPropertyValue("StopLoop").toString()
log.info "end loop value after get property  " + endLoop
if (endLoop.toString() != 'F')
 
{

log.info ("Exit Groovy Data Source Looper")


}
 

else {
log.info "Running testcase again"
runner = context.getProperty("#CallingTestCaseRunner#").testCase.run(new com.eviware.soapui.support.types.StringToObjectMap(), true)




}
```
In the Else statement it is calling the parent test case in the image below the loop step is running the loop groovy script above and if there is still rows of data it calls the parent which is "datarequestloop" and runs through each step again.
![
](https://lh3.googleusercontent.com/NaETilI01eiKbjJvu8zEsjSghtI89lLlPCtcLE-QGwcBTCvZXHfJyjh3rvarH_lAWl9Bu5zEt08 "DataRequestLoop")

### Reusability 

Re-using Scripts and Requests is essential in building a SOAPUI project. You don't want to be creating duplicates on top of duplicates of a particular script or request step.

One of the best ways to reuse scripts and requests is the **Run TestCase** test step 
![
](https://lh3.googleusercontent.com/7U41hGWLeNZTs3fv4ezGQMrqgu0YNU4f9NKiSwttSkb-GBPFXJHtHMJhZwxQZ_k4O2ARTtiseks "Run testcase")
![enter image description here](https://lh3.googleusercontent.com/T0vvJpjk22gQhRxtPS6rZ2QQFIVDqXNsXzLVRTbjKMVs3Pcf67GgxfxbU-rV-YGZ68qYHCjU8Bo)

-    For example, if you have created a Groovy script for reading from a spreadsheet and you want to reuse that same script in different scenarios you can use the Run test case step to include it in any test case within any test suite you would like. If your script is setting properties at a test suite level....... This example is included in the project provided. In the datarequestloop testCase. 

![
](https://lh3.googleusercontent.com/NaETilI01eiKbjJvu8zEsjSghtI89lLlPCtcLE-QGwcBTCvZXHfJyjh3rvarH_lAWl9Bu5zEt08 "DataRequestLoop")

Here you can see 3 "Run TestCase" test steps for datadriver ,createuser, and loop. 
The Groovy scripts are only logging information. 
....

### Reporting 
To generate a report you can ask SOAPUI to produce it through the TestRunner you can launch testRunner by right-clicking on the Test suite test case or the entire project you want to run. 
Go to the reports tab and select the two options shown below. Then set the Root Folder to where you want to save the reports. 

![
](https://lh3.googleusercontent.com/AxRw8T4IFYGmi8F9oGTaYTYmPLk6v-WDvkWXgQif_HzXCx2fDRirK_Uek_zaj6H7sectQMR-MC4 "reporting")

These reports are generated in an XML format and are not presentable. You want to convert the XML file to HTML, [Apache Ant](https://ant.apache.org/) converts JUnit XML to HTML. 

You typically have to run [ANT](https://ant.apache.org/) from the command line. I have built a batch script which you can from within a Groovy script. (Which is included in this project folder)

## Testing in SOAPUI 

### Test Cases
I found that creating a test case for each API request allows for greater reusability. For example 

> you may use A request such as login multiple times so you can create one testCase which sends a request to that API endpoint and assert the response and then re-use in another testcase such as an end-to-end scenario “Login and update a users details ” by running it through a “Run testcase” test step



### Assertions
Adding  [Assertions](https://www.guru99.com/assertions-soapui-complete-tutorial.html) is an important part of testing in SOAPUI. They are added to requests within a testcase.
 Listed below are a few of the more common assertions used in SOAPUI click the links for more information. 
- [**Xpath**](https://www.soapui.org/docs/functional-testing/validating-messages/validating-xml-messages.html) :  All messages received by sampler TestSteps are internally converted to an XML counterpart, which provides a common ground for assertions and other post-processing. This also makes way for two of the most powerful assertions, XPath Match and XQuery Match, which both utilize the named technologies to provide fine-grained message validation possibilities.
- [**JSONpath**](https://www.soapui.org/docs/functional-testing/validating-messages/validating-json-messages.html): JSON messages received by TestSteps can be asserted directly through the JSON structure. Much like with XML, you can do matches (Match, RegEx Match) and JsonPath validation (Count, Existence).
- **Valid/Invalid HTTP Status Codes** : checks that the target TestStep received an HTTP result with a status code in the list of defined codes. Applicable to any TestStep that receives HTTP messages.
- [**Contains**](https://www.guru99.com/assertions-soapui-complete-tutorial.html#11) : Searches for the existence of the specified string. It also supports regular expression.
 
 The assertions determine if a test has passed or failed. 

## Checklist 
Have you achieved all these? If so you should be ready to go and start building up your project. 

 - [ ] Created REST project using a URI
 - [ ] Open up the Open API spec
 - [ ] Understand how to read Open API spec
 - [ ] Understand the SOAPUI project structure
 - [ ] Understand SOAPUI properties
 - [ ] Understand Groovy Scripting
 - [ ] Understand Testcase reusability 
 - [ ] Understand reporting
 - [ ] Understand the Assertions

## Built With

* Groovy Script
* SOAPUI


## Contribute
Please ask any questions or point out any mistakes 
[feedback here](mailto:smarshall@planittesting.com) 